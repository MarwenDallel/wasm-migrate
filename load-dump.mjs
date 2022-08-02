import binaryen from "binaryen";
import fs from "fs";
import { AsyncifyWrapper, AsyncifyData } from "./utils/asyncifyWrapper.js";
import { stackRepr } from "./utils/debug.js";

// Get a WebAssembly binary and compile it to an instance.
const filePath = "./fibonacci.async.wasm";
const dumpPath = process.argv[2] || "./fibonacci.bin";
const ir = new binaryen.readBinary(fs.readFileSync(filePath));

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
          wrapper.startRewind();
        }, ms);
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

const data = AsyncifyData.fromFile(
  `./dump/${dumpPath}`,
  48,
  instance.exports.memory
);

const wrapper = new AsyncifyWrapper(
  startFnCallback,
  instance.exports,
  data,
  true
);

stackRepr(wrapper.asyncifyData.getData(7));
wrapper.startRewind();
