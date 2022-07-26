(module
 (type $i32_=>_none (func (param i32)))
 (type $none_=>_none (func))
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $none_=>_i32 (func (result i32)))
 (import "env" "sleep" (func $sleep (param i32)))
 (global $__asyncify_state (mut i32) (i32.const 0))
 (global $__asyncify_data (mut i32) (i32.const 0))
 (memory $0 1)
 (export "fibonacci" (func $fibonacci))
 (export "memory" (memory $0))
 (export "asyncify_start_unwind" (func $asyncify_start_unwind))
 (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))
 (export "asyncify_start_rewind" (func $asyncify_start_rewind))
 (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))
 (export "asyncify_get_state" (func $asyncify_get_state))
 (func $fibonacci (param $index i32) (result i32)
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
  (local $19 i32)
  (local $20 i32)
  (if
   (i32.eq
    (global.get $__asyncify_state)
    (i32.const 2)
   )
   (block
    (i32.store
     (global.get $__asyncify_data)
     (i32.add
      (i32.load
       (global.get $__asyncify_data)
      )
      (i32.const -16)
     )
    )
    (local.set $19
     (i32.load
      (global.get $__asyncify_data)
     )
    )
    (local.set $index
     (i32.load
      (local.get $19)
     )
    )
    (local.set $fibn
     (i32.load offset=4
      (local.get $19)
     )
    )
    (local.set $fibn1
     (i32.load offset=8
      (local.get $19)
     )
    )
    (local.set $15
     (i32.load offset=12
      (local.get $19)
     )
    )
   )
  )
  (local.set $17
   (block $__asyncify_unwind (result i32)
    (block
     (block
      (if
       (i32.eq
        (global.get $__asyncify_state)
        (i32.const 2)
       )
       (block
        (i32.store
         (global.get $__asyncify_data)
         (i32.add
          (i32.load
           (global.get $__asyncify_data)
          )
          (i32.const -4)
         )
        )
        (local.set $18
         (i32.load
          (i32.load
           (global.get $__asyncify_data)
          )
         )
        )
       )
      )
      (block
       (block
        (if
         (i32.eq
          (global.get $__asyncify_state)
          (i32.const 0)
         )
         (block
          (local.set $fibn
           (i32.const 0)
          )
          (local.set $fibn1
           (i32.const 1)
          )
          (local.set $fibn2
           (i32.const 0)
          )
         )
        )
        (nop)
        (nop)
        (block $block
         (loop $loop-in
          (block
           (if
            (i32.eq
             (global.get $__asyncify_state)
             (i32.const 0)
            )
            (block
             (local.set $5
              (local.get $index)
             )
             (local.set $6
              (i32.eqz
               (local.get $5)
              )
             )
             (br_if $block
              (local.get $6)
             )
             (local.set $7
              (local.get $fibn1)
             )
             (local.set $fibn2
              (local.get $7)
             )
             (local.set $8
              (local.get $fibn)
             )
             (local.set $fibn1
              (local.get $8)
             )
             (local.set $9
              (local.get $fibn1)
             )
             (local.set $10
              (local.get $fibn2)
             )
             (local.set $11
              (i32.add
               (local.get $9)
               (local.get $10)
              )
             )
             (local.set $fibn
              (local.get $11)
             )
             (local.set $12
              (local.get $index)
             )
             (local.set $13
              (i32.sub
               (local.get $12)
               (i32.const 1)
              )
             )
             (local.set $index
              (local.get $13)
             )
            )
           )
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
           (if
            (if (result i32)
             (i32.eq
              (global.get $__asyncify_state)
              (i32.const 0)
             )
             (i32.const 1)
             (i32.eq
              (local.get $18)
              (i32.const 0)
             )
            )
            (block
             (call $sleep
              (i32.const 1000)
             )
             (if
              (i32.eq
               (global.get $__asyncify_state)
               (i32.const 1)
              )
              (br $__asyncify_unwind
               (i32.const 0)
              )
             )
            )
           )
           (if
            (i32.eq
             (global.get $__asyncify_state)
             (i32.const 0)
            )
            (br $loop-in)
           )
          )
         )
        )
        (if
         (i32.eq
          (global.get $__asyncify_state)
          (i32.const 0)
         )
         (block
          (local.set $14
           (local.get $fibn)
          )
          (local.set $15
           (local.get $14)
          )
         )
        )
        (nop)
       )
       (if
        (i32.eq
         (global.get $__asyncify_state)
         (i32.const 0)
        )
        (block
         (local.set $16
          (local.get $15)
         )
         (return
          (local.get $16)
         )
        )
       )
       (nop)
      )
      (unreachable)
     )
     (unreachable)
    )
   )
  )
  (block
   (i32.store
    (i32.load
     (global.get $__asyncify_data)
    )
    (local.get $17)
   )
   (i32.store
    (global.get $__asyncify_data)
    (i32.add
     (i32.load
      (global.get $__asyncify_data)
     )
     (i32.const 4)
    )
   )
  )
  (block
   (local.set $20
    (i32.load
     (global.get $__asyncify_data)
    )
   )
   (i32.store
    (local.get $20)
    (local.get $index)
   )
   (i32.store offset=4
    (local.get $20)
    (local.get $fibn)
   )
   (i32.store offset=8
    (local.get $20)
    (local.get $fibn1)
   )
   (i32.store offset=12
    (local.get $20)
    (local.get $15)
   )
   (i32.store
    (global.get $__asyncify_data)
    (i32.add
     (i32.load
      (global.get $__asyncify_data)
     )
     (i32.const 16)
    )
   )
  )
  (i32.const 0)
 )
 (func $asyncify_start_unwind (param $0 i32)
  (global.set $__asyncify_state
   (i32.const 1)
  )
  (global.set $__asyncify_data
   (local.get $0)
  )
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
  (global.set $__asyncify_state
   (i32.const 0)
  )
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
 (func $asyncify_start_rewind (param $0 i32)
  (global.set $__asyncify_state
   (i32.const 2)
  )
  (global.set $__asyncify_data
   (local.get $0)
  )
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
  (global.set $__asyncify_state
   (i32.const 0)
  )
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
)
