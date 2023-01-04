import fs from "fs";

const timestamp = () => {
  const d = new Date();
  return `${d.getFullYear()}${d.getMonth()}${d.getDate()}${d.getHours()}${d.getMinutes()}${d.getSeconds()}`;
};

export class AsyncifyData {
  constructor(memory, baseAddr, endAddr) {
    this.view = new Uint32Array(memory.buffer);
    this.baseAddr = baseAddr;
    this.endAddr = endAddr;
  }

  static fromFile(filePath, baseAddr, memory) {
    const dump = fs.readFileSync(filePath);
    const dumpView = new Uint32Array(dump.buffer);
    const view = new Uint32Array(memory.buffer);
    view.set(dumpView); // load into wasm memory;
    const endAddr = dumpView[(baseAddr + 4) >> 2];

    return new AsyncifyData(memory, baseAddr, endAddr);
  }

  static fromBinary(dump, baseAddr, memory) {
    const data = Buffer.alloc(dump.length, dump);
    const dumpView = new Uint32Array(data.buffer);
    const view = new Uint32Array(memory.buffer);
    view.set(dumpView); // load into wasm memory;
    const endAddr = dumpView[(baseAddr + 4) >> 2];

    return new AsyncifyData(memory, baseAddr, endAddr);
  }

  prepareView() {
    // Fill in the data structure. The first value has the stack location,
    // which for simplicity we can start right after the data structure itself.
    this.view[this.baseAddr >> 2] = this.baseAddr + 8;
    // The end of the stack will not be reached here anyhow.
    this.view[(this.baseAddr + 4) >> 2] = 1024;
  }

  get baseAddr() {
    return this._baseAddr;
  }

  set baseAddr(value) {
    this._baseAddr = value;
  }

  get endAddr() {
    return this._endAddr;
  }

  set endAddr(value) {
    this._endAddr = value;
  }

  get view() {
    return this._view;
  }

  set view(value) {
    this._view = value;
  }

  peak(endIndex) {
    return this.view.slice(this.baseAddr >> 2, (this.baseAddr >> 2) + endIndex);
  }

  toFile(name) {
    console.log("Dumping view...");
    if (!fs.existsSync("./dump")) {
      fs.mkdirSync("./dump");
    }
    const filename = `${name}.${timestamp()}.bin`;
    fs.writeFileSync(`./dump/${filename}`, Buffer.from(this.view.buffer));
    console.log(`Memory snapshot created at dump/${filename}`);
  }
}

export class AsyncifyWrapper {
  constructor() {
    this.sleeping = false;
    this.migrate = false;
    this.migrationData = {};
  }

  wrap(startFnName, args, exports) {
    this.exports = exports;
    this.startFn = this.findStartFn(startFnName, args);
    this.data = new AsyncifyData(exports.memory, 48, 1024);
  }

  start() {
    // @ts-ignore
    const result = this.startFn();
    console.log("Function return value:", result);
  }

  findStartFn(startFnName, args) {
    // Find start function by name
    const startFn = this.exports[startFnName];
    if (!startFn) throw new Error(`No function ${startFnName} found`);
    if (startFn.length !== args.length)
      throw new Error(
        `Function ${startFnName} takes ${startFn.length} arguments, but ${args.length} were given`
      );
    const startFnWrapper = () => {
      return startFn(...args);
    };

    this.migrationData = {
      ...this.migrationData,
      startFn: {
        name: startFnName,
        args,
      },
    };
    return startFnWrapper;
  }

  startUnwind() {
    this.data.prepareView();
    this.exports.asyncify_start_unwind(this.data.baseAddr);
    this.sleeping = true;
  }

  stopUnwind() {
    this.exports.asyncify_stop_unwind();
  }

  startRewind() {
    this.exports.asyncify_start_rewind(this.data.baseAddr);
    this.start();
  }

  stopRewind() {
    this.exports.asyncify_stop_rewind();
    this.sleeping = false;
  }

  getState() {
    return this.exports.asyncify_get_state();
  }

  setState(value) {
    return this.exports.asyncify_set_state(value);
  }

  getDataGlobal() {
    return this.exports.asyncify_get_data();
  }

  setDataGlobal(value) {
    this.exports.asyncify_set_data(value);
  }

  get migrationData() {
    if (this.data) {
      this._migrationData["dumpBinary"] = Buffer.from(this.data.view.buffer);
    }
    return this._migrationData;
  }

  set migrationData(value) {
    this._migrationData = value;
  }

  get sleeping() {
    return this._sleeping;
  }

  set sleeping(value) {
    this._sleeping = value;
  }

  get migrate() {
    return this._migrate;
  }

  set migrate(value) {
    this._migrate = value;
  }

  get data() {
    return this._data;
  }

  set data(value) {
    this.sleeping = true;
    this._data = value;
  }

  get startFnName() {
    return this._migrationData.startFn.name;
  }
}
