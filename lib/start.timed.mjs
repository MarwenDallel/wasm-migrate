import { getClient } from "./mqtt/mqttClient.mjs";
import { AsyncifyData, AsyncifyWrapper } from "./utils/asyncifyWrapper.mjs";
import { createInstance } from "./utils/compiler.mjs";
import dataTransformer from "./utils/dataTransformer.mjs";
import fs from "fs";

let asyncify = new AsyncifyWrapper();

const ENCODE_TIMES_FILE = "./benchmark/results/nodejs/encode_times.csv";
const MIGRATION_TIMES_FILE = "./benchmark/results/nodejs/decode_times.csv";
const STARTUP_TIMES_FILE = "./benchmark/results/nodejs/startup_times.csv";

if (!fs.existsSync(ENCODE_TIMES_FILE)) {
  fs.writeFileSync(
    ENCODE_TIMES_FILE,
    "ClientID,Platform,Encode Start (ns),Encode End (ns), Encode Time (ns)"
  );
}

if (!fs.existsSync(STARTUP_TIMES_FILE)) {
  fs.writeFileSync(
    STARTUP_TIMES_FILE,
    "ClientID,Platform,Event,Start time (ns),End Time (ns),Startup Time (ns)"
  );
}

if (!fs.existsSync(MIGRATION_TIMES_FILE)) {
  fs.writeFileSync(
    MIGRATION_TIMES_FILE,
    "ClientID,Platform,Decode Start (ns),Decode End (ns),Migration Start (ns),Migration End (ns),Migration Time (ns),Migrata Data Size (bytes)"
  );
}

const migrationCb = (migrationData) => {
  migrationData["startTime"] = process.hrtime.bigint();
  console.log("Migration event issued");
  let client = getClient();
  const encodeStart = process.hrtime.bigint();
  const encodedData = dataTransformer.encode(migrationData);
  const encodeEnd = process.hrtime.bigint();

  fs.appendFileSync(
    ENCODE_TIMES_FILE,
    `\n${client._client.options.clientId},${
      process.platform
    },${encodeStart},${encodeEnd},${encodeEnd - encodeStart}`
  );

  client
    .publish(`devices/${asyncify.migrate}/start`, encodedData, { qos: 1 })
    .then(() => {
      console.log("Start message published");
    })
    .catch((error) => {
      console.log("Error publishing start message:", error);
    })
    .finally(() => {
      asyncify.migrate = null;
      asyncify.startUnwind();
      //asyncify = new AsyncifyWrapper();
      console.log("Execution interrupted");
    });
};

function startExecution(migrationData, programStartTime) {
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

  let client = getClient();

  if (dumpBinary) {
    console.log("Loading dump into memory");
    const data = AsyncifyData.fromBinary(
      dumpBinary,
      48,
      instance.exports.memory
    );
    asyncify.data = data;
  }

  let event = dumpBinary ? "resume" : "start";
  const programEndTime = process.hrtime.bigint();
  const startupTime = programEndTime - programStartTime;

  fs.appendFileSync(
    STARTUP_TIMES_FILE,
    `\n${client._client.options.clientId},${event},${process.platform},${programStartTime},${programEndTime},${startupTime}`
  );

  if (dumpBinary) {
    asyncify.startRewind();
  } else {
    asyncify.start();
    console.log("stack unwound");
    asyncify.stopUnwind();
  }
}

const startHandler = (payload, programStartTime) => {
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
    fs.appendFileSync(
      MIGRATION_TIMES_FILE,
      `\n${client._client.options.clientId},${
        process.platform
      },${decodeStart},${decodeEnd},${migrationData.startTime},${
        migrationData.endTime
      },${migrationData.endTime - migrationData.startTime},${payload.length}`
    );
  }
  startExecution(migrationData, programStartTime);
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
      // Program start time is measured here
      const programStartTime = process.hrtime.bigint();
      console.log("Program Start Time", programStartTime);
      startHandler(payload, programStartTime);
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
