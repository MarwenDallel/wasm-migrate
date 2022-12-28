(module
 (type $i32_=>_i32 (func (param i32) (result i32)))
 (type $i32_=>_none (func (param i32)))
 (type $none_=>_none (func))
 (type $none_=>_i32 (func (result i32)))
 (global $__asyncify_state (mut i32) (i32.const 0))
 (global $__asyncify_data (mut i32) (i32.const 0))
 (memory $0 700 700)
 (export "primes" (memory $0))
 (export "prime" (func $1))
 (export "asyncify_start_unwind" (func $asyncify_start_unwind))
 (export "asyncify_stop_unwind" (func $asyncify_stop_unwind))
 (export "asyncify_start_rewind" (func $asyncify_start_rewind))
 (export "asyncify_stop_rewind" (func $asyncify_stop_rewind))
 (export "asyncify_get_state" (func $asyncify_get_state))
 (func $0 (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (loop $label$2
   (block $label$1
    (local.set $1
     (i32.const 1)
    )
    (br_if $label$1
     (i32.gt_s
      (i32.mul
       (local.tee $3
        (i32.load
         (i32.shl
          (local.get $2)
          (i32.const 2)
         )
        )
       )
       (local.get $3)
      )
      (local.get $0)
     )
    )
    (local.set $1
     (i32.const 0)
    )
    (br_if $label$1
     (i32.eqz
      (i32.rem_s
       (local.get $0)
       (local.get $3)
      )
     )
    )
    (local.set $2
     (i32.add
      (local.get $2)
      (i32.const 1)
     )
    )
    (br $label$2)
   )
  )
  (local.get $1)
 )
 (func $1 (param $0 i32) (result i32)
  (local $1 i32)
  (local $2 i32)
  (i32.store
   (i32.const 0)
   (i32.const 2)
  )
  (local.set $1
   (i32.const 1)
  )
  (local.set $2
   (i32.const 2)
  )
  (loop $label$2
   (block $label$1
    (local.set $2
     (i32.add
      (local.get $2)
      (i32.const 1)
     )
    )
    (br_if $label$1
     (i32.le_s
      (local.get $0)
      (local.get $1)
     )
    )
    (br_if $label$2
     (i32.eqz
      (call $0
       (local.get $2)
      )
     )
    )
    (i32.store
     (i32.shl
      (local.get $1)
      (i32.const 2)
     )
     (local.get $2)
    )
    (local.set $1
     (i32.add
      (local.get $1)
      (i32.const 1)
     )
    )
    (br $label$2)
   )
  )
  (i32.load
   (i32.shl
    (i32.sub
     (local.get $1)
     (i32.const 1)
    )
    (i32.const 2)
   )
  )
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
