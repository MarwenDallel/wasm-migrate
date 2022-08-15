import fs from "fs";

function readDump() {
  const dump = fs.readFileSync("dump/wasmMigrateClientB.bin");
  console.log(new Uint32Array(dump.buffer), dump.buffer.byteLength);
  return new Uint32Array(dump.buffer);
}

readDump();
