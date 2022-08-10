import { Type } from "js-binary";

const dataSchema = new Type({
  wasmBinary: "Buffer",
  "dumpBinary?": "Buffer",
  startFn: {
    name: "string",
    args: ["uint"],
  },
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
