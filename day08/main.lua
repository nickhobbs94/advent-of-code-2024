#!/usr/bin/env lua

filename = arg[1] or "testdata.txt"

local lib = require"advent"
local load = lib.load.load
local disp = lib.disp
local sleep = lib.sleep.sleep

sleep(1)
data = load(filename, "(%d+)")

disp.print2d(data)

