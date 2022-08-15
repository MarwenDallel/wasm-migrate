import { getClient } from "./mqtt/mqttClient.mjs";
import { AsyncifyData, AsyncifyWrapper } from "./utils/asyncifyWrapper.mjs";
import { createInstance } from "./utils/compiler.mjs";
import dataTransformer from "./utils/dataTransformer.mjs";
import fs from "fs";

let asyncify = new AsyncifyWrapper();

const migrationCb = (migrationData) => {
  console.log("Migration event issued");
  let client = getClient();
  const encodedData = dataTransformer.encode(migrationData);
  const _migrationData = dataTransformer.decode(encodedData);

  console.log(migrationData);
  console.log("BYTE LENGTH", _migrationData.dumpBinary.byteLength);
  fs.writeFileSync(`./dump/${asyncify.migrate}.bin`, _migrationData.dumpBinary);
  client.publish(`devices/${asyncify.migrate}/start`, encodedData);
  asyncify.migrate = null;
};

function startExecution(migrationData) {
  const {
    wasmBinary,
    dumpBinary,
    startFn: { name, args },
  } = migrationData;
  // Reinitialize the asyncify instance
  asyncify = new AsyncifyWrapper();
  const instance = createInstance(asyncify, wasmBinary, migrationCb, false);
  // Initialize the asyncify wrapper.
  asyncify.wrap(name, args, instance.exports);
  asyncify.migrationData["wasmBinary"] = wasmBinary;

  if (dumpBinary) {
    console.log("Loading dump into memory");
    // const data = AsyncifyData.fromFile(
    //   "dump/wasmMigrateClientB.bin",
    //   48,
    //   instance.exports.memory
    // );
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
}

const startHandler = (payload) => {
  if (payload.length === 0) {
    console.log("No payload");
    return;
  }
  let migrationData = dataTransformer.decode(payload);
  startExecution(migrationData);
};

const migrationHandler = (topic) => {
  // extract the cid from the topic
  const destinationId = topic.split("/").pop();
  console.log(`Migration will be forwarded to ${destinationId}`);
  asyncify.migrate = destinationId;
};

export function runPassive(clientId) {
  const client = getClient(clientId);
  const cid = client.options.clientId;

  const migrationTarget = new RegExp(`devices/${cid}/migrate/(?<dstId>\\w+)`);
  client.on("message", (topic, payload, packet) => {
    if (topic === `devices/${cid}/start`) {
      startHandler(payload);
    } else if (topic === `devices/${cid}/migrate`) {
      migrationHandler(topic);
    } else {
      // @ts-ignore
      const groups = migrationTarget.exec(topic).groups;
      if (groups) {
        migrationHandler(groups.dstId);
      }
      console.log("Stop execution");
      asyncify.sleeping = false;
    }

    switch (topic) {
      case `devices/${cid}/start`:
        console.log(`Topic: ${topic}, QoS: ${packet.qos}`);
        startHandler(payload);
        break;
      // TODO: Change to support other client names
      case `devices/${cid}/migrate/wasmMigrateClientB`:
        console.log(`Topic: ${topic}, QoS: ${packet.qos}`);
        migrationHandler(topic);
        break;
      default:
        console.log(`Topic: ${topic}, QoS: ${packet.qos}`);
        break;
    }
  });
}
