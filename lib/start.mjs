import { getClient } from "./mqtt/mqttClient.mjs";
import { AsyncifyData, AsyncifyWrapper } from "./utils/asyncifyWrapper.mjs";
import { createInstance } from "./utils/compiler.mjs";
import dataTransformer from "./utils/dataTransformer.mjs";

let asyncify;

function migrationCb(migrationData) {
  console.log("Migration event issued");
  let client = getClient();
  const encodedData = dataTransformer.encode(migrationData);
  client.publish("execution/migrate", encodedData);
}

function startExecution(migrationData) {
  const {
    wasmBinary,
    dumpBinary,
    startFn: { name, args },
  } = migrationData;

  // Pass null asyncify to the compiler.
  const instance = createInstance(asyncify, wasmBinary, migrationCb, false);
  // Initialize the asyncify wrapper.
  asyncify = new AsyncifyWrapper(name, args, instance.exports);

  asyncify.migrationData["wasmBinary"] = wasmBinary;

  if (dumpBinary) {
    console.log("Loading dump into memory");
    const data = AsyncifyData.fromBinary(
      dumpBinary,
      48,
      instance.exports.memory
    );
    asyncify.data = data;
  }

  if (dumpBinary) {
    asyncify.startRewind();
  } else {
    asyncify.start();
    console.log("stack unwound");
    asyncify.stopUnwind();
  }

  return asyncify;
}

const startHandler = (payload) => {
  let migrationData = dataTransformer.decode(payload);
  console.log("Migration data:", migrationData);
  startExecution(migrationData);
};

export function runPassive() {
  const client = getClient();

  client.on("message", (topic, payload, packet) => {
    switch (topic) {
      case "execution/start":
      case "execution/resume":
        console.log(
          `Topic: ${topic}, Message: ${payload.toString()}, QoS: ${packet.qos}`
        );
        startHandler(payload);
        break;
      case "execution/migrate":
        console.log(
          `Topic: ${topic}, Message: ${payload.toString()}, QoS: ${packet.qos}`
        );
        asyncify.migrate = true;
        break;
      default:
        break;
    }
  });
}
