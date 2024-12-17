#!/usr/bin/env lua

local filename = arg[1] or "testdata.txt"

local lib = require"advent"
local fmt = lib.disp.fmt2arr
local fmtarr = lib.disp.fmtarr
local VecSet = lib.VecSet

local data = lib.load.load(filename, "(.)", {tonum=false})

local regions = {}

local width = #(data[1])
local height = #data

function neighbours (x,y)
  return {{x-1,y},{x+1,y},{x,y-1},{x,y+1}}
end

function inbounds (x,y)
  if x <= 0 or y <= 0 then 
    return false
  elseif x > width or y > height then
    return false
  end
  return true
end

function isplant(x,y,plantname)
  if not inbounds(x,y) then
    return false
  end

  return data[y][x] == plantname
end

local regionmap = {}
function defaultregion(plantletter)
  print("New region", plantletter)
  return {perim=0, area=0, plant=plantletter, sides=-4}
end

function lookup(x,y)
  local key = tostring(x)..','..tostring(y)
  local found = regionmap[key]
  return found
end

function store(x,y, region)
  local key = tostring(x)..','..tostring(y)
  regionmap[key] = region
end

local allregions = {}

function setneighbours(x,y,region)
  --print("setneighbours", region.plant, x, y)
  for _,n in ipairs(neighbours(x,y)) do
    if isplant(n[1], n[2], region.plant) then
      if lookup(n[1], n[2]) == nil then
        store(n[1], n[2], region)
        setneighbours(n[1], n[2], region)
      end
    end
  end
end

function findregion(x,y,letter)
  local region = nil
  for _,n in ipairs(neighbours(x,y)) do
    if isplant(n[1], n[2], letter) then
      local found = lookup(n[1], n[2])
      if found then
        region = found
      end
    end
  end

  if not region then
    region = defaultregion(letter)
    store(x,y,region)
    setneighbours(x,y,region)
    allregions[#allregions + 1] = region
  end

  return region
end


for y=1,height do
  for x=1,width do
    local plant = data[y][x]
    local region = findregion(x,y,plant)
    region.area = region.area + 1

    local neebs = {}
    neebs["-1,0"] = false -- left
    neebs["1,0"] = false -- right
    neebs["0,-1"] = false -- up
    neebs["0,1"] = false -- down

    local count = 0
    for _,neighbour in ipairs(neighbours(x,y)) do
      if isplant(neighbour[1], neighbour[2], plant) then
        count = count + 1
        local delta = {neighbour[1]-x, neighbour[2]-y}
        local k = tostring(delta[1])..','..tostring(delta[2])
        neebs[k] = true
      else
        region.perim = region.perim + 1
      end
    end

     local dirs = {
       left = neebs["-1,0"],
       right = neebs["1,0"],
       up = neebs["0,-1"],
       down = neebs["0,1"],
     }
    --
    -- local count = (left and 1 or 0)
    --   + (right and 1 or 0)
    --   + (up and 1 or 0)
    --   + (down and 1 or 0)

    if count == 0 then
      region.sides = 4
      print("lone", region.plant)
    elseif count == 1 then
      region.sides = region.sides + 4
      print("end", region.plant)
    elseif count == 2 then
      if (dirs.up and dirs.down) or (dirs.left and dirs.right) then
      else
        print("bend", region.plant, region.sides)
        region.sides = region.sides + 2
      end
    end
  end
end

print("SUM")
price = 0
for k,v in ipairs(allregions) do
  price = price + v.area * v.sides
  --print("price", v.plant, v.area * v.sides)
  print("sides", v.plant, v.sides)
end

print(price)

