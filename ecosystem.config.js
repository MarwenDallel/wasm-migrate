module.exports = {
  apps: [
    {
      name: "clientA",
      script: "wasm-migrate start-passive --cid wasmMigrateClientA",
    },
    {
      name: "clientB",
      script: "wasm-migrate start-passive --cid wasmMigrateClientB",
    },
    {
      name: "clientC",
      script: "wasm-migrate start-passive --cid wasmMigrateClientC",
    },
    {
      name: "clientD",
      script: "wasm-migrate start-passive --cid wasmMigrateClientD",
    },
  ],
};
