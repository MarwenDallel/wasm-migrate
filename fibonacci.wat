(module
  (import "env" "sleep" (func $sleep (param i32)))
  (import "env" "save" (func $save))
  (type $t0 (func (param i32) (result i32)))
  (func $fibonacci (type $t0) (param $index i32) (result i32)
    (local $fibn i32) (local $fibn1 i32) (local $fibn2 i32) (local $n i32)
    i32.const 0
    local.set $fibn
    i32.const 1
    local.set $fibn1
    i32.const 0
    local.set $fibn2
    block $B0
      loop $L1
        local.get $index
        i32.eqz
        br_if $B0
        local.get $fibn1
        local.set $fibn2
        local.get $fibn
        local.set $fibn1
        local.get $fibn1
        local.get $fibn2
        i32.add
        local.set $fibn
        local.get $index
        i32.const 1
        i32.sub
        local.set $index
        i32.const 1000
        call $sleep
        br $L1
      end
    end
    local.get $fibn)
  (memory (;0;) 1)
  (export "fibonacci" (func $fibonacci))
  (export "memory" (memory 0))
)
