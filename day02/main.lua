#!/usr/bin/env lua
input = io.open(arg[1], "r")

directions = {"up", "down"}

function setDir (currentDirection, prevN, nextN)
  if (currentDirection ~= nil or prevN == nil) then
    return currentDirection
  end

  if (prevN < nextN) then
    return "up"
  end

  if (prevN > nextN) then return "down" end

  return currentDirection
end

safecount = 0
unsafecount = 0

function valid(dir, prev, curr)
  if (prev == nil) then return true end
  if (dir == "up" and prev > curr) then return false end
  if (dir == "down" and prev < curr) then return false end
  local delta = math.abs(prev - curr)
  if (delta == 0 or delta > 3) then return false end
  return true
end

function skipEntry(tbl, skipI)
  local result = {}
  for i = 1, #tbl, 1 do
    if (i ~= skipI) then
      result[#result + 1] = tbl[i]
    end
  end
  return result
end

function printRow(row)
  local result = ""
  for i = 1, #row, 1 do
    result = result .. tostring(row[i]) .. " "
  end
  return result
end

function safe(row)
  local prev = nil
  local dir = nil
  local isSafe = true

  for i = 1, #row, 1 do
    local n = row[i]
    dir = setDir(dir, prev, n)
    if (not valid(dir, prev, n)) then
      isSafe = false
    end
    prev = n
  end

  print(printRow(row), isSafe)
  return isSafe
end


for line in input:lines() do

  local codes = {}
  for s in line:gmatch("%d+") do
    local n = tonumber(s)
    codes[#codes + 1] = n
  end

  local good = safe(codes)

  if (not good) then
    for i=1, #codes, 1 do
      good = good or safe(skipEntry(codes, i))
    end
  end

  print(good and "safe" or "unsafe")
  if (good) then
    safecount = safecount + 1
  else
    unsafecount = unsafecount + 1
  end
end

print(safecount)
print(unsafecount)
