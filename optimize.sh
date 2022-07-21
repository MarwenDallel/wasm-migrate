#!/bin/bash
wat2wasm fibonacci.wat -o fibonacci.wasm
wasm-opt fibonacci.wasm -o fibonacci.wasm -O --asyncify