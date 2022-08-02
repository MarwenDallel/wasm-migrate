import {
  Client,
  logEvent,
  logMessage,
  rlInterace,
  sendMessage,
  clearLastLine,
  handleReceivedMsg,
} from "./wsUtils.mjs";
import WebSocket, { WebSocketServer } from "ws";
import chalk from "chalk";

const wss = new WebSocketServer({ port: 8080, clientTracking: true });
const rl = rlInterace();
const server = new Client("Server", "#FF0000");

function broadcastAll(data) {
  wss.clients.forEach(function each(client) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(data);
    }
  });
}

wss.on("listening", () => {
  logEvent(chalk.green("Server listening"));
});

wss.on("connection", function connection(ws, req) {
  logEvent(
    chalk.green(
      `Connected ${req.socket.remoteAddress}:${req.socket.remotePort}`
    )
  );

  ws.on("message", function incoming(message) {
    var data = JSON.parse(message);
    //var json_data = handleReceivedMsg(message);
    logMessage(data);
    //broadcastAll(json_data);
  });

  try {
    rl.on("line", (text) => {
      switch (text) {
        case "disconnect":
          ws.close();
          rl.close();
          logEvent(chalk.red("Forced all peers to disconnect"));
          break;
        default:
          clearLastLine();
          sendMessage(ws, server, text);
          process.stdout.write("> ");
      }
    });
  } catch (err) {
    logEvent(`Failed with ${err}`);
    process.exit(1);
  }

  ws.on("close", function (reasonCode, description) {
    logEvent(chalk.red("Peer disconnected"));
  });
});

wss.on("disconnection", function disconnection(ws) {});
