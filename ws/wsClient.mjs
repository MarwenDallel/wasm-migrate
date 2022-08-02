import chalk from "chalk";
import WebSocket from "ws";
import {
  clearLastLine,
  Client,
  logEvent,
  logMessage,
  rlInterace,
  sendMessage,
} from "./wsUtils.mjs";

const client = new Client();
const rl = rlInterace();
let ws;

function handleOpen() {
  logEvent(chalk.green("Connected"));
  try {
    rl.on("line", (text) => {
      switch (text) {
        case "exit":
          ws.close();
          rl.close();
          break;
        default:
          clearLastLine();
          sendMessage(ws, client, text);
          process.stdout.write("> ");
      }
    });
  } catch (err) {
    logEvent(`Failed with ${err}`);
    process.exit(1);
  }
}

function handleClose() {
  logEvent(chalk.red("Disconnected"));
  process.exit(1);
}

function handleMessage(message, wrapper) {
  var data = JSON.parse(message);
  logMessage(data);
  if (data.msg === "migrate") {
    wrapper.migrate = true;
  }
}

export function startClient(wrapper, port) {
  const url = `ws://localhost:${port}`;
  ws = new WebSocket(url);
  ws.on("open", handleOpen);
  ws.on("close", handleClose);
  ws.on("message", (message) => handleMessage(message, wrapper));
}

//start();
