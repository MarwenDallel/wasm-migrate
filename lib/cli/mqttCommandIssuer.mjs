import dataTransformer from "../utils/dataTransformer.mjs";
import fs from "fs";
import * as mqtt from "mqtt";
import mqttConfig from "../../config/mqttConfig.mjs";
import AsyncMqtt from "async-mqtt";

const startClient = () => {
  const { brokerUrl, ...options } = mqttConfig;
  delete options.clientId;
  // @ts-ignore
  let client = mqtt.connect(brokerUrl, options);
  return new AsyncMqtt.AsyncClient(client);
};

export default {
  startOrResume: (cid, wasmFile, fn, args, dumpFile, optimize) => {
    let client = startClient();
    client
      .on("connect", () => {
        console.log(`Connected to MQTT broker`);
      })
      .on("reconnect", (error) => {
        console.log("reconnecting:", error);
      })
      .on("error", (error) => {
        console.log("Connection failed:", error);
      });
    const wasmBuffer = fs.readFileSync(wasmFile);
    const dumpBuffer = dumpFile ? fs.readFileSync(dumpFile) : null;
    const encodedData = dataTransformer.encode({
      wasmBinary: wasmBuffer,
      dumpBinary: dumpBuffer,
      startFn: { name: fn, args },
    });
    client
      .publish(`devices/${cid}/start`, encodedData, {
        qos: 1,
      })
      .then(() => {
        console.log("Start message published");
        return client.end();
      });
  },
  migrate: (src, dst) => {
    let client = startClient();
    // Issue migration events to all clients for now
    client
      .publish(`devices/${src}/migrate/${dst}`, "migrate", { qos: 1 })
      .then(() => {
        console.log("Migration event issued to client " + dst);
      })
      .catch((error) => {
        console.log("Error issuing migration event:", error);
      })
      .finally(() => {
        return client.end();
      });
  },
};
