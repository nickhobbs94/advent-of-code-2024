#!/usr/bin/env lua

filename = arg[1] or "testdata.txt"

debug = true

local lib = require"advent"
local fmt = lib.disp.fmtarr
local VecSet = lib.VecSet

local data = lib.load.load(filename, "(%d+)", {tonum=true})[1]

print(fmt(data))

function digits(n)
  local s = tostring(n)
  return #s
end

function split(n)
  local s = tostring(n)
  return tonumber(s:sub(1,#s/2)), tonumber(s:sub(#s/2 + 1,#s))
end

function blink(data)
  local result = {}
  for _,v in ipairs(data) do
    if v == 0 then
      result[#result + 1] = 1
    elseif digits(v) % 2 == 0 then
      local a,b = split(v)
      result[#result + 1] = a
      result[#result + 1] = b
    else
      result[#result + 1] = v * 2024
    end
  end
  return result
end

for i=1,25 do
  data = blink(data)

  --print(fmt(data))
end

print(#data)

