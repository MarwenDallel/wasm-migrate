import binaryen from "binaryen";
import fs from "fs";

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
      if (!sleeping) {
        // We are called in order to start a sleep/unwind.
        console.log("sleep...");
        // Fill in the data structure. The first value has the stack location,
        // which for simplicity we can start right after the data structure itself.
        view[DATA_ADDR >> 2] = DATA_ADDR + 8;
        // The end of the stack will not be reached here anyhow.
        view[(DATA_ADDR + 4) >> 2] = 1024;
        console.log(view);
        // write view to file
        fs.writeFileSync("./dump/fibonacci.test.bin", Buffer.from(view.buffer));
        wasmExports.asyncify_start_unwind(DATA_ADDR);
        sleeping = true;
        // Resume after the proper delay.
        setTimeout(function () {
          console.log("timeout ended, starting to rewind the stack");
          wasmExports.asyncify_start_rewind(DATA_ADDR);
          // The code is now ready to rewind; to start the process, enter the
          // first function that should be on the call stack.
          wasmExports.fibonacci(46);
        }, ms);
      } else {
        // We are called as part of a resume/rewind. Stop sleeping.
        console.log("...resume");
        wasmExports.asyncify_stop_rewind();
        sleeping = false;
      }
    },
  },
};

const instance = new WebAssembly.Instance(compiled, importObject);

const wasmExports = instance.exports;
const view = new Int32Array(wasmExports.memory.buffer);

// Global state for running the program.
const DATA_ADDR = 48; // Where the unwind/rewind data structure will live.
let sleeping = false;

// Run the program. When it pauses control flow gets to here, as the
// stack has unwound.
wasmExports.fibonacci(46);
console.log("stack unwound");
wasmExports.asyncify_stop_unwind();
