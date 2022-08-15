import * as mqtt from "mqtt";
import mqttConfig from "../../config/mqttConfig.mjs";

let _client = null;

function startClient(clientId) {
  console.log("Starting MQTT client");
  const { brokerUrl, ...options } = mqttConfig;
  options.clientId = clientId || options.clientId;
  // @ts-ignore
  _client = mqtt.connect(brokerUrl, options);
  _client.on("connect", () => {
    console.log(`Connected to MQTT broker as ${cid}`);
  });

  _client.on("reconnect", (error) => {
    console.log("reconnecting:", error);
  });

  _client.on("error", (error) => {
    console.log("Connection failed:", error);
  });

  const cid = _client.options.clientId;
  _client.subscribe(`devices/${cid}/#`);
}

export const getClient = (clientId) => {
  if (!_client) {
    startClient(clientId);
  }
  return _client;
};
