// @ts-nocheck
import * as mqtt from "mqtt";
import mqttConfig from "../../config/mqttConfig.mjs";
import AsyncMqtt from "async-mqtt";

let asyncClient = null;

function startClient(clientId) {
  console.log("Starting MQTT client");
  const { brokerUrl, ...options } = mqttConfig;
  options.clientId = clientId || options.clientId;
  // @ts-ignore
  const client = mqtt.connect(brokerUrl, options);
  asyncClient = new AsyncMqtt.AsyncClient(client);
  client
    .on("connect", () => {
      console.log(`Connected to MQTT broker as ${cid}`);
    })
    .on("reconnect", (error) => {
      console.log("reconnecting:", error);
    })
    .on("error", (error) => {
      console.log("Connection failed:", error);
    });
  const cid = client.options.clientId;
  asyncClient.subscribe(`devices/${cid}/#`).then();
  return asyncClient;
}

export const getClient = (clientId) => {
  if (!asyncClient) {
    startClient(clientId);
  }
  return asyncClient;
};
