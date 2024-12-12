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
  return {perim=0, area=0, plant=plantletter}
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
  print("setneighbours", x, y, region.plant)
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

    if plant == 'C' then
      print(region.area)
    end

    for _,neighbour in ipairs(neighbours(x,y)) do
      if isplant(neighbour[1], neighbour[2], plant) then
      else
        region.perim = region.perim + 1
      end
    end
  end
end

price = 0
for k,v in ipairs(allregions) do
  price = price + v.area * v.perim
  print(k, v.perim, v.area, v.plant)
end

print(price)

