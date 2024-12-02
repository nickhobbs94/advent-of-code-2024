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

function valid(dir, prev, curr)
  if (dir == "up" and prev > curr) then return false end
  if (dir == "down" and prev < curr) then return false end
  local delta = math.abs(prev - curr)
  if (delta == 0 or delta > 3) then return false end
  return true
end

for line in input:lines() do
  local prev = nil
  local prev2 = nil
  local dir = nil
  local safe = true
  local skipped = false

  for s in line:gmatch("%d+") do
    local n = tonumber(s)

    if (prev2) then
      local dir2 = setDir(dir, prev2, n)
      dir = setDir(dir, prev2, prev)
      dir = setDir(dir, prev, n)

      -- prev2 -> prev
      local goodPrev = valid(dir, prev2, prev)
      -- prev -> n
      local good = valid(dir, prev, n)
      -- or
      -- prev2 -> n
      local goodSkip = valid(dir2, prev2, n)

      if (not good) then
        -- - 1 0
        if (not skipped and goodPrev) then
          skipped = true
          prev = 
        else
          safe = false
        end
      end

    end

    prev2 = prev
    prev = n
  end

  if (not prev2) then print("NOT ENOUGH") end

  --print(safe and "safe" or "unsafe")
  if (safe) then
    safecount = safecount + 1
  else
    unsafecount = unsafecount + 1
  end
end

print(safecount)
print(unsafecount)
