import binaryen from "binaryen";
import { stackRepr } from "./debug.mjs";

export function compile(wasmFile, optimize) {
  // Get a WebAssembly binary and compile it to an instance.
  const ir = binaryen.readBinary(wasmFile);
  binaryen.setOptimizeLevel(1);
  if (optimize) {
    // Run the Asyncify pass
    try {
      ir.runPasses(["asyncify"]);
    } catch (e) {
      console.log("File is already optimized");
    }
  }
  const binary = ir.emitBinary();
  return new WebAssembly.Module(binary);
}

export function createInstance(asyncify, wasmFile, migrationCb, optimize) {
  const compiled = compile(wasmFile, optimize);

  let importObject = {
    env: {
      sleep: (ms) => {
        if (!asyncify.sleeping) {
          // We are called in order to start a sleep/unwind.
          console.log("sleep...");
          asyncify.startUnwind();

          // Resume after the proper delay.
          setTimeout(function () {
            console.log("timeout ended, starting to rewind the stack");
            stackRepr(asyncify.data.peak(7));
            if (asyncify.migrate) {
              migrationCb(asyncify.migrationData);
              console.log("Migration event issued");
              // exit
            }
            asyncify.startRewind();
          }, ms);
        } else {
          // We are called as part of a resume/rewind. Stop sleeping.
          console.log("...resume");
          asyncify.stopRewind();
        }
      },
    },
  };
  return new WebAssembly.Instance(compiled, importObject);
}
