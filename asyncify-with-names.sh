#!/bin/bash
set -e

wat2wasm --debug-names fibonacci.wat
# Fold expressions (s-exprs)
wasm2wat --fold-exprs fibonacci.wasm -o fibonacci.folded.wat

# Optimize with asyncify (w/o default optimizations)
wasm-opt fibonacci.folded.wat -O0 --asyncify --print > fibonacci.async.wat

# Cleanup
rm fibonacci.folded.wat