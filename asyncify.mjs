import * as Asyncify from "asyncify-wasm";
import * as fs from "fs";
import { startClient } from "./lib/mqtt/mqttClient.mjs";
import metadataTransformer from "./lib/utils/binaryTransformer.mjs";
import { stackRepr } from "./lib/utils/debug.js";

let migrate = false;
const client = startClient();
const wasmBinary = fs.readFileSync("wasm/fibonacci.async.wasm");
let migrationData = {
  wasmBinary,
  dumpBinary: null,
  startFn: {
    name: "fibonacci",
    args: [10],
  },
};

const exportDump = () => {
  let memory = Buffer.from(instance.exports.memory.buffer);
  migrationData["dumpBinary"] = memory;
  const buffer = metadataTransformer.encode(migrationData);
  fs.writeFileSync("migrationData.bin", buffer);
  client.publish("migrate/migrationData", buffer);
};

const readDump = () => {
  const buffer = fs.readFileSync("migrationData.bin");
  migrationData = metadataTransformer.decode(buffer);
  return migrationData;
};

let importObject = {
  env: {
    sleep: (ms) => {
      console.log(`sleeping for ${ms}ms`);
      const stack = view.slice(16 >> 2, (16 >> 2) + 7);
      console.log(importObject.env.log("eeeeodeo"));
      return new Promise((resolve) => {
        setTimeout(() => {
          if (migrate) {
            exportDump();
            migrate = false;
          }
          resolve();
        }, ms);
      });
    },
  },
};

let { instance } = await Asyncify.instantiate(wasmBinary, importObject);

const view = new Int32Array(instance.exports.memory.buffer);

client.on("message", async (topic, message) => {
  if (topic === "resume") {
    console.log(`Topic: ${topic}, Message: ${message.toString()}`);
    let stack = view.slice(16 >> 2, (16 >> 2) + 7);
    stackRepr(stack);
    migrationData = readDump();
    console.log("migrationData", migrationData);
    const dumpArray = new Int32Array(migrationData.dumpBinary);
    stackRepr(dumpArray.slice(16 >> 2, (16 >> 2) + 7));

    // view.set(, 0);
    const result = await instance.exports.fibonacci(10);
    console.log(result);
  }
  if (topic === "migrate") {
    console.log(`Topic: ${topic}, Message: ${message.toString()}`);
    migrate = true;
  }
});
