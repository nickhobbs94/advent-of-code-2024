#!/usr/bin/env lua
local re = require"re"
input = io.open(arg[1], "r")

function findAll(results, s, search, height)
  local lastfound = nil
  while true do
    local found, next = s:find(search, lastfound)
    if found == nil then
      return results
    else
      results[#results + 1] = {x = found + 1, y = height}
      lastfound = next
    end
  end
end

rdiags = {}
ldiags = {}
i = 1
lineLen = nil

total = 0
for line in input:lines() do
  lineLen = line:len()

  for j=1,lineLen,1 do
    rdiags[i-j] = (rdiags[i-j] or "") .. line:sub(j,j)
    ldiags[i-j] = (ldiags[i-j] or "") .. line:sub(lineLen - j + 1, lineLen - j + 1)
  end
  i = i + 1
end

r = {}
l = {}
for y=-lineLen,i,1 do
  print(rdiags[y], ldiags[y])
  r = findAll(r, rdiags[y] or "", "SAM",y)
  r = findAll(r, rdiags[y] or "", "MAS",y)
  l = findAll(l, ldiags[y] or "", "SAM",y)
  l = findAll(l, ldiags[y] or "", "MAS",y)
end

poi = {}
for _, v in pairs(r) do
  local x = v.x - 1
  local y = v.y + v.x - 1
  if v.y < 0 then
    x = v.x - v.y - 1
    y = v.x - 1
  end
  print(v.x,v.y,"=>",x,y)
  poi[tostring(x)..","..tostring(y)] = true
end

print("---")

for _, v in pairs(l) do
  local x = lineLen - v.x
  local y = v.y + v.x - 1
  if v.y < 0 then
    x = lineLen + v.y - v.x
    y = v.x - 1
  end
  print(v.x,v.y,"=>",x,y)
  if poi[tostring(x)..","..tostring(y)] then
    print("found", x,y)
    total = total + 1
  end
end


print(total)

