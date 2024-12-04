#!/usr/bin/env lua
local re = require"re"
f = "testdata.txt"
input = io.open(f, "r")

for line in input:lines() do
  print(line)
end

