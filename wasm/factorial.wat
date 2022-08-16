(module
  (import "env" "sleep" (func $sleep (param i32)))
  (func $factorial
    (param $n i32)
    (result i32)
    local.get $n
    i32.const 2
    i32.le_s
    if (result i32)
      local.get $n
    else
      local.get $n
      local.get $n
      i32.const 1
      i32.sub
      i32.const 1000
      call $sleep
      call $factorial
      i32.mul
    end)
  (memory (;0;) 1)
  (export "factorial" (func $factorial))
  (export "memory" (memory 0))
)