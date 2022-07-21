(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func))
  (type (;2;) (func (param i32) (result i32)))
  (type (;3;) (func (param i32 i32) (result i32)))
  (type (;4;) (func (param i32 i32)))
  (type (;5;) (func (result i32)))
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
      i32.const 16
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
      local.set 4
      local.get 1
      i32.load offset=12
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
        local.set 2
      end
      global.get 0
      i32.eqz
      if  ;; label = @2
        i32.const 0
        i32.const 8
        call 3
        i32.const 1
        local.tee 1
        i32.const 12
        call 3
        i32.const 0
        i32.const 16
        call 3
      end
      loop  ;; label = @2
        global.get 0
        i32.eqz
        if  ;; label = @3
          local.get 0
          i32.const 4
          call 2
          local.set 3
        end
        local.get 3
        global.get 0
        i32.const 2
        i32.eq
        i32.or
        if  ;; label = @3
          global.get 0
          i32.eqz
          if  ;; label = @4
            local.get 1
            i32.const 12
            call 2
            local.tee 3
            i32.const 16
            call 3
            local.get 4
            i32.const 8
            call 2
            local.tee 1
            i32.const 12
            call 3
            local.get 1
            i32.const 12
            call 2
            local.set 4
            local.get 4
            local.get 3
            i32.const 16
            call 2
            local.tee 3
            i32.add
            local.tee 4
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
          end
          local.get 2
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
        local.get 4
        i32.const 8
        call 2
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
    local.get 4
    i32.store offset=8
    local.get 2
    local.get 1
    i32.store offset=12
    global.get 1
    global.get 1
    i32.load
    i32.const 16
    i32.add
    i32.store
    i32.const 0)
  (func (;2;) (type 3) (param i32 i32) (result i32)
    local.get 1
    local.get 0
    i32.store
    local.get 0)
  (func (;3;) (type 4) (param i32 i32)
    local.get 1
    local.get 0
    i32.store)
  (func (;4;) (type 0) (param i32)
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
  (func (;6;) (type 0) (param i32)
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
  (func (;7;) (type 1)
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
  (func (;8;) (type 5) (result i32)
    global.get 0)
  (memory (;0;) 1)
  (global (;0;) (mut i32) (i32.const 0))
  (global (;1;) (mut i32) (i32.const 0))
  (export "fibonacci" (func 1))
  (export "mem" (memory 0))
  (export "asyncify_start_unwind" (func 4))
  (export "asyncify_stop_unwind" (func 5))
  (export "asyncify_start_rewind" (func 6))
  (export "asyncify_stop_rewind" (func 7))
  (export "asyncify_get_state" (func 8)))
