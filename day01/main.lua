input = io.open("realdata.txt", "r")

function parser (inputLine)
  local x,y = inputLine:match("(%d+)%s+(%d+)")
  return tonumber(x), tonumber(y)
end

minX, minX2 = nil, nil
minY, minY2 = nil, nil

for line in input:lines() do
  x,y = parser(line)
  if (not minX or x <= minX) then
    minX2 = minX
    minX = x
  elseif (not minX2 or x < minX2) then
    minX2 = x
  end

  if (not minY or y <= minY) then
    minY2 = minY
    minY = y
  elseif (not minY2 or y < minY2) then
    minY2 = y
  end
end

print(minX, minX2)
print(minY, minY2)

