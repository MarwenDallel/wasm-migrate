const fs = require("fs");

function readDump() {
  const dump = fs.readFileSync("../dump/fibonacci.bin");
  console.log(new Int32Array(dump.buffer));
  return new Int32Array(dump.buffer);
}

readDump();
module.exports.readDump = readDump;
