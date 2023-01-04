const memoryLayout = {
  fibonacci: {
    variables: [
      "$stack_pointer",
      "$stack_max_size",
      "$call_index",
      "$index",
      "$fibn",
      "$fibn1",
      "$return_value",
    ],
    peakIndex: 7,
  },
};

export function stackRepr(asyncify) {
  console.clear();
  const startFnName = asyncify.startFnName;
  const layout = memoryLayout[startFnName];
  const stack = asyncify.data.peak(layout.peakIndex);
  let variablesNames = layout.variables;
  let variables = {};
  variablesNames.forEach((name, index) => {
    variables[name] = stack[index];
  });
  //console.table(variables);
  //console.table(asyncify.data.peak(32));
}
