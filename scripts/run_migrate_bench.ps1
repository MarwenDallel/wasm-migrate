$migrationSequence = @("wasmMigrateClientB", "wasmMigrateClientC", "wasmMigrateClientB", "wasmMigrateClientA")

$currentClient = "wasmMigrateClientA"

for ($i = 0; $i -lt 10; $i++) {
  & "wasm-migrate" start wasmMigrateClientA ./wasm/fib32.import.wasm fibonacci 10
  Start-Sleep -Seconds 5

  foreach ($nextClient in $migrationSequence) {
    # Print the command to be executed
    Write-Host "wasm-migrate migrate $currentClient $nextClient"
    & "wasm-migrate" migrate $currentClient $nextClient
    $currentClient = $nextClient
    Start-Sleep -Seconds 5
  }
  # Prompt user to continue
  Write-Host "Press any key to continue"
  $null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

  #Start-Sleep -Seconds 10
}