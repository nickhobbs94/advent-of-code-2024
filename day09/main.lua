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

function getFile(blocks, id, after)
  local start = after or 1
  while blocks[start] ~= id and start <= #blocks do
    start = start + 1
  end

  if start > #blocks then
    return nil
  end

  local finish = start + 1
  while blocks[finish] == id do
    finish = finish + 1
  end
  return start, finish - 1
end

function moveRange(blocks, from, to, len)
  for i=0,len do
    blocks[to + i] = blocks[from + i]
    blocks[from + i] = -1
  end
end

function findblankspace(blocks, len)
  local after = 1
  local blankstart,blankfinish = getFile(blocks, -1, after)

  while blankstart ~= nil and blankfinish - blankstart < len do
    after = blankfinish + 1
    blankstart, blankfinish = getFile(blocks, -1, after)
  end
  return blankstart
end

function update(blocks, id)
  local start, finish = getFile(blocks, id)
  local empty = findblankspace(blocks, finish - start)
  if empty and empty < start then
    moveRange(blocks, start, empty, finish - start)
  end
  print(id, start, finish, empty)

  return blocks
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

function maxfileid(blocks)
  local max = -1
  for _,v in ipairs(blocks) do
    max = max < v and v or max
  end
  return max
end

printblocks(blocks)

fileid = maxfileid(blocks)

while fileid >= 0 do
  blocks, done = update(blocks, fileid)
  --printblocks(blocks)
  fileid = fileid - 1
end

function checksum(blocks)
  local c = 0
  for k,v in ipairs(blocks) do
    c = v<0 and c or ((k-1) * v + c)
  end
  return c
end

print(checksum(blocks))


