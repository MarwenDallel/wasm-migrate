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
 (func $fibonacci (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (if
   (i32.eq
    (global.get $__asyncify_state)
    (i32.const 2)
   )
   (block
    (i32.store
     (global.get $__asyncify_data)
     (i32.sub
      (i32.load
       (global.get $__asyncify_data)
      )
      (i32.const 12)
     )
    )
    (local.set $0
     (i32.load
      (local.tee $1
       (i32.load
        (global.get $__asyncify_data)
       )
      )
     )
    )
    (local.set $3
     (i32.load offset=4
      (local.get $1)
     )
    )
    (local.set $1
     (i32.load offset=8
      (local.get $1)
     )
    )
   )
  )
  (local.set $2
   (block $__asyncify_unwind (result i32)
    (if
     (i32.eq
      (global.get $__asyncify_state)
      (i32.const 2)
     )
     (block
      (i32.store
       (global.get $__asyncify_data)
       (i32.sub
        (i32.load
         (global.get $__asyncify_data)
        )
        (i32.const 4)
       )
      )
      (local.set $4
       (i32.load
        (i32.load
         (global.get $__asyncify_data)
        )
       )
      )
     )
    )
    (local.set $3
     (select
      (local.get $3)
      (i32.const 1)
      (global.get $__asyncify_state)
     )
    )
    (loop $loop-in
     (if
      (i32.or
       (local.get $0)
       (i32.eq
        (global.get $__asyncify_state)
        (i32.const 2)
       )
      )
      (block
       (if
        (i32.eqz
         (global.get $__asyncify_state)
        )
        (block
         (local.set $2
          (local.get $3)
         )
         (local.set $3
          (local.get $1)
         )
         (local.set $1
          (i32.add
           (local.get $1)
           (local.get $2)
          )
         )
         (local.set $0
          (i32.sub
           (local.get $0)
           (i32.const 1)
          )
         )
        )
       )
       (if
        (i32.eqz
         (select
          (local.get $4)
          (i32.const 0)
          (global.get $__asyncify_state)
         )
        )
        (block
         (call $sleep
          (i32.const 1000)
         )
         (drop
          (br_if $__asyncify_unwind
           (i32.const 0)
           (i32.eq
            (global.get $__asyncify_state)
            (i32.const 1)
           )
          )
         )
        )
       )
       (br_if $loop-in
        (i32.eqz
         (global.get $__asyncify_state)
        )
       )
      )
     )
    )
    (if
     (i32.eqz
      (global.get $__asyncify_state)
     )
     (return
      (local.get $1)
     )
    )
    (unreachable)
   )
  )
  (i32.store
   (i32.load
    (global.get $__asyncify_data)
   )
   (local.get $2)
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
  (i32.store
   (local.tee $2
    (i32.load
     (global.get $__asyncify_data)
    )
   )
   (local.get $0)
  )
  (i32.store offset=4
   (local.get $2)
   (local.get $3)
  )
  (i32.store offset=8
   (local.get $2)
   (local.get $1)
  )
  (i32.store
   (global.get $__asyncify_data)
   (i32.add
    (i32.load
     (global.get $__asyncify_data)
    )
    (i32.const 12)
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
