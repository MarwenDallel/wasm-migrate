#!/bin/bash

# Translate this JS to sh
# const MIGRATION_SEQUENCE = ["wasmMigrateClientB", "wasmMigrateClientC", "wasmMigrateClientB", "wasmMigrateClientA"];

migrationSequence=("wasmMigrateClientB" "wasmMigrateClientC" "wasmMigrateClientB" "wasmMigrateClientA")
# Use a variable to store the current client
currentClient="wasmMigrateClientA"

echo "Start command issued to client WasmMigrateClientA"
wasm-migrate start wasmMigrateClientA ./wasm/fibonacci.async.wasm fibonacci 46
sleep 5

# For each client in the sequence, run the migration command "wasm-migrate migrate currentClient nextClient"
# Set currentclient to the next client in the sequence after the migration
# wait 1 second between migrations
for nextClient in "${migrationSequence[@]}"; do
  wasm-migrate migrate $currentClient $nextClient
  currentClient=$nextClient
  sleep 5
done
