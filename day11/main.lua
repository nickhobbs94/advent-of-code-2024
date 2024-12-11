#!/usr/bin/env lua

local filename = arg[1] or "testdata.txt"

local debug = true


local lib = require"advent"
local fmt = lib.disp.fmt2arr
local VecSet = lib.VecSet

local data = {}
local rawdata = lib.load.load(filename, "(%d+)", {tonum=true})[1]

for _,v in ipairs(rawdata) do
  data[v] = (data[v] or 0) + 1
end


function pr()
  local s = ""
  for k,v in pairs(data) do
    s = s .. tostring(k) .. ":" .. tostring(v) .. ","
  end
  print(s)
end

pr()

function digits(n)
  local s = tostring(n)
  return #s
end

function split(n)
  local s = tostring(n)
  return tonumber(s:sub(1,#s/2)), tonumber(s:sub(#s/2 + 1,#s))
end

function mutate(v)
  local result = {}
  if v == 0 then
    result[#result + 1] = 1
  elseif digits(v) % 2 == 0 then
    local a,b = split(v)
    result[#result + 1] = a
    result[#result + 1] = b
  else
    result[#result + 1] = v * 2024
  end
  return result
end

function blink()
  local result = {}
  for k,v in pairs(data) do
    for _,k_star in ipairs(mutate(k)) do
      result[k_star] = (result[k_star] or 0) + v
    end
  end
  return result
end

for i=1,75 do
  data = blink()
end

local sum = 0
for k,v in pairs(data) do
  sum = sum + v
end
print(sum)



