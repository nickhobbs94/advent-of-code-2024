#!/usr/bin/env lua

filename = arg[1] or "day08/testdata.txt"

local lib = require"advent"
local load = lib.load.load
local disp = lib.disp
local fmt2arr = lib.disp.fmt2arr
local VecSet = lib.VecSet

local data = load(filename, "(.)")
local width = #(data[1])
local height = #data

function printmap(mapdata)
  for _,y in ipairs(mapdata) do
    local s=""
    for _,x in ipairs(y) do
      s = s .. x
    end
    print(s)
  end
end

function getantennas(mapdata)
  local antennas = {}
  for y,row in ipairs(mapdata) do
    for x,value in ipairs(row) do
      if value ~= "." then
        local coords = antennas[value] or {}
        coords[#coords + 1] = {x,y}
        antennas[value] = coords
      end
    end
  end
  return antennas
end

printmap(data)
local antennas = getantennas(data)

for k,v in pairs(antennas) do
  print(k, disp.fmt2arr(v))
end

function inbounds(vec)
  return vec[1] > 0 and vec[1] <= width and vec[2] > 0 and vec[2] <= height
end

function calcAnti (vec1, vec2)
  local delta = {vec2[1] - vec1[1], vec2[2] - vec1[2]}
  local antis = {{vec1[1], vec1[2]}}

  local current = {vec1[1], vec1[2]}
  while inbounds(current) do
    current = {current[1] - delta[1], current[2] - delta[2]}
    antis[#antis + 1] = current
  end

  local current = {vec1[1], vec1[2]}
  while inbounds(current) do
    current = {current[1] + delta[1], current[2] + delta[2]}
    antis[#antis + 1] = current
  end

  return antis
end



function computeAllAntinodes (antennas)
  local antinodes = VecSet:new()
  for k,ants in pairs(antennas) do
    for i=1,#ants do
      for j=i+1,#ants do
        local antis = calcAnti(ants[i], ants[j])
        for _,an in ipairs(antis) do
          if inbounds(an) then
            antinodes:add(an)
          end
        end
      end
    end
  end
  return antinodes
end

local antinodes = computeAllAntinodes(antennas)

for k,v in pairs(antinodes) do
  print(k,v)
end

for y=1,height do
  local s = ""
  for x=1,width do
    if antinodes:contains({x,y}) then
      s = s .. "#"
    else
      s = s .. "."
    end
  end
  print(s)
end

print(antinodes:count())


