const fs = require("fs");

class AsyncifyData {
  constructor(memory, baseAddr, endAddr) {
    this.view = new Int32Array(memory.buffer);
    this.baseAddr = baseAddr;
    this.endAddr = endAddr;
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
    return this.view.slice(this.baseAddr >> 2, 12);
  }

  toFile() {
    console.log("Dumping view...");
    if (!fs.existsSync("./dump")) {
      fs.mkdirSync("./dump");
    }
    // write arraybuffer to file
    fs.appendFileSync("./dump/fibonacci.bin", Buffer.from(this.view.buffer));
  }
}

class AsyncifyWrapper {
  constructor(startFn, exports) {
    this.startFn = startFn;
    this.asyncifyData = new AsyncifyData(exports.memory, 16, 1024);
    this.exports = exports;
    this.sleeping = false;
    console.log("Memory initialized:", this._asyncifyData.view.slice(0, 10));
  }

  start() {
    console.log(this.asyncifyData.data);
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

  // start unwind
  startUnwind() {
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
}

module.exports = { AsyncifyData, AsyncifyWrapper };
