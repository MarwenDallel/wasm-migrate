## Getting started

### Initial setup

```sh
wasm-migrate start-passive --cid wasmMigrateClientC
wasm-migrate start-passive --cid wasmMigrateClientB
wasm-migrate start-passive --cid wasmMigrateClient

```

### Start code execution

```sh
wasm-migrate start wasmMigrateClient wasm/fibonacci.async.wasm fibonacci 46
```

### Migrate task

```sh
wasm-migrate migrate wasmMigrateClient wasmMigrateClientB
wasm-migrate migrate wasmMigrateClientB wasmMigrateClientC

```
