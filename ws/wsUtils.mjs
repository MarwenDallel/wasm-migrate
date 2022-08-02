import chalk from "chalk";
import readline from "readline";

const namePool = [
  "David",
  "Rebecca",
  "Randall",
  "Brendan",
  "Jonathan",
  "Dominique",
  "Charles",
  "Stephanie",
  "Daniel",
  "Christopher",
];

export class Client {
  constructor(name, color) {
    this.name = name || generateRandomName();
    this.color = color || generateRandomHex();
  }
}

export function rlInterace() {
  return readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
  });
}

export function currentTime() {
  return new Date().toLocaleTimeString();
}

export function logEvent(message) {
  console.log(`[${currentTime()}] ${message}`);
}

export function logMessage(data) {
  const colorify = chalk.hex(data.color);
  logEvent(colorify(`${data.name}: ${data.msg}`));
}

export function generateRandomHex() {
  const h = Math.floor(Math.random() * 16777215).toString(16);
  return `#${h}`;
}
export function generateRandomName() {
  const i = Math.floor(Math.random() * namePool.length);
  const n = Math.floor(Math.random() * 1000);

  return `${namePool[i]}${n}`;
}

export function sendMessage(ws, client, text) {
  const data = {
    name: client.name,
    color: client.color,
    msg: text,
    msgType: client.name === "server" ? "server" : "client",
  };
  ws.send(JSON.stringify(data));
}

export function handleReceivedMsg(message) {
  var parsedMessage = JSON.parse(message);
  var data = { ...parsedMessage };
  data["msgType"] = "msg";

  return JSON.stringify(data);
}

export function clearLastLine() {
  readline.moveCursor(process.stdout, 0, -1);
  readline.clearLine(process.stdout, 1);
}
