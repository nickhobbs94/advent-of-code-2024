#!/usr/bin/env lua
input = io.open(arg[1], "r")

function sleep(n)
  os.execute("sleep " .. tonumber(n))
  os.execute("clear")
end

obstacles = {}
guard = {}
stomped = {}
start = {}

function k (x,y)
  return tostring(x) .. "," .. tostring(y)
end

function kstomped(state)
  return tostring(state.x) .. "," .. tostring(state.y) .. ":" .. tostring(state.dir[1]) .. "," .. tostring(state.dir[2])
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
    --print("HIT")
    guard.dir = turn(next.dir)
    return false
  end
  guard = next
  if stomped[kstomped(guard)] then
    -- looping!
    return true
  end
  stomped[kstomped(guard)] = true
  return false
end
  
function outmap(x,y)
  return x > width or x <= 0 or y > height or y <= 0
end

function printboard()
  for y=1, height do
    local s = ""
    for x=1,width do
      if obstacles[k(x,y)] then
        s = s .. "#"
      elseif guard.x == x and guard.y == y then
        s = s .. "*"
      elseif stomped[k(x,y)] then
        s = s .. "X"
      else
        s = s .. "."
      end
    end
    print(s)
  end
end

function runsim()
  looped = false
  stomped = {}
  stomped[kstomped(guard)] = true
  while not outmap(guard.x, guard.y) and not looped do
    looped = update()
    --print(kstomped(guard))

    local R = -1
    if (guard.x > width - R or guard.x < R or guard.y > height - R or guard.y < R) then
      sleep(1)
      printboard()
    end
  end
  return looped
end

start = {x=guard.x, y=guard.y, dir=guard.dir}
count = 0
for x=1,width do
  for y=1,height do
    print("sim", k(x,y))
    if not obstacles[k(x,y)] and not (guard.x == x and guard.y == y) then
      obstacles[k(x,y)] = true
      local foundloop = runsim()
      count = count + (foundloop and 1 or 0)
      obstacles[k(x,y)] = false
      guard = {x=start.x, y=start.y, dir=start.dir}
    end
  end
end
print(count)


