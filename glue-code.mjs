import binaryen from "binaryen";
import fs from "fs";
import { AsyncifyWrapper } from "./utils/asyncifyWrapper.js";

// Get a WebAssembly binary and compile it to an instance.
const filePath = process.argv[2] || "./fibonacci.opt.wasm";
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
        wrapper.asyncifyData.toFile();
        console.log("Current state:", wrapper.getState());
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
  },
};

const instance = new WebAssembly.Instance(compiled, importObject);

const startFnCallback = function () {
  return instance.exports.fibonacci(46);
};
const wrapper = new AsyncifyWrapper(startFnCallback, instance.exports);

wrapper.start();
console.log("stack unwound");
wrapper.stopUnwind();
