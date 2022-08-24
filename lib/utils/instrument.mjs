// @ts-nocheck
import fs from "fs";
import { decode } from "@webassemblyjs/wasm-parser";
import { add, edit, addWithAST, editWithAST } from "@webassemblyjs/wasm-edit";
import * as t from "@webassemblyjs/ast";
import validation from "@webassemblyjs/validation";

const validateAST = validation.default;

const wasmFile = fs.readFileSync("./wasm/fibonacci.wasm");

const ast = decode(wasmFile, { ignoreCustomNameSection: true });

const functionSignature = t.signature([], []);
const funcType = t.typeInstruction(undefined, functionSignature);

const sleepFuncIndex = t.numberLiteralFromRaw(1);
// module, name, desc
// type BaseNode = {
//   type: string,
//   loc?: ?SourceLocation,

//   // Internal property
//   _deleted?: ?boolean,
// };
// type Identifier = {
//   ...BaseNode,
//   type: "Identifier",
//   value: string,
//   raw?: string,
// };
const sleep = t.moduleImport(
  "env",
  "sleep",
  t.funcImportDescr(sleepFuncIndex, functionSignature)
);

let actualBinary = addWithAST(ast, wasmFile, [funcType, sleep]);

let newBinary = editWithAST(ast, actualBinary, {
  // Shift all exported indices after adding an imported function
  ModuleExport(path) {
    const {
      name,
      descr: { exportType, id },
    } = path.node;
    if (exportType === "Func" && id.type === "NumberLiteral") {
      const funcExportNode = t.moduleExport(
        name,
        t.moduleExportDescr("Func", t.indexLiteral(++id.value))
      );
      path.replaceWith(funcExportNode);
    }
  },

  LoopInstruction(path) {
    const sleepCall = t.callInstruction(sleepFuncIndex);
    console.log(sleepCall);

    // Get second to last node in loop
    const stlNode = path.node.instr[path.node.instr.length - 2];

    // Place sleep call after stl node
    sleepCall.loc = {
      start: {
        line: -1,
        column: stlNode.loc.end.column,
      },
      end: {
        line: -1,
        column: stlNode.loc.end.column + 2,
      },
    };

    // Shift all indices after adding a sleep call
    const lastNode = path.node.instr[path.node.instr.length - 1];
    // Determine loc of instruction
    const lastNodeLoc = lastNode.loc.end.column - lastNode.loc.start.column;

    // Shift index of lastNode
    lastNode.loc.start.column = sleepCall.loc.end.column;
    lastNode.loc.end.column = sleepCall.loc.end.column + lastNodeLoc;

    path.node.instr.splice(path.node.instr.length - 1, 0, sleepCall);
    console.dir(path.node.instr, { depth: null });
  },

  // Instr(path) {
  //   const { node, parentPath, parentKey } = path;
  //   // Add call to sleep after each end instruction
  //   if (node.id === "end") {
  //     const sleepCall = t.callInstruction(sleepFuncIndex);

  //     const parentList = parentPath.node[parentKey];
  //     path.insertBefore(sleepCall);
  //     //console.dir(parentList, { depth: null });
  //   }
  // },
});

validateAST(newBinary);

fs.writeFileSync("wasm/fibonacci.current.json", JSON.stringify(ast, null, 2));

fs.writeFileSync("wasm/fibonacci.current.wasm", new Uint8Array(newBinary));

// create webassembly module
const module = new WebAssembly.Instance(new WebAssembly.Module(newBinary), {
  env: {
    sleep: () => {
      console.log("EDOOD");
    },
  },
});

console.dir(module.exports.fibonacci(10), { depth: null });

process.exit(0);

const ir = binaryen.readBinary(Buffer.from(actualBinary));

// ir.runPasses(["asyncify"]);
// binaryen.setOptimizeLevel(1);
// ir.optimize();

// Validate the module
if (!ir.validate()) throw new Error("validation error");

let wasmData = ir.emitText();

fs.writeFileSync("./wasm/fibonacci.sleep.wat", wasmData);
