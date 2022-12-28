
(module
  (export "fact" (func $fact))
  (func $fact (param $x i64) (result i64)
    (local.get $x)
    (i64.const 1)

    (if (result i64) (i64.le_s)
      (then
        (local.get $x)
      )
      (else
        (local.get $x)
        (i64.const 1)
        (i64.sub)

        (call $fact)
        (local.get $x)
        (i64.mul)
      )
    )
  )     
)