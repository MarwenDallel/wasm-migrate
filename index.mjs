import yargs from "yargs";
import { hideBin } from "yargs/helpers";
import { run, resume } from "./start.mjs";
import { startServer } from "./ws/wsServer.mjs";

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
    "Run wasm with migration support",
    (yargs) => {
      return yargs
        .positional("wasm-file", {
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
        .option("optimize", {
          describe: "Optimize the wasm file with asyncify",
          type: "boolean",
          default: false,
        });
    },
    (argv) => {
      run(argv.wasmFile, argv.fn, argv.args, argv.optimize, argv.port);
    }
  )
  .command(
    "resume <wasm-file> <dump-file> <fn> [args...]",
    "Resume execution of a migrated wasm program",
    (yargs) => {
      return yargs
        .positional("wasm-file", {
          describe: "Wasm file path",
          type: "string",
        })
        .positional("dump-file", {
          describe: "Memory dump file path",
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
        });
    },
    (argv) => {
      console.info(argv);
      resume(argv.wasmFile, argv.dumpFile, argv.fn, argv.args, argv.port);
    }
  )
  .demandCommand(1)
  .strict()
  .parse();
