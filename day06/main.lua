#!/usr/bin/env lua
input = io.open(arg[1], "r")

obstacles = {}
guard = {}
stomped = {}

function k (x,y)
  return tostring(x) .. "," .. tostring(y)
end

width = nil
y = 0
for line in input:lines() do
  width = width or #line
  y = y + 1
  for x=1,#line do
    local spot = (line:sub(x,x))
    if spot == '#' then
      obstacles[k(x,y)] = true
    elseif spot == '^' then
      guard.x = x
      guard.y = y
      guard.dir = {0,-1}
    end
  end
end
height = y

function turn(dir)
  local x = dir[1]
  local y = dir[2]
  if x == 0 and y == -1 then
    return {1,0}
  elseif x==1 and y==0 then
    return {0,1}
  elseif x==0 and y==1 then
    return {-1,0}
  elseif x==-1 and y==0 then
    return {0,-1}
  end
end

function update()
  next = {x=guard.x, y=guard.y, dir=guard.dir}
  next.x = next.x + guard.dir[1]
  next.y = next.y + guard.dir[2]
  if obstacles[k(next.x, next.y)] then
    print("HIT")
    guard.dir = turn(next.dir)
    return
  end
  guard = next
  stomped[k(guard.x, guard.y)] = true
end
  
function outmap(x,y)
  return x > width or x <= 0 or y > height or y <= 0
end

while not outmap(guard.x, guard.y) do
  update()
  print(k(guard.x, guard.y))
end

count = 0
for x=1,width do
  for y=1,height do
    if stomped[k(x,y)] then
      count = count + 1
    end
  end
end
print(count)


