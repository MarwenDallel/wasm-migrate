import { decode } from "@webassemblyjs/wasm-parser";
import fs from "fs";

// Open wat file and read it
const binary = fs.readFileSync("wasm/fibonacci.target.wasm");

const decoderOpts = {};
const ast = decode(binary, decoderOpts);

// Write ast to file as json
fs.writeFileSync("wasm/fibonacci.target.json", JSON.stringify(ast, null, 2));
