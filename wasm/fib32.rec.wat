(module
  (type $t0 (func (param i32) (result i32)))
  (import "env" "sleep" (func $sleep (param i32)))
  (func $fibonacci (type $t0) (param i32) (result i32)
    local.get 0
    i32.const 2
    i32.lt_u
    if  ;; label = @1
      local.get 0
      return
    end
    i32.const 1000
    call $sleep
    local.get 0
    i32.const 2
    i32.sub
    call $fibonacci
    local.get 0
    i32.const 1
    i32.sub
    call $fibonacci
    i32.add
    return
  )
  (memory (;0;) 1)
  (export "fibonacci" (func $fibonacci))
  (export "memory" (memory 0))
)
