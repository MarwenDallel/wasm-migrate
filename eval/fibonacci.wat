(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func))
  (type (;2;) (func (param i32) (result i32)))
  (type (;3;) (func (result i32)))
  (import "env" "sleep" (func (;0;) (type 0)))
  (func (;1;) (type 2) (param i32) (result i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 2
    i32.eq
    if  ;; label = @1
      global.get 1
      global.get 1
      i32.load
      i32.const 12
      i32.sub
      i32.store
      global.get 1
      i32.load
      local.tee 1
      i32.load
      local.set 0
      local.get 1
      i32.load offset=4
      local.set 3
      local.get 1
      i32.load offset=8
      local.set 1
    end
    block (result i32)  ;; label = @1
      global.get 0
      i32.const 2
      i32.eq
      if  ;; label = @2
        global.get 1
        global.get 1
        i32.load
        i32.const 4
        i32.sub
        i32.store
        global.get 1
        i32.load
        i32.load
        local.set 4
      end
      local.get 3
      i32.const 1
      global.get 0
      select
      local.set 3
      loop  ;; label = @2
        local.get 0
        global.get 0
        i32.const 2
        i32.eq
        i32.or
        if  ;; label = @3
          global.get 0
          i32.eqz
          if  ;; label = @4
            local.get 3
            local.set 2
            local.get 1
            local.set 3
            local.get 1
            local.get 2
            i32.add
            local.set 1
            local.get 0
            i32.const 1
            i32.sub
            local.set 0
          end
          local.get 4
          i32.const 0
          global.get 0
          select
          i32.eqz
          if  ;; label = @4
            i32.const 1000
            call 0
            i32.const 0
            global.get 0
            i32.const 1
            i32.eq
            br_if 3 (;@1;)
            drop
          end
          global.get 0
          i32.eqz
          br_if 1 (;@2;)
        end
      end
      global.get 0
      i32.eqz
      if  ;; label = @2
        local.get 1
        return
      end
      unreachable
    end
    local.set 2
    global.get 1
    i32.load
    local.get 2
    i32.store
    global.get 1
    global.get 1
    i32.load
    i32.const 4
    i32.add
    i32.store
    global.get 1
    i32.load
    local.tee 2
    local.get 0
    i32.store
    local.get 2
    local.get 3
    i32.store offset=4
    local.get 2
    local.get 1
    i32.store offset=8
    global.get 1
    global.get 1
    i32.load
    i32.const 12
    i32.add
    i32.store
    i32.const 0)
  (func (;2;) (type 0) (param i32)
    i32.const 1
    global.set 0
    local.get 0
    global.set 1
    global.get 1
    i32.load
    global.get 1
    i32.load offset=4
    i32.gt_u
    if  ;; label = @1
      unreachable
    end)
  (func (;3;) (type 1)
    i32.const 0
    global.set 0
    global.get 1
    i32.load
    global.get 1
    i32.load offset=4
    i32.gt_u
    if  ;; label = @1
      unreachable
    end)
  (func (;4;) (type 0) (param i32)
    i32.const 2
    global.set 0
    local.get 0
    global.set 1
    global.get 1
    i32.load
    global.get 1
    i32.load offset=4
    i32.gt_u
    if  ;; label = @1
      unreachable
    end)
  (func (;5;) (type 1)
    i32.const 0
    global.set 0
    global.get 1
    i32.load
    global.get 1
    i32.load offset=4
    i32.gt_u
    if  ;; label = @1
      unreachable
    end)
  (func (;6;) (type 3) (result i32)
    global.get 0)
  (memory (;0;) 1)
  (global (;0;) (mut i32) (i32.const 0))
  (global (;1;) (mut i32) (i32.const 0))
  (export "fibonacci" (func 1))
  (export "memory" (memory 0))
  (export "asyncify_start_unwind" (func 2))
  (export "asyncify_stop_unwind" (func 3))
  (export "asyncify_start_rewind" (func 4))
  (export "asyncify_stop_rewind" (func 5))
  (export "asyncify_get_state" (func 6)))
