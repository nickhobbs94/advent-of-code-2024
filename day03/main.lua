#!/usr/bin/env lua
input = io.open(arg[1], "r")

mul = function (a,b) return tonumber(a)*tonumber(b) end

instructions = {}
instructions.mul = mul

total = 0
for line in input:lines() do
  for s in line:gmatch("mul%(%d+,%d+%)") do
    local ins, a, b = s:match("(mul)%((%d+),(%d+)%)")
    print(ins, a, b)
    local eval = instructions[ins](a,b)
    print(eval)
    total = total + eval
  end
end
print(total)

