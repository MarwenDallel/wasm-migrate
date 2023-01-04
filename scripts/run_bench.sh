#!/usr/bin/env bash

# Determine the script's directory
script_dir=$(dirname "$(readlink -f "$0")")

# Change to the script's directory
cd "$script_dir"

prime_arg=2000000
prime_paths=( "benchmark/prime/prim.wasm" "benchmark/prime/prim.async.wasm" "benchmark/prime/prim.async.opt.wasm" )
fib_arg=46
fib_paths=( "benchmark/fibonacci/i32/fib32.wasm" "benchmark/fibonacci/i32/fib32.async.wasm" "benchmark/fibonacci/i32/fib32.async.opt.wasm" )

for function in "prime" "fib"; do
    eval "arg=\${${function}_arg}"
    eval "paths=(\${${function}_paths[@]})"
    for path in "${paths[@]}"; do
        # echo python3 scripts/pychmark.py 100 node benchmark/wrapper.js "$path" "$function" "$arg"
        python3 scripts/pychmark.py 100 node benchmark/wrapper.js "$path" "$function" "$arg"
    done
done
