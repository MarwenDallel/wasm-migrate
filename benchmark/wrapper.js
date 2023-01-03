const fs = require("fs");

const wasmFile = process.argv[2];
const funcName = process.argv[3];
const funcArgs = process.argv.slice(4).map((x) => parseInt(x));

WebAssembly.instantiate(new Uint8Array(fs.readFileSync(wasmFile)), {})
  .then((obj) => console.log(obj.instance.exports[funcName](funcArgs)))
  .catch((x) => console.log(x));
