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
  Y[#Y + 1] = y
end

table.sort(X)
table.sort(Y)

distance = 0

for i in pairs(X) do
  local x = X[i]
  local y = Y[i]
  distance = distance + math.abs(x-y)
end

print(distance)

