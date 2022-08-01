(module
  (type (;0;) (func (param i32)))
  (type (;1;) (func))
  (type (;2;) (func (param i32) (result i32)))
  (type (;3;) (func (result i32)))
  (import "env" "sleep" (func $sleep (type 0)))
  (func $fibonacci (type 2) (param $index i32) (result i32)
    (local $fibn i32)
    (local $fibn1 i32)
    (local $fibn2 i32)
    (local $n i32)
    (local $index_loop_cpy i32)
    (local $loop_condition i32)
    (local $fibn1_cpy i32)
    (local $fibn_cpy i32)
    (local $fibn1_add_cpy i32)
    (local $fibn2_add_cpy i32)
    (local $fibn_add_result i32)
    (local $index_cpy i32)
    (local $index_sub_cpy i32)
    (local $14 i32) ;; this is never stored in memory not used in anything but to make a simple copy of the return value
    (local $fibn_return_cpy i32)
    (local $return_value i32)
    (local $call_index i32)
    (local $restored_call_index i32)
    (local $local_start_addr_load i32)
    (local $local_start_addr_store i32)
    ;; Right after start_rewind, execution is resumed here
    ;; if rewinding
    global.get $__asyncify_state
    i32.const 2
    i32.eq
    if  ;; label = @1
      ;; loadLocals()
      global.get $__asyncify_data
      global.get $__asyncify_data
      i32.load
      ;; 4 locals will be restored, so use space reduced by 16. (from 76 to 60). This means that local 17 is not accounted for.
      i32.const -16
      i32.add
      i32.store ;; 60 is stored at addr 48.
      ;; locals are read one by one starting from addr 60
      global.get $__asyncify_data
      i32.load
      local.set $local_start_addr_load
      local.get $local_start_addr_load ;; $local_start_addr contains the address of the first local.
      i32.load
      local.set $index
      local.get $local_start_addr_load
      i32.load offset=4
      local.set $fibn
      local.get $local_start_addr_load
      i32.load offset=8
      local.set $fibn1
      local.get $local_start_addr_load
      i32.load offset=12
      local.set $fibn_return_cpy ;; copy of return value of last iteration
    end
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          ;; if rewinding
          global.get $__asyncify_state
          i32.const 2
          i32.eq
          ;; subtract 4 from the used space to account for local $call_index and update the used space
          if  ;; label = @4
            global.get $__asyncify_data
            global.get $__asyncify_data
            i32.load
            i32.const -4
            i32.add
            i32.store ;; store 56 at addr 48
            global.get $__asyncify_data
            i32.load ;; load addr 48 (56)
            i32.load ;; load addr 56 (0) ;; this is where $call_index is stored
            local.set $restored_call_index
          end
          block  ;; label = @4
            block  ;; label = @5
              ;; Normal execution, initialize locals
              global.get $__asyncify_state
              i32.const 0
              i32.eq
              if  ;; label = @6
                i32.const 0
                local.set $fibn
                i32.const 1
                local.set $fibn1
                i32.const 0
                local.set $fibn2
              end
              nop
              nop
              block  ;; label = @6
                loop  ;; label = @7
                  ;; Normal execution, while loop fibonacci
                  ;; Condition is also copied into a temporary local 6
                  ;; This allows us to flatten branches and skip blocks during rewind.
                  ;; Local(5) = index (initial value)
                  ;; Local(6) = Condition (if index == 0)
                  ;; Local(7) = fibn1 (previous iteration)
                  ;; Local(8) = fibn (previous iteration)
                  ;; Local(9) = fibn1 (current iteration)
                  ;; Local(10) = fibn2 (current iteration)
                  ;; Local(11) = fibn (current iteration) // result of addition
                  ;; Local(12) = index (current iteration)
                  ;; Local(13) = index (next iteration) // result of subtraction
                  block  ;; label = @8
                    global.get $__asyncify_state
                    i32.const 0
                    i32.eq
                    if  ;; label = @9
                      local.get $index
                      local.set $index_loop_cpy
                      local.get $index_loop_cpy
                      i32.eqz
                      local.set $loop_condition
                      local.get $loop_condition
                      br_if 3 (;@6;)
                      ;; Normal fibonacci
                      ;; $fibn2 = $fibn1
                      ;; $fibn1 = $fibn
                      ;; $fibn = $fibn1 + $fibn2
                      ;; $index = $index - 1

                      ;; Asyncify fibonacci
                      ;; $fibn1_cpy = $fibn1
                      ;; $fibn2 = $fibn1_cpy

                      ;; $fibn_cpy = $fibn
                      ;; $fibn1 = $fibn_cpy

                      ;; $fibn1_add_cpy = $fibn1
                      ;; $fibn2_add_cpy = $fibn2
                      ;; $fibn_add_result = $fibn1_add_cpy + $fibn2_add_cpy
                      ;; $fibn = $fibn_add_result

                      ;; $index_cpy = $index
                      ;; $index_sub_cpy = $index_cpy - 1
                      ;; $index = $index_sub_cpy
                      local.get $fibn1
                      local.set $fibn1_cpy
                      local.get $fibn1_cpy
                      local.set $fibn2

                      local.get $fibn
                      local.set $fibn_cpy
                      local.get $fibn_cpy
                      local.set $fibn1

                      local.get $fibn1
                      local.set $fibn1_add_cpy
                      local.get $fibn2
                      local.set $fibn2_add_cpy
                      local.get $fibn1_add_cpy
                      local.get $fibn2_add_cpy
                      i32.add
                      local.set $fibn_add_result
                      local.get $fibn_add_result
                      local.set $fibn

                      local.get $index
                      local.set $index_cpy
                      local.get $index_cpy
                      i32.const 1
                      i32.sub
                      local.set $index_sub_cpy
                      local.get $index_sub_cpy
                      local.set $index
                    end
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    nop
                    ;; Function calls are encapsulated in blocks to allow rewinding.
                    ;; During normal execution, we fake return from the function.
                    ;; 1 is set on top of the stack
                    global.get $__asyncify_state
                    i32.const 0
                    i32.eq
                    if (result i32)  ;; label = @9
                      i32.const 1
                    else
                      ;; Checks whether we should enter sleep
                      ;; Sleep has index 0, so if call_index is 0, we enter sleep.
                      ;; Executed when rewinding
                      local.get $restored_call_index ;; = 0
                      i32.const 0
                      i32.eq
                    end
                    ;; If the condition is true, we sleep
                    ;; During sleep start_unwind() is called, which sets the state to unwinding.
                    if  ;; label = @9
                      i32.const 1000
                      call $sleep
                      global.get $__asyncify_state
                      i32.const 1
                      i32.eq
                      ;; If unwinding pop 9 blocks up
                      if  ;; label = @10
                        i32.const 0 ;; call index
                        br 9 (;@1;)
                      end
                    end
                    ;; If we just finished rewinding, then we pop 2 blocks. (equivalent of continue)
                    ;; We skip the current iteration.
                    global.get $__asyncify_state
                    i32.const 0
                    i32.eq
                    if  ;; label = @9
                      br 2 (;@7;)
                    end
                  end
                end
              end
              ;; If normal execution
              ;; This is the return value of the function
              ;; local.get $fibn
              ;; We make two copies of the return value 
              global.get $__asyncify_state
              i32.const 0
              i32.eq
              if  ;; label = @6
                local.get $fibn
                local.set $14
                local.get $14
                local.set $fibn_return_cpy
              end
              nop
            end
            ;; If normal execution
            global.get $__asyncify_state
            i32.const 0
            i32.eq
            if  ;; label = @5
              local.get $fibn_return_cpy
              local.set $return_value
              local.get $return_value
              return
            end
            nop
          end
          unreachable
        end
        unreachable
      end
      unreachable
    end
    ;; First time $call_index is used (right after sleep call/when unwinding)
    ;; $call_index is set to 0
    local.set $call_index ;; resume execution here (after 9 blocks popped)
    ;; Stores $call_index in memory and increments pointer to data
    block  ;; label = @1
      ;; Load value 56 using offset 48
      global.get $__asyncify_data
      i32.load
      ;; Store 0 at offset 56
      local.get $call_index
      i32.store
      ;; Store 60 at offset 48
      global.get $__asyncify_data
      global.get $__asyncify_data
      i32.load
      i32.const 4
      i32.add
      i32.store
    end
    ;; Store all locals in memory starting at addr/offset 60
    block  ;; label = @1
      global.get $__asyncify_data
      i32.load
      local.set $local_start_addr_store ;; $local_start_addr contains the address of the first local (60)
      local.get $local_start_addr_store
      local.get $index
      i32.store
      local.get $local_start_addr_store
      local.get $fibn
      i32.store offset=4
      local.get $local_start_addr_store
      local.get $fibn1
      i32.store offset=8
      local.get $local_start_addr_store
      local.get $fibn_return_cpy
      i32.store offset=12
      ;; Store at addr 48 intial offset + space used by locals
      ;; (76)
      global.get $__asyncify_data
      global.get $__asyncify_data
      i32.load
      i32.const 16
      i32.add
      i32.store
    end
    ;; Fake return value
    ;; This marks the end of stack unwinding
    ;; After this, stop_unwind is called
    i32.const 0)
  (func $asyncify_start_unwind (param $DATA_ADDR i32)
    ;; Set state to unwinding
    i32.const 1
    global.set $__asyncify_state
    ;; Initially, $__asyncify_data is set to the address of the data structure. (48)
    local.get $DATA_ADDR
    global.set $__asyncify_data

    ;; Load value at $__asyncify_data address from memory (56)
    ;; Load value right after $__asyncify_data from memory (1024)
    ;; Start addr = 56; End addr = 1024
    ;; Check if we exceeded end addr
    ;; If start > end, stop execution (unreachable)
    global.get $__asyncify_data
    i32.load
    global.get $__asyncify_data
    i32.load offset=4
    i32.gt_u
    if  ;; label = @1
      unreachable
    end 
  )
  (func $asyncify_stop_unwind
    ;; Set state back to normal
    i32.const 0
    global.set $__asyncify_state
    ;; Check if we exceeded end addr (76 < 1024)
    global.get $__asyncify_data
    i32.load
    global.get $__asyncify_data
    i32.load offset=4
    i32.gt_u
    if  ;; label = @1
      unreachable
    ;; Control is given back to JS code, then stack rewinding starts.
    end
  )
  (func $asyncify_start_rewind (param $DATA_ADDR i32)
    ;; Set state to rewinding
    i32.const 2
    global.set $__asyncify_state
    ;; Load stack size from memory (76)
    local.get $DATA_ADDR
    global.set $__asyncify_data
    
    ;; Check if we exceeded limit (76 < 1024)
    global.get $__asyncify_data
    i32.load
    global.get $__asyncify_data
    i32.load offset=4
    i32.gt_u
    if  ;; label = @1
      unreachable
    end 
  )
  (func $asyncify_stop_rewind
    ;; Set state back to normal
    i32.const 0
    global.set $__asyncify_state
    ;; Check if we exceeded end addr (56 < 1024)
    global.get $__asyncify_data
    i32.load
    global.get $__asyncify_data
    i32.load offset=4
    i32.gt_u
    if  ;; label = @1
      unreachable
    end
  )
  (func $asyncify_get_state (result i32)
    global.get $__asyncify_state
  )
  (func $asyncify_set_state (param i32)
    local.get 0
    global.set $__asyncify_state
  )
  (func $asyncify_get_data (result i32)
    global.get $__asyncify_data
  )
  (func $asyncify_set_data (param i32)
    local.get 0
    global.set $__asyncify_data
  )
  (memory (;0;) 1)
  (global $__asyncify_state (mut i32) (i32.const 0))
  ;; Contains a pointer to a data structure
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
  (export "asyncify_set_data" (func $asyncify_set_data))
)