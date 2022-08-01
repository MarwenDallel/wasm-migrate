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
    (local $5 i32)
    (local $6 i32)
    (local $7 i32)
    (local $8 i32)
    (local $9 i32)
    (local $10 i32)
    (local $11 i32)
    (local $12 i32)
    (local $13 i32)
    (local $14 i32)
    (local $15 i32)
    (local $16 i32)
    (local $17 i32)
    (local $18 i32)
    (local $local_start_addr i32)
    (local $20 i32)
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
      local.set $local_start_addr
      local.get $local_start_addr ;; $local_start_addr contains the address of the first local.
      i32.load
      local.set $index
      local.get $local_start_addr
      i32.load offset=4
      local.set $fibn
      local.get $local_start_addr
      i32.load offset=8
      local.set $fibn1
      local.get $local_start_addr
      i32.load offset=12
      local.set $15 ;; copy of $fibn2?
    end
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          ;; if rewinding
          global.get $__asyncify_state
          i32.const 2
          i32.eq
          ;; subtract 4 from the used space to account for local $17 and update the used space
          if  ;; label = @4
            global.get $__asyncify_data
            global.get $__asyncify_data
            i32.load
            i32.const -4
            i32.add
            i32.store ;; store 56 at addr 48
            global.get $__asyncify_data
            i32.load ;; load addr 48 (56)
            i32.load ;; load addr 56 (0) ;; this is where $17 is stored
            local.set $18 ;; $18 = 0, why?
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
                      local.set $5
                      local.get $5
                      i32.eqz
                      local.set $6
                      local.get $6
                      br_if 3 (;@6;)
                      local.get $fibn1
                      local.set $7
                      local.get $7
                      local.set $fibn2
                      local.get $fibn
                      local.set $8
                      local.get $8
                      local.set $fibn1
                      local.get $fibn1
                      local.set $9
                      local.get $fibn2
                      local.set $10
                      local.get $9
                      local.get $10
                      i32.add
                      local.set $11
                      local.get $11
                      local.set $fibn
                      local.get $index
                      local.set $12
                      local.get $12
                      i32.const 1
                      i32.sub
                      local.set $13
                      local.get $13
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
                      ;; Executing when rewinding, and evaluated to true.
                      local.get $18 ;; = 0
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
                        i32.const 0
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
              global.get $__asyncify_state
              i32.const 0
              i32.eq
              if  ;; label = @6
                local.get $fibn
                local.set $14
                local.get $14
                local.set $15
              end
              nop
            end
            global.get $__asyncify_state
            i32.const 0
            i32.eq
            if  ;; label = @5
              local.get $15
              local.set $16
              local.get $16
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
    ;; $17 is set to 0
    local.set $17 ;; resume execution here (after 9 blocks popped)
    ;; Stores $17 in memory and increments pointer to data
    block  ;; label = @1
      ;; Load value 56 using offset 48
      global.get $__asyncify_data
      i32.load
      ;; Store 0 at offset 56
      local.get $17
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
      local.set $20 ;; $20 contains the address of the first local (60)
      local.get $20
      local.get $index
      i32.store
      local.get $20
      local.get $fibn
      i32.store offset=4
      local.get $20
      local.get $fibn1
      i32.store offset=8
      local.get $20
      local.get $15
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
    (global.set $__asyncify_state
    (i32.const 1)
    )
    ;; Initially, $__asyncify_data is set to the address of the data structure. (48)
    (global.set $__asyncify_data
    (local.get $DATA_ADDR)
    )
    ;; Load value at $__asyncify_data address from memory (56)
    ;; Load value right after $__asyncify_data from memory (1024)
    ;; Start addr = 56; End addr = 1024
    ;; Check if we exceeded end addr
    ;; If start > end, stop execution (unreachable)
    (if
    (i32.gt_u
      (i32.load
      (global.get $__asyncify_data)
      )
      (i32.load offset=4
      (global.get $__asyncify_data)
      )
    )
    (unreachable)
    )
  )
  (func $asyncify_stop_unwind
    ;; Set state back to normal
    (global.set $__asyncify_state
    (i32.const 0)
    )
    ;; Check if we exceeded end addr (76 < 1024)
    (if
    (i32.gt_u
      (i32.load
      (global.get $__asyncify_data)
      )
      (i32.load offset=4
      (global.get $__asyncify_data)
      )
    )
    ;; Control is given back to JS code, then stack rewinding starts.
    (unreachable)
    )
  )
  (func $asyncify_start_rewind (param $DATA_ADDR i32)
    ;; Set state to rewinding
    (global.set $__asyncify_state
    (i32.const 2)
    )
    ;; Load stack size from memory (76)
    (global.set $__asyncify_data
    (local.get $DATA_ADDR)
    )
    ;; Check if we exceeded limit (76 < 1024)
    (if
    (i32.gt_u
      (i32.load
      (global.get $__asyncify_data)
      )
      (i32.load offset=4
      (global.get $__asyncify_data)
      )
    )
    (unreachable)
    )
  )
  (func $asyncify_stop_rewind
    ;; Set state back to normal
    (global.set $__asyncify_state
    (i32.const 0)
    )
    ;; Check if we exceeded end addr (56 < 1024)
    (if
    (i32.gt_u
      (i32.load
      (global.get $__asyncify_data)
      )
      (i32.load offset=4
      (global.get $__asyncify_data)
      )
    )
    (unreachable)
    )
  )
  (func $asyncify_get_state (result i32)
    (global.get $__asyncify_state)
  )
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
)