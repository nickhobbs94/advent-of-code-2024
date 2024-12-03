#!/usr/bin/env lua
input = io.open(arg[1], "r")

enabled = true
mul = function (a,b) return tonumber(a)*tonumber(b) end

instructions = {}
instructions.mul = mul
instructions["do"] = function () enabled = true end
instructions["don't"] = function () enabled = false end

total = 0
function findNextInstruction(line, currentIndex)
  local nextDo, doend = line:find("do%(%)", currentIndex)
  local nextDont, dontend = line:find("don't%(%)", currentIndex)
  local nextMul, mulend, a, b = line:find("mul%((%d+),(%d+)%)", currentIndex)
  print(nextDo, doend, nextDont, dontend, nextMul, mulend)

  local first = math.min(nextDo or line:len(), nextDont or line:len())
  if (enabled) then
    first = math.min(first, nextMul or line:len())
  end

  local updated = line:len()

  if (first == nextDo) then
    print("do")
    enabled = true
    updated = doend
  end
  if (first == nextDont) then
    print("dont")
    enabled = false
    updated = dontend
  end
  if (first == nextMul) then
    total = total + mul(a,b)
    print("mul", a, b, total)
    updated = mulend
  end

  local result = updated ~= currentIndex and updated or line:len()
  print(result)
  return result
end

for line in input:lines() do
  i = 1
  while i < line:len() do
    i = findNextInstruction(line, i)
  end
    -- local ins, a, b = s:match("(mul)%((%d+),(%d+)%)")
    -- print(ins, a, b)
    -- local eval = instructions[ins](a,b)
    -- print(eval)
    -- total = total + eval
end
print(total)

