#!/usr/bin/env lua

filename = arg[1] or "testdata.txt"

debug = false

local lib = require"advent"
local fmt = lib.disp.fmt2arr
local VecSet = lib.VecSet

local data = lib.load.load(filename, "(.)", {tonum=false})

data = lib.stream.map(data, function (i,row)
  return lib.stream.map(row, function (j, e)
    return e == '.' and -1 or tonumber(e)
  end)
end)

print(fmt(data))
local width = #(data[1])
local height = #data

print(width, 'x', height)

function neighbours (x,y)
  return {{x-1,y},{x+1,y},{x,y-1},{x,y+1}}
end

function inbounds (x,y)
  if x <= 0 or y <= 0 then 
    return false
  elseif x > width or y > height then
    return false
  end
  return true
end

local trailheads = {}
for y=1,height do
  for x=1,width do
    if data[y][x] == 0 then
      trailheads[#trailheads + 1] = {x,y}
    end
  end
end

function copy (tab)
  local result = {}
  for k,v in ipairs(tab) do
    result[k] = v
  end
  return result
end

function countends (loc)
  local next = data[loc[2]][loc[1]] + 1
  local count = 0
  for _,n in ipairs(neighbours(loc[1], loc[2])) do
    if inbounds(n[1], n[2]) and data[n[2]][n[1]] == next then
      if next == 9 then
        count = count + 1
      else
        count = count + countends(n)
      end
    end
  end
  return count
end

total = 0
for _,s in ipairs(trailheads) do
  local rating = countends(s)
  print(rating)
  total = total + rating
end

print(total)



