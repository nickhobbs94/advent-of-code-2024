#!/usr/bin/env lua
input = io.open(arg[1], "r")

mul = 7

instructions = {"mul"= mul,}

print(instructions["mul"])

for line in input:lines() do
  for s in line:gmatch("%d+") do
    --print(s)
  end
end

