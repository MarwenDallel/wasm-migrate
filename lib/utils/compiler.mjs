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
      ir.optimize();
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
          asyncify.startUnwind();

          // Resume after the proper delay.
          setTimeout(function () {
            stackRepr(asyncify);
            if (asyncify.migrate) {
              migrationCb(asyncify.migrationData);
            }
            asyncify.startRewind();
          }, ms);
        } else {
          // We are called as part of a resume/rewind. Stop sleeping.
          asyncify.stopRewind();
        }
      },
    },
  };
  return new WebAssembly.Instance(compiled, importObject);
}
