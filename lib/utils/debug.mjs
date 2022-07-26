export function stackRepr(stack) {
  console.clear();
  let variablesNames = [
    "$stack_pointer",
    "$stack_max_size",
    "$call_index",
    "$index",
    "$fibn",
    "$fibn1",
    "$return_value",
  ];
  let variables = {};
  variablesNames.forEach((name, index) => {
    variables[name] = stack[index];
  });
  console.table(variables);
}
