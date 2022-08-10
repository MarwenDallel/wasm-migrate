// @ts-nocheck
import * as dotenv from "dotenv";
dotenv.config();

const mqttConfig = {
  brokerUrl: process.env.MQTT_BROKER_URL,
  clean: process.env.MQTT_RETAIN_SESSION === "true", // retain session
  connectTimeout: parseInt(process.env.MQTT_CONNECT_TIMEOUT), // Timeout period
  // Authentication information
  clientId: process.env.MQTT_CLIENTID,
  username: process.env.MQTT_USERNAME,
  password: process.env.MQTT_PASSWORD,
  rejectUnauthorized: process.env.MQTT_INSECURE === "false", // self signed cert
};

export default mqttConfig;
