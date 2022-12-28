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
 (func $is_prime (param $x i32) (result i32)
  (local $prime i32)
  (local $i i32)
  (local $result i32)
  (local $4 i32)
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
  (block
   (local.set $i
    (i32.const 0)
   )
   (block $exit
    (loop $top
     (block
      (local.set $4
       (local.get $i)
      )
      (local.set $5
       (i32.mul
        (local.get $4)
        (i32.const 4)
       )
      )
      (local.set $6
       (i32.load
        (local.get $5)
       )
      )
      (local.set $prime
       (local.get $6)
      )
      (local.set $result
       (i32.const 1)
      )
      (local.set $7
       (local.get $prime)
      )
      (local.set $8
       (local.get $prime)
      )
      (local.set $9
       (i32.mul
        (local.get $7)
        (local.get $8)
       )
      )
      (local.set $10
       (local.get $x)
      )
      (local.set $11
       (i32.gt_s
        (local.get $9)
        (local.get $10)
       )
      )
      (br_if $exit
       (local.get $11)
      )
      (local.set $result
       (i32.const 0)
      )
      (local.set $12
       (local.get $x)
      )
      (local.set $13
       (local.get $prime)
      )
      (local.set $14
       (i32.rem_s
        (local.get $12)
        (local.get $13)
       )
      )
      (local.set $15
       (i32.eq
        (local.get $14)
        (i32.const 0)
       )
      )
      (br_if $exit
       (local.get $15)
      )
      (local.set $16
       (local.get $i)
      )
      (local.set $17
       (i32.add
        (local.get $16)
        (i32.const 1)
       )
      )
      (local.set $i
       (local.get $17)
      )
      (br $top)
     )
    )
   )
   (local.set $18
    (local.get $result)
   )
   (local.set $19
    (local.get $18)
   )
  )
  (local.set $20
   (local.get $19)
  )
  (return
   (local.get $20)
  )
 )
 (func $1 (param $n i32) (result i32)
  (local $primes_count i32)
  (local $x i32)
  (local $3 i32)
  (local $4 i32)
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
  (local $21 i32)
  (block
   (i32.store
    (i32.const 0)
    (i32.const 2)
   )
   (local.set $primes_count
    (i32.const 1)
   )
   (local.set $x
    (i32.const 2)
   )
   (block $exit
    (loop $top
     (block
      (local.set $3
       (local.get $x)
      )
      (local.set $4
       (i32.add
        (local.get $3)
        (i32.const 1)
       )
      )
      (local.set $x
       (local.get $4)
      )
      (local.set $5
       (local.get $primes_count)
      )
      (local.set $6
       (local.get $n)
      )
      (local.set $7
       (i32.ge_s
        (local.get $5)
        (local.get $6)
       )
      )
      (br_if $exit
       (local.get $7)
      )
      (local.set $8
       (local.get $x)
      )
      (local.set $9
       (call $is_prime
        (local.get $8)
       )
      )
      (local.set $10
       (i32.eqz
        (local.get $9)
       )
      )
      (br_if $top
       (local.get $10)
      )
      (local.set $11
       (local.get $primes_count)
      )
      (local.set $12
       (i32.mul
        (local.get $11)
        (i32.const 4)
       )
      )
      (local.set $13
       (local.get $x)
      )
      (i32.store
       (local.get $12)
       (local.get $13)
      )
      (local.set $14
       (local.get $primes_count)
      )
      (local.set $15
       (i32.add
        (local.get $14)
        (i32.const 1)
       )
      )
      (local.set $primes_count
       (local.get $15)
      )
      (br $top)
     )
    )
   )
   (local.set $16
    (local.get $primes_count)
   )
   (local.set $17
    (i32.sub
     (local.get $16)
     (i32.const 1)
    )
   )
   (local.set $18
    (i32.mul
     (local.get $17)
     (i32.const 4)
    )
   )
   (local.set $19
    (i32.load
     (local.get $18)
    )
   )
   (local.set $20
    (local.get $19)
   )
  )
  (local.set $21
   (local.get $20)
  )
  (return
   (local.get $21)
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
