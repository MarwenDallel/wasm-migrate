(module
 (memory (export "memory") 700 700)
 (import "env" "sleep" (func $sleep (param i32)))
 (func $is_prime
  (param $x i32)
  (result i32)
  (local $prime i32)
  (local $i i32)
  (local $result i32)
  (local.set $i (i32.const 0))
  (block
  $exit
  (loop
    $top
    (local.set $prime (i32.load (i32.mul (local.get $i) (i32.const 4))))
    (local.set $result (i32.const 1))
    (br_if $exit (i32.gt_s (i32.mul (local.get $prime) (local.get $prime)) (local.get $x)))
    (local.set $result (i32.const 0))
    (br_if $exit (i32.eq (i32.rem_s (local.get $x) (local.get $prime)) (i32.const 0)))
    (local.set $i (i32.add (local.get $i) (i32.const 1)))
    (br $top)))
  (local.get $result))
 (func (export "prime")
  (param $n i32)
  (result i32)
  (local $primes_count i32)
  (local $x i32)
  (i32.store (i32.const 0) (i32.const 2))
  (local.set $primes_count (i32.const 1))
  (local.set $x (i32.const 2))
  (block
  $exit
  (loop
    $top
    (call $sleep (i32.const 1000))
    (local.set $x (i32.add (local.get $x) (i32.const 1)))
    (br_if $exit (i32.ge_s (local.get $primes_count) (local.get $n)))
    (br_if $top (i32.eqz (call $is_prime (local.get $x))))
    (i32.store (i32.mul (local.get $primes_count) (i32.const 4)) (local.get $x))
    (local.set $primes_count (i32.add (local.get $primes_count) (i32.const 1)))
    (br $top)))
  (i32.load (i32.mul (i32.sub (local.get $primes_count) (i32.const 1)) (i32.const 4))))
)
