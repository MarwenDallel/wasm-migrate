import dataTransformer from "../utils/dataTransformer.mjs";
import fs from "fs";
import * as mqtt from "mqtt";
import mqttConfig from "../../config/mqttConfig.mjs";

const startClient = () => {
  console.log("Starting MQTT client");
  const { brokerUrl, options } = mqttConfig;
  // @ts-ignore
  return mqtt.connect(brokerUrl, options);
};

export default {
  startOrResume: (wasmFile, fn, args, dumpFile, optimize) => {
    let client = startClient();
    const wasmBuffer = fs.readFileSync(wasmFile);
    const dumpBuffer = dumpFile ? fs.readFileSync(dumpFile) : null;
    const encodedData = dataTransformer.encode({
      wasmBinary: wasmBuffer,
      dumpBinary: dumpBuffer,
      startFn: { name: fn, args },
    });
    console.log("Publishing start message");
    client.publish("execution/start", encodedData);
  },
  migrate: (src, dst) => {
    let client = startClient();
    // Issue migration events to all clients for now
    client.publish(`execution/migrate`, "migrate");
  },
};
