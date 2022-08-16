#!/bin/bash
set -e

cd ./wasm

wat2wasm --debug-names $1.wat
# Fold expressions (s-exprs)
wasm2wat --fold-exprs $1.wasm -o $1.folded.wat

# Optimize with asyncify (w/o default optimizations)
wasm-opt $1.folded.wat -O0 --asyncify --print > $1.async.wat

# Cleanup
rm $1.folded.wat