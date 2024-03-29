#!/usr/bin/env node

import yargs from "yargs";
import { hideBin } from "yargs/helpers";
import mqttCommandIssuer from "../lib/cli/mqttCommandIssuer.mjs";
import { runPassive } from "../lib/start.timed.mjs";

yargs(hideBin(process.argv))
  .scriptName("wasm-migrate")
  .command(
    "start-passive",
    "Starts a passive client",
    (yargs) => {
      return yargs.option("cid", {
        alias: ["client-id"],
        describe: "Client ID",
        type: "string",
      });
    },
    (argv) => {
      runPassive(argv.clientId);
    }
  )
  .command(
    "start <client-id> <wasm-file> <fn> [args...]",
    "Start or resume execution with migration support",
    (yargs) => {
      return yargs
        .positional("client-id", {
          describe: "MQTT client ID",
          type: "string",
        })
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
      mqttCommandIssuer.startOrResume(
        argv.clientId,
        argv.wasmFile,
        argv.fn,
        argv.args,
        argv.dumpFile,
        argv.optimize
      );
    }
  )
  .command(
    "migrate <source-cid> <destination-cid>",
    "Migrates the execution to another client",
    (yargs) => {
      return yargs
        .positional("source-cid", {
          alias: ["src-cid", "src"],
          describe: "Source client ID",
          type: "string",
        })
        .positional("destionation-cid", {
          alias: ["dst-cid", "dst"],
          describe: "Destionation client ID",
          type: "string",
        });
    },
    (argv) => {
      mqttCommandIssuer.migrate(argv.sourceCid, argv.destinationCid);
    }
  )
  .demandCommand(1)
  .strict()
  .parse();
