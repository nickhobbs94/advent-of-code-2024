#!/usr/bin/env lua

local filename = arg[1] or "testdata.txt"

local lib = require"advent"
local fmt = lib.disp.fmt2arr
local fmtarr = lib.disp.fmtarr
local VecSet = lib.VecSet

function parser (inputLine, pattern)
  local x,y = inputLine:match(pattern)
  return tonumber(x), tonumber(y)
end

local input = io.open(filename, "r")

function adv (machine)
  local numerator = machine.a
  local denominator = math.pow(2,machine:combo())
  machine.a = math.floor(numerator / denominator)
end

function bst (machine)
  local input = machine:combo()
  machine.b = input % 8
end

instructions = {
  [0] = adv,
  [1] = bxl,
  [2] = bst,
  [3] = jnz,
  [4] = bxc,
  [5] = out,
  [6] = bdv,
  [7] = cdv,
}

state = {
  halted = false,
  a = 0,
  b = 0,
  c = 9,
  iptr = 1,
  program = {2,6},
  outputs = {},
}

function state.instruction (self)
  local opcode = self.program[self.iptr]
  return instructions[opcode]
end

function state.advance (self)
  self.iptr = self.iptr + 2
end

function state.operand (self)
  return self.program[self.iptr + 1]
end

function state.combo (self)
  local operand = self:operand()
  if operand <= 3 then
    return operand
  elseif operand == 4 then
    return self.a
  elseif operand == 5 then
    return self.b
  elseif operand == 6 then
    return self.c
  end
  return nil
end

function state.literal (self)
  local operand = self:operand()
  return operand
end

while not state.halted do
  local instruction = state:instruction()
  if instruction ~= nil then
    instruction(state)
    state:advance()
  else
    state.halted = true
  end
end

print("DONE")
print(state.a, state.b, state.c)

