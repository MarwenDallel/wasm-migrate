const fs = require("fs");

// read parameters from command line
const args = process.argv.slice(2);
const dumpFile = args[0] || "./fibonacci.async.wasm";

function readDump(dumpFile) {
  const dump = fs.readFileSync(`./dump/${dumpFile}`);
  console.log(new Int32Array(dump.buffer));
  return new Int32Array(dump.buffer);
}

readDump(dumpFile);
module.exports.readDump = readDump;
