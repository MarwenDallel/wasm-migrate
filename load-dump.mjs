import binaryen from "binaryen";
import fs from "fs";
import { AsyncifyWrapper, AsyncifyData } from "./utils/asyncifyWrapper.js";

// Get a WebAssembly binary and compile it to an instance.
const filePath = process.argv[2] || "./fibonacci.opt.wasm";
const ir = new binaryen.readBinary(fs.readFileSync(filePath));

const binary = ir.emitBinary();
const compiled = new WebAssembly.Module(binary);

let importObject = {
  env: {
    sleep: function (ms) {
      if (!wrapper.sleeping) {
        // We are called in order to start a sleep/unwind.
        console.log("sleep...");

        // wrapper.asyncifyData.toFile();
        wrapper.startUnwind();

        // Resume after the proper delay.
        setTimeout(function () {
          console.log("timeout ended, starting to rewind the stack");
          wrapper.startRewind();
        }, ms);
      } else {
        // We are called as part of a resume/rewind. Stop sleeping.
        console.log("...resume");
        wrapper.stopRewind();
      }
    },
    print: function (str) {
      console.log(str);
    },
  },
};

const instance = new WebAssembly.Instance(compiled, importObject);

const startFnCallback = function () {
  // Manually subtracting from original parameter to reach last known cycle
  return instance.exports.fibonacci(46);
};

const data = AsyncifyData.fromFile(
  "./dump/fibonacci.bin",
  instance.exports.memory
);

const wrapper = new AsyncifyWrapper(
  startFnCallback,
  instance.exports,
  data,
  true
);

console.log("State", wrapper.getState());
console.log("Data", wrapper.getDataGlobal());

//  Manually setting global
wrapper.setDataGlobal(48);
console.log("Data", wrapper.getDataGlobal());

wrapper.startRewind();
console.log("State", wrapper.getState());

//wrapper.start();
console.log("stack unwound");
wrapper.stopUnwind();
