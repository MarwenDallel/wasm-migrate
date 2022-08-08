import binaryen from "binaryen";
import fs from "fs";
import path from "path";
import { exit } from "process";
import { AsyncifyData, AsyncifyWrapper } from "./utils/asyncifyWrapper.js";
import { stackRepr } from "./utils/debug.js";
import { startClient } from "./ws/wsClient.mjs";

// TODO: make wrapper accessible to importObject without global
let wrapper = null;

function compile(filePath, optimize) {
  const wasm = fs.readFileSync(filePath);
  // Get a WebAssembly binary and compile it to an instance.
  const ir = new binaryen.readBinary(wasm);
  binaryen.setOptimizeLevel(1);
  if (optimize) {
    // Run the Asyncify pass
    try {
      ir.runPasses(["asyncify"]);
    } catch (e) {
      console.log("File is already optimized");
    }
  }

  return new WebAssembly.Module(ir.emitBinary());
}

function instantiate(compiled, filename) {
  let importObject = {
    env: {
      sleep: function (ms) {
        if (!wrapper.sleeping) {
          // We are called in order to start a sleep/unwind.
          console.log("sleep...");
          wrapper.startUnwind();

          // Resume after the proper delay.
          setTimeout(function () {
            console.log("timeout ended, starting to rewind the stack");
            stackRepr(wrapper.asyncifyData.getData(7));
            if (wrapper.migrate) {
              console.log("Migration event issued");
              // TODO: send the dump and fibonacci file to the server.
              // Server should forward files to another client.
              wrapper.asyncifyData.toFile(filename);
              exit(0);
            }
            wrapper.startRewind();
          }, 1000);
        } else {
          // We are called as part of a resume/rewind. Stop sleeping.
          console.log("...resume");
          wrapper.stopRewind();
        }
      },
    },
  };
  return new WebAssembly.Instance(compiled, importObject);
}

function initiate(wasmFile, startFnName, optimize, args) {
  const filename = path.parse(wasmFile).name;
  const compiled = compile(wasmFile, optimize);
  const instance = instantiate(compiled, filename);

  const startFn = instance.exports[startFnName];
  if (!startFn) throw new Error(`No function ${startFnName} found`);
  if (startFn.length !== args.length)
    throw new Error(
      `Function ${startFnName} takes ${startFn.length} arguments, but ${args.length} were given`
    );
  const startFnCallback = function () {
    return startFn(...args);
  };

  return {
    startFnCallback,
    instance,
  };
}

export function run(wasmFile, startFnName, args, dumpFile, optimize, port) {
  const { startFnCallback, instance } = initiate(
    wasmFile,
    startFnName,
    optimize,
    args
  );

  if (dumpFile) {
    const data = AsyncifyData.fromFile(dumpFile, 48, instance.exports.memory);
    wrapper = new AsyncifyWrapper(startFnCallback, instance.exports, data);
    startClient(wrapper, port);
    wrapper.startRewind();
  } else {
    wrapper = new AsyncifyWrapper(startFnCallback, instance.exports);
    startClient(wrapper, port);
    wrapper.start();
    console.log("stack unwound");
    wrapper.stopUnwind();
  }
}
