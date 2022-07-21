const fs = require("fs");
const { AsyncifyWrapper } = require("./asyncify");

const filePath = "./fibonacci.wasm";
const wasmModule = fs.readFileSync(filePath);

let importObject = {
  env: {
    sleep: function (ms) {
      if (!wrapper.sleeping) {
        console.log("sleep...");
        wrapper.startUnwind();

        setTimeout(function () {
          console.log("timeout ended, starting to rewind the stack");
          wrapper.startRewind();
        }, ms);
      } else {
        console.log("...resume");
        wrapper.stopRewind();
      }
    },
  },
};

const instance = new WebAssembly.Instance(
  new WebAssembly.Module(wasmModule),
  importObject
);
const startFnCallback = function () {
  return instance.exports.fibonacci(46);
};
const wrapper = new AsyncifyWrapper(startFnCallback, instance.exports);

wrapper.start();
console.log("stack unwound");
wrapper.stopUnwind();
