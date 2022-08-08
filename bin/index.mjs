#!/usr/bin/env node

import yargs from "yargs";
import { hideBin } from "yargs/helpers";
import { run } from "../lib/start.mjs";
import { startServer } from "../lib/ws/wsServer.mjs";

yargs(hideBin(process.argv))
  .scriptName("wasm-migrate")
  .command(
    "serve",
    "Start server",
    (yargs) => {
      return yargs.option("port", {
        describe: "Port number of server",
        type: "number",
        default: 8080,
      });
    },
    (argv) => {
      startServer(argv.port);
    }
  )
  .command(
    "run <wasm-file> <fn> [args...]",
    "Start or resume execution with migration support",
    (yargs) => {
      return yargs
        .positional("f", {
          alias: "wasm-file",
          describe: "Wasm file path",
          type: "string",
        })
        .positional("fn", {
          describe: "Start function name",
          type: "string",
        })
        .positional("args", {
          describe: "Arguments to pass to the start function",
          type: "number",
        })
        .option("port", {
          describe: "Port number of server",
          type: "number",
          default: 8080,
        })
        .option("d", {
          alias: ["dump", "dump-file"],
          describe: "Memory dump file path",
          type: "string",
        })
        .option("optimize", {
          describe: "Optimize the wasm file with asyncify",
          type: "boolean",
          default: true,
        });
    },
    (argv) => {
      run(
        argv.wasmFile,
        argv.fn,
        argv.args,
        argv.dumpFile,
        argv.optimize,
        argv.port
      );
    }
  )
  .demandCommand(1)
  .strict()
  .parse();
