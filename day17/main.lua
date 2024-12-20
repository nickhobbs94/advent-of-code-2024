#!/usr/bin/env lua

local lib = require"advent"
local fmt = lib.disp.fmt2arr
local fmtarr = lib.disp.fmtarr
local VecSet = lib.VecSet

function adv (machine)
  local numerator = machine.a
  local denominator = math.pow(2,machine:combo())
  machine.a = math.floor(numerator / denominator)
end

function bxl (machine)
  local input = machine:literal()
  machine.b = machine.b ~ input
end

function bst (machine)
  local input = machine:combo()
  machine.b = input % 8
end

function jnz (machine)
  if machine.a > 0 then
    machine.iptr = machine:literal() - 2 + 1
  end
end

function bxc (machine)
  machine.b = machine.c ~ machine.b
end

function out (machine)
  machine.outputs[#machine.outputs + 1] = machine:combo() % 8
end

function bdv (machine)
  local numerator = machine.a
  local denominator = math.pow(2,machine:combo())
  machine.b = math.floor(numerator / denominator)
end

function cdv (machine)
  local numerator = machine.a
  local denominator = math.pow(2,machine:combo())
  machine.c = math.floor(numerator / denominator)
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
  a = 47792830,
  b = 0,
  c = 0,
  iptr = 1,
  program = {2,4,1,5,7,5,1,6,4,3,5,5,0,3,3,0},
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

function printState (machine)
  print("--------------------------------------------------")
  print("iter:", machine.iter)
  print("Register A:", machine.a)
  print("Register B:", machine.b)
  print("Register C:", machine.c)
  print("iptr:", machine.iptr)
  print("outs:", print(table.concat(machine.outputs, ",")))
  print("prog:", print(table.concat(machine.program, ",")))
  print("--------------------------------------------------")
end

function update (state)
  --printState(state)
  local instruction = state:instruction()
  if instruction ~= nil then
    instruction(state)
    state:advance()
  else
    state.halted = true
  end
end

local maxfound = 0
for i=1000000,100000000000 do
  state.a = i
  state.b = 0
  state.c = 0
  state.halted = false
  state.iptr = 1
  state.outputs = {}
  state.iter = i
  while not state.halted do
    update(state)
    if #state.outputs > 0 and state.outputs[#state.outputs] ~= state.program[#state.outputs] then
      if #state.outputs > maxfound then
        maxfound = #state.outputs
        printState(state)
      end
      state.halted = true
    elseif #state.outputs == #state.program then
      printState(state)
      return
    end
  end
end

print("DONE")
print(state.a, state.b, state.c)
print(table.concat(state.outputs, ","))

