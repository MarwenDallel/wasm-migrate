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
  ],
};
