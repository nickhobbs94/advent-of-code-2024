#!/usr/bin/env lua

filename = arg[1] or "testdata.txt"

sleep = require("sleep")
load = require("load")
disp = require"disp"

sleep.sleep(1)
data = load.load(filename, "(%d+)")

pr.print2d(data)

