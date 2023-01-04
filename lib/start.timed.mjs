import { getClient } from "./mqtt/mqttClient.mjs";
import { AsyncifyData, AsyncifyWrapper } from "./utils/asyncifyWrapper.mjs";
import { createInstance } from "./utils/compiler.mjs";
import dataTransformer from "./utils/dataTransformer.mjs";
import fs from "fs";

let asyncify = new AsyncifyWrapper();

const migrationCb = (migrationData) => {
  migrationData["startTime"] = process.hrtime.bigint();
  console.log("Migration event issued");
  let client = getClient();
  const encodeStart = process.hrtime.bigint();
  const encodedData = dataTransformer.encode(migrationData);
  const encodeEnd = process.hrtime.bigint();
  console.log(`[encode] Execution time: ${encodeEnd - encodeStart} ns`);
  if (!fs.existsSync("./benchmark/results/nodejs/encode_times.csv")) {
    fs.writeFileSync(
      "./benchmark/results/nodejs/encode_times.csv",
      "ClientID,Platform,Encode Start (ns),Encode End (ns)"
    );
  }
  fs.appendFileSync(
    "./benchmark/results/nodejs/encode_times.csv",
    `\n${client._client.options.clientId},${process.platform},${encodeStart},${encodeEnd}`
  );

  client
    .publish(`devices/${asyncify.migrate}/start`, encodedData, { qos: 2 })
    .then(() => {
      console.log("Start message published");
    })
    .catch((error) => {
      console.log("Error publishing start message:", error);
    })
    .finally(() => {
      asyncify.migrate = null;
      asyncify.startUnwind();
      asyncify = new AsyncifyWrapper();
      console.log("Execution interrupted");
    });
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
  const decodeStart = process.hrtime.bigint();
  let migrationData = dataTransformer.decode(payload);
  const decodeEnd = process.hrtime.bigint();
  console.log(`[decode] Execution time: ${decodeEnd - decodeStart} ns`);
  let client = getClient();
  if (migrationData.startTime) {
    migrationData["endTime"] = process.hrtime.bigint();
    // Write to csv file the start and end time, first add the header
    if (!fs.existsSync("./benchmark/results/nodejs/times.csv")) {
      fs.writeFileSync(
        "./benchmark/results/nodejs/times.csv",
        "ClientID,Platform,Decode Start (ns),Decode End (ns),Migration Start (ns),Migration End (ns),Migrata Data Size (bytes)"
      );
    }
    fs.appendFileSync(
      "./benchmark/results/nodejs/times.csv",
      `\n${client._client.options.clientId},${process.platform},${decodeStart},${decodeEnd},${migrationData.startTime},${migrationData.endTime},${payload.length}`
    );
  }
  startExecution(migrationData);
};

const migrationHandler = (topic) => {
  // extract the cid from the topic
  const destinationId = topic.split("/").pop();
  console.log(`Migration will be forwarded to ${destinationId}`);
  asyncify.migrate = destinationId;
};

export function runPassive(clientId) {
  const { _client: client } = getClient(clientId);
  const cid = client.options.clientId;

  const migrationTarget = new RegExp(`devices/${cid}/migrate/(?<dstId>\\w+)`);
  client.on("message", (topic, payload) => {
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
  });
}
