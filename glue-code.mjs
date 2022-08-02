import binaryen from "binaryen";
import fs from "fs";
import { exit } from "process";
import { AsyncifyWrapper } from "./utils/asyncifyWrapper.js";
import { stackRepr } from "./utils/debug.js";
import { startClient } from "./ws/wsClient.mjs";

// Get a WebAssembly binary and compile it to an instance.
const filePath = process.argv[2] || "./fibonacci.async.wasm";
const ir = new binaryen.readBinary(fs.readFileSync(filePath));
// Run the Asyncify pass, with (minor) optimizations.
try {
  binaryen.setOptimizeLevel(1);
  ir.runPasses(["asyncify"]);
} catch (e) {
  console.log(e);
}
const binary = ir.emitBinary();
const compiled = new WebAssembly.Module(binary);

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
            wrapper.asyncifyData.toFile("fibonacci");
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

const instance = new WebAssembly.Instance(compiled, importObject);

const startFnCallback = function () {
  return instance.exports.fibonacci(10);
};
const wrapper = new AsyncifyWrapper(startFnCallback, instance.exports);

startClient(wrapper);

wrapper.start();
console.log("stack unwound");
wrapper.stopUnwind();
