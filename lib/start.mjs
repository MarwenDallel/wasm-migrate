import { getClient } from "./mqtt/mqttClient.mjs";
import { AsyncifyData, AsyncifyWrapper } from "./utils/asyncifyWrapper.mjs";
import { createInstance } from "./utils/compiler.mjs";
import dataTransformer from "./utils/dataTransformer.mjs";

let asyncify = new AsyncifyWrapper();

const migrationCb = (migrationData) => {
  console.log("Migration event issued");
  let client = getClient();
  const encodedData = dataTransformer.encode(migrationData);
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
