$prime_arg = 2000000
$prime_paths = @("benchmark/prime/prim.wasm", "benchmark/prime/prim.async.wasm", "benchmark/prime/prim.async.opt.wasm")
$fib_arg = 46
$fib_paths = @("benchmark/fibonacci/i32/fib32.wasm", "benchmark/fibonacci/i32/fib32.async.wasm", "benchmark/fibonacci/i32/fib32.async.opt.wasm")

foreach ($function in @("prime", "fib")) {
    $arg = Get-Variable "${function}_arg" -ValueOnly
    $paths = Get-Variable "${function}_paths" -ValueOnly
    foreach ($path in $paths) {
        .\WasmMigrateBench.exe 100 node benchmark/wrapper.js $path $function $arg
    }
}
