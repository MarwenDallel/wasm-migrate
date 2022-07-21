#!/bin/bash

if [ -z "$1" ]; then
    echo "Using original fibonacci file"
    file_prefix="fibonacci"
elif [ "$1" == "inst" ]; then
    echo "Using instrumented fibonacci file"
    file_prefix="fibonacci.$1"
else
    echo "Unsupported option"
fi

wat2wasm $file_prefix.wat -o $file_prefix.wasm
wasm-opt $file_prefix.wasm -o fibonacci.opt.wasm -O --asyncify
wasm2wat fibonacci.opt.wasm -o fibonacci.opt.wat