const fs = require("fs");

class AsyncifyData {
  constructor(memory, baseAddr, endAddr) {
    this.view = new Int32Array(memory.buffer);
    this.baseAddr = baseAddr;
    this.endAddr = endAddr;
  }

  static fromFile(filePath, memory) {
    const dump = fs.readFileSync(filePath);
    const dumpView = new Int32Array(dump.buffer);
    const view = new Int32Array(memory.buffer);
    view.set(dumpView); // load into wasm memory;
    const endAddr = dumpView[13];

    return new AsyncifyData(memory, 48, endAddr);
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

  get data() {
    return this.view;
  }

  getData(peak) {
    return this.view.slice(this.baseAddr >> 2, (this.baseAddr >> 2) + peak);
  }

  toFile() {
    console.log("Dumping view...");
    if (!fs.existsSync("./dump")) {
      fs.mkdirSync("./dump");
    }
    fs.writeFileSync("./dump/fibonacci.bin", Buffer.from(this.view.buffer));
  }
}

class AsyncifyWrapper {
  constructor(startFn, exports, asyncifyData, sleeping) {
    this.startFn = startFn;
    this.exports = exports;
    this.asyncifyData =
      asyncifyData || new AsyncifyData(exports.memory, 48, 1024);
    this.sleeping = sleeping || false;
    console.log("Memory initialized:", this._asyncifyData.view);
  }

  start() {
    this.startFn();
  }

  get sleeping() {
    return this._sleeping;
  }

  set sleeping(value) {
    this._sleeping = value;
  }

  get asyncifyData() {
    return this._asyncifyData;
  }

  set asyncifyData(value) {
    this._asyncifyData = value;
  }

  startUnwind() {
    this.asyncifyData.prepareView();
    this.exports.asyncify_start_unwind(this.asyncifyData.baseAddr);
    this.sleeping = true;
  }

  stopUnwind() {
    this.exports.asyncify_stop_unwind();
  }

  startRewind() {
    this.exports.asyncify_start_rewind(this.asyncifyData.baseAddr);
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
}

module.exports = {
  AsyncifyWrapper,
  AsyncifyData,
};
