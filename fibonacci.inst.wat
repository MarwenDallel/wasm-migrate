(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32)))
  (import "env" "sleep" (func (;0;) (type 1)))
  (func (;1;) (type 0) (param i32) (result i32)
    (local i32 i32 i32 i32)
    i32.const 0
    local.tee 1
    i32.const 8
    call 3
    i32.const 1
    local.tee 2
    i32.const 12
    call 3
    i32.const 0
    local.tee 3
    i32.const 16
    call 3
    block  ;; label = @1
      loop  ;; label = @2
        local.get 0
        i32.const 4
        call 2
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        i32.const 12
        call 2
        local.tee 3
        i32.const 16
        call 3
        local.get 1
        i32.const 8
        call 2
        local.tee 2
        i32.const 12
        call 3
        local.get 2
        i32.const 12
        call 2
        local.get 3
        i32.const 16
        call 2
        i32.add
        local.tee 1
        i32.const 8
        call 3
        local.get 0
        i32.const 4
        call 2
        i32.const 1
        i32.sub
        local.tee 0
        i32.const 4
        call 3
        i32.const 20000
        call 0
        br 0 (;@2;)
      end
    end
    local.get 1
    i32.const 8
    call 2)
  (func (;2;) (type 2) (param i32 i32) (result i32)
    local.get 1
    local.get 0
    i32.store
    local.get 0)
  (func (;3;) (type 3) (param i32 i32)
    local.get 1
    local.get 0
    i32.store)
  (memory (;0;) 1)
  (export "fibonacci" (func 1))
  (export "mem" (memory 0)))
