(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func))
  (type (;2;) (func (param i32) (result i32)))
  (type (;3;) (func (result i32)))
  (import "env" "sleep" (func $sleep (type 0)))
  (func $fibonacci (type 2) (param $index i32) (result i32)
    (local $fibn i32) (local $fibn1 i32) (local $fibn2 i32) (local $n i32) (local $index_loop_cpy i32) (local $loop_condition i32) (local $fibn1_cpy i32) (local $fibn_cpy i32) (local $fibn1_add_cpy i32) (local $fibn2_add_cpy i32) (local $fibn_add_result i32) (local $index_cpy i32) (local $index_sub_cpy i32) (local $14 i32) (local $fibn_return_cpy i32) (local $return_value i32) (local $call_index i32) (local $restored_call_index i32) (local $local_start_addr_load i32) (local $local_start_addr_store i32)
    (if  ;; label = @1
      (i32.eq
        (global.get $__asyncify_state)
        (i32.const 2))
      (then
        (i32.store
          (global.get $__asyncify_data)
          (i32.add
            (i32.load
              (global.get $__asyncify_data))
            (i32.const -16)))
        (local.set $local_start_addr_load
          (i32.load
            (global.get $__asyncify_data)))
        (local.set $index
          (i32.load
            (local.get $local_start_addr_load)))
        (local.set $fibn
          (i32.load offset=4
            (local.get $local_start_addr_load)))
        (local.set $fibn1
          (i32.load offset=8
            (local.get $local_start_addr_load)))
        (local.set $fibn_return_cpy
          (i32.load offset=12
            (local.get $local_start_addr_load)))))
    (local.set $call_index
      (block (result i32)  ;; label = @1
        (block  ;; label = @2
          (block  ;; label = @3
            (if  ;; label = @4
              (i32.eq
                (global.get $__asyncify_state)
                (i32.const 2))
              (then
                (i32.store
                  (global.get $__asyncify_data)
                  (i32.add
                    (i32.load
                      (global.get $__asyncify_data))
                    (i32.const -4)))
                (local.set $restored_call_index
                  (i32.load
                    (i32.load
                      (global.get $__asyncify_data))))))
            (block  ;; label = @4
              (block  ;; label = @5
                (if  ;; label = @6
                  (i32.eq
                    (global.get $__asyncify_state)
                    (i32.const 0))
                  (then
                    (local.set $fibn
                      (i32.const 0))
                    (local.set $fibn1
                      (i32.const 1))
                    (local.set $fibn2
                      (i32.const 0))))
                (nop)
                (nop)
                (block  ;; label = @6
                  (loop  ;; label = @7
                    (block  ;; label = @8
                      (if  ;; label = @9
                        (i32.eq
                          (global.get $__asyncify_state)
                          (i32.const 0))
                        (then
                          (local.set $index_loop_cpy
                            (local.get $index))
                          (local.set $loop_condition
                            (i32.eqz
                              (local.get $index_loop_cpy)))
                          (br_if 3 (;@6;)
                            (local.get $loop_condition))
                          (local.set $fibn1_cpy
                            (local.get $fibn1))
                          (local.set $fibn2
                            (local.get $fibn1_cpy))
                          (local.set $fibn_cpy
                            (local.get $fibn))
                          (local.set $fibn1
                            (local.get $fibn_cpy))
                          (local.set $fibn1_add_cpy
                            (local.get $fibn1))
                          (local.set $fibn2_add_cpy
                            (local.get $fibn2))
                          (local.set $fibn_add_result
                            (i32.add
                              (local.get $fibn1_add_cpy)
                              (local.get $fibn2_add_cpy)))
                          (local.set $fibn
                            (local.get $fibn_add_result))
                          (local.set $index_cpy
                            (local.get $index))
                          (local.set $index_sub_cpy
                            (i32.sub
                              (local.get $index_cpy)
                              (i32.const 1)))
                          (local.set $index
                            (local.get $index_sub_cpy))))
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (nop)
                      (if  ;; label = @9
                        (if (result i32)  ;; label = @10
                          (i32.eq
                            (global.get $__asyncify_state)
                            (i32.const 0))
                          (then
                            (i32.const 1))
                          (else
                            (i32.eq
                              (local.get $restored_call_index)
                              (i32.const 0))))
                        (then
                          (call $sleep
                            (i32.const 1000))
                          (if  ;; label = @10
                            (i32.eq
                              (global.get $__asyncify_state)
                              (i32.const 1))
                            (then
                              (br 9 (;@1;)
                                (i32.const 0))))))
                      (if  ;; label = @9
                        (i32.eq
                          (global.get $__asyncify_state)
                          (i32.const 0))
                        (then
                          (br 2 (;@7;)))))))
                (if  ;; label = @6
                  (i32.eq
                    (global.get $__asyncify_state)
                    (i32.const 0))
                  (then
                    (local.set $14
                      (local.get $fibn))
                    (local.set $fibn_return_cpy
                      (local.get $14))))
                (nop))
              (if  ;; label = @5
                (i32.eq
                  (global.get $__asyncify_state)
                  (i32.const 0))
                (then
                  (local.set $return_value
                    (local.get $fibn_return_cpy))
                  (return
                    (local.get $return_value))))
              (nop))
            (unreachable))
          (unreachable))
        (unreachable)))
    (block  ;; label = @1
      (i32.store
        (i32.load
          (global.get $__asyncify_data))
        (local.get $call_index))
      (i32.store
        (global.get $__asyncify_data)
        (i32.add
          (i32.load
            (global.get $__asyncify_data))
          (i32.const 4))))
    (block  ;; label = @1
      (local.set $local_start_addr_store
        (i32.load
          (global.get $__asyncify_data)))
      (i32.store
        (local.get $local_start_addr_store)
        (local.get $index))
      (i32.store offset=4
        (local.get $local_start_addr_store)
        (local.get $fibn))
      (i32.store offset=8
        (local.get $local_start_addr_store)
        (local.get $fibn1))
      (i32.store offset=12
        (local.get $local_start_addr_store)
        (local.get $fibn_return_cpy))
      (i32.store
        (global.get $__asyncify_data)
        (i32.add
          (i32.load
            (global.get $__asyncify_data))
          (i32.const 16))))
    (i32.const 0))
  (func $asyncify_start_unwind (type 0) (param $DATA_ADDR i32)
    (global.set $__asyncify_state
      (i32.const 1))
    (global.set $__asyncify_data
      (local.get $DATA_ADDR))
    (if  ;; label = @1
      (i32.gt_u
        (i32.load
          (global.get $__asyncify_data))
        (i32.load offset=4
          (global.get $__asyncify_data)))
      (then
        (unreachable))))
  (func $asyncify_stop_unwind (type 1)
    (global.set $__asyncify_state
      (i32.const 0))
    (if  ;; label = @1
      (i32.gt_u
        (i32.load
          (global.get $__asyncify_data))
        (i32.load offset=4
          (global.get $__asyncify_data)))
      (then
        (unreachable))))
  (func $asyncify_start_rewind (type 0) (param $DATA_ADDR i32)
    (global.set $__asyncify_state
      (i32.const 2))
    (global.set $__asyncify_data
      (local.get $DATA_ADDR))
    (if  ;; label = @1
      (i32.gt_u
        (i32.load
          (global.get $__asyncify_data))
        (i32.load offset=4
          (global.get $__asyncify_data)))
      (then
        (unreachable))))
  (func $asyncify_stop_rewind (type 1)
    (global.set $__asyncify_state
      (i32.const 0))
    (if  ;; label = @1
      (i32.gt_u
        (i32.load
          (global.get $__asyncify_data))
        (i32.load offset=4
          (global.get $__asyncify_data)))
      (then
        (unreachable))))
  (func $asyncify_get_state (type 3) (result i32)
    (global.get $__asyncify_state))
  (func $asyncify_set_state (type 0) (param i32)
    (global.set $__asyncify_state
      (local.get 0)))
  (func $asyncify_get_data (type 3) (result i32)
    (global.get $__asyncify_data))
  (func $asyncify_set_data (type 0) (param i32)
    (global.set $__asyncify_data
      (local.get 0)))
  (memory (;0;) 1)
  (global $__asyncify_state (mut i32) (i32.const 0))
  (global $__asyncify_data (mut i32) (i32.const 0))
  (export "fibonacci" (func $fibonacci))
  (export "memory" (memory 0))
  (export "asyncify_start_unwind" (func $asyncify_start_unwind))
  (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))
  (export "asyncify_start_rewind" (func $asyncify_start_rewind))
  (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))
  (export "asyncify_get_state" (func $asyncify_get_state))
  (export "asyncify_set_state" (func $asyncify_set_state))
  (export "asyncify_get_data" (func $asyncify_get_data))
  (export "asyncify_set_data" (func $asyncify_set_data)))
