$migrationSequence = @("wasmMigrateClientB", "wasmMigrateClientC", "wasmMigrateClientB", "wasmMigrateClientA")

$currentClient = "wasmMigrateClientA"

foreach ($nextClient in $migrationSequence) {
  & "wasm-migrate" migrate $currentClient $nextClient
  $currentClient = $nextClient
  Start-Sleep -Seconds 1
}
