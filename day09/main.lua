#!/usr/bin/env lua

filename = arg[1] or "testdata.txt"

local lib = require"advent"
local fmtarr = lib.disp.fmtarr

local data = lib.load.load(filename, "(.)", {tonum=true})[1]
-- local data = {1,2,3,4,5}

function processmap(mapping)
  local s = {}
  local blank = false
  local id = 0
  for _,n in ipairs(mapping) do
    if blank then
      for count=1,n do
        s[#s + 1] = -1
      end
      blank = false
    else
      for count=1,n do
        s[#s + 1] = id
      end
      blank = true
      id = id + 1
    end
  end
  return s
end

function update(blocks)
  local firstblank = 1
  while blocks[firstblank] >= 0 and firstblank <= #blocks do
    firstblank = firstblank + 1
  end

  if firstblank > #blocks then
    return blocks, true
  end

  local lastnum = #blocks
  while blocks[lastnum] < 0 and lastnum > 0 do
    lastnum = lastnum - 1
  end

  if lastnum == 0 then
    print("UM!")
    return blocks, true
  end

  if firstblank > lastnum then
    -- all done!
    return blocks, true
  end

  blocks[firstblank] = blocks[lastnum]
  blocks[lastnum] = -1
  return blocks, false
end

function printblocks(blocks)
  s = ''
  for _,v in ipairs(blocks) do
    if v < 0 then
      s = s .. '.'
    else
      s = s .. tostring(v)
    end
  end
  print(s)
end

blocks = processmap(data)

print(fmtarr(blocks))

printblocks(blocks)
blocks, done = update(blocks)
printblocks(blocks)

while not done do
  blocks, done = update(blocks)
  --printblocks(blocks)
end

function checksum(blocks)
  local c = 0
  for k,v in ipairs(blocks) do
    c = v<0 and c or ((k-1) * v + c)
  end
  return c
end

print(checksum(blocks))


