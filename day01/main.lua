#!/usr/bin/env lua
input = io.open(arg[1], "r")

function parser (inputLine)
  local x,y = inputLine:match("(%d+)%s+(%d+)")
  return tonumber(x), tonumber(y)
end

X = {}
Y = {}

for line in input:lines() do
  local x,y = parser(line)
  X[#X + 1] = x
  Y[y] = (Y[y] or 0) + 1
end

score = 0

for _, x in pairs(X) do
  local y = Y[x] or 0
  score = score + y * x
end

print(score)

