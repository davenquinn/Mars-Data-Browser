#!/usr/bin/env node

var repl = require("repl");

var topojson = require("./ctx.json");

var sh = repl.start("node via stdin> ");

sh.context.topojson = topojson;

