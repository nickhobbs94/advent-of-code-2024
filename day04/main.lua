#!/usr/bin/env lua
local re = require"re"
input = io.open(arg[1], "r")

function countXmas(s)
  _, countF = string.gsub(s, "XMAS", "")
  _, countB = string.gsub(s, "SAMX", "")
  return countF + countB
end

rdiags = {}
ldiags = {}
cols = {}
i = 1
lineLen = nil

total = 0
for line in input:lines() do
  lineLen = line:len()
  total = total + countXmas(line)

  for j=1,lineLen,1 do
    rdiags[i-j] = (rdiags[i-j] or "") .. line:sub(j,j)

    ldiags[i-j] = (ldiags[i-j] or "") .. line:sub(lineLen - j + 1, lineLen - j + 1)
    cols[j] = (cols[j] or "") .. line:sub(j,j)
  end
  i = i + 1
end

print(total)

for x=-lineLen,i,1 do
  total = total + countXmas(rdiags[x] or "")
  total = total + countXmas(ldiags[x] or "")
end

for x=1,lineLen,1 do
  total = total + countXmas(cols[x] or "")
end

print(total)

