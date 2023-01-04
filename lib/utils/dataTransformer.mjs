import { Type } from "../js-binary/index.js";

const dataSchema = new Type({
  wasmBinary: "Buffer",
  "dumpBinary?": "Buffer",
  startFn: {
    name: "string",
    args: ["uint"],
  },
  "startTime?": "bigint",
  "endTime?": "bigint",
});

// migrationData encoder and decoder class
export default {
  encode(migrationData) {
    return dataSchema.encode(migrationData);
  },
  decode(buffer) {
    return dataSchema.decode(buffer);
  },
};
