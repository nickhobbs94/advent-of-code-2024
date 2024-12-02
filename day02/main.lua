#!/usr/bin/env lua
input = io.open(arg[1], "r")

directions = {"up", "down"}

function setDir (currentDirection, prevN, nextN)
  if (currentDirection ~= nil) then
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

for line in input:lines() do
  local prev = nil
  local prev2 = nil
  local dir = nil
  local dir2 = nil
  local safe = true
  local safe2 = true

  for s in line:gmatch("%d+") do
    local n = tonumber(s)
    if (prev ~= nil) then 
      dir = setDir(dir, prev, n)
      if (prev < n and dir == "down") then safe = false end
      if (prev > n and dir == "up") then safe = false end
      
      local delta = math.abs(n - prev)
      if (delta == 0 or delta > 3) then safe = false end
    end

    prev2 = prev
    prev = n
  end

  --print(safe and "safe" or "unsafe")
  if (safe) then
    safecount = safecount + 1
  else
    unsafecount = unsafecount + 1
  end
end

print(safecount)
print(unsafecount)
