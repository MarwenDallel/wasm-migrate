import binaryen from "binaryen";
import fs from "fs";
import { exit } from "process";
import { AsyncifyWrapper } from "./utils/asyncifyWrapper.js";
import { stackRepr } from "./utils/debug.js";

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

let it = 0;

let importObject = {
  env: {
    sleep: function (ms) {
      if (!wrapper.sleeping) {
        // We are called in order to start a sleep/unwind.
        console.log("sleep...");
        wrapper.startUnwind();

        it++;
        // Resume after the proper delay.
        setTimeout(function () {
          console.log("timeout ended, starting to rewind the stack");
          stackRepr(wrapper.asyncifyData.getData(7));
          if (it == 5) {
            wrapper.asyncifyData.toFile();
            exit(0);
          }
          wrapper.startRewind();
        }, 0);
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

wrapper.start();
console.log("stack unwound");
wrapper.stopUnwind();
