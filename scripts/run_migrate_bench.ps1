$migrationSequence = @("wasmMigrateClientB", "wasmMigrateClientC", "wasmMigrateClientB", "wasmMigrateClientA")

$currentClient = "wasmMigrateClientA"

& "wasm-migrate" start wasmMigrateClientA ./wasm/fibonacci.async.wasm fibonacci 46
Start-Sleep -Seconds 5

foreach ($nextClient in $migrationSequence) {
  # Print the command to be executed
  Write-Host "wasm-migrate migrate $currentClient $nextClient"
  & "wasm-migrate" migrate $currentClient $nextClient
  $currentClient = $nextClient
  Start-Sleep -Seconds 5
}
