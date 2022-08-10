import * as mqtt from "mqtt";
import mqttConfig from "../../config/mqttConfig.mjs";

let _client = null;

function startClient() {
  console.log("Starting MQTT client");
  const { brokerUrl, options } = mqttConfig;
  // @ts-ignore
  _client = mqtt.connect(brokerUrl, options);
  _client.on("connect", () => {
    _client.subscribe("presence", (err) => {
      if (!err) {
        _client.publish("presence", "Hello mqtt");
      }
    });
    _client.subscribe("execution/start", { qos: 2 });
    _client.subscribe("execution/migrate", { qos: 2 });
    _client.subscribe("execution/resume", { qos: 2 });
  });

  _client.on("reconnect", (error) => {
    console.log("reconnecting:", error);
  });

  _client.on("error", (error) => {
    console.log("Connection failed:", error);
  });
}

export const getClient = () => {
  if (!_client) {
    startClient();
  }
  return _client;
};
