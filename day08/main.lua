#!/usr/bin/env lua

filename = arg[1] or "testdata.txt"

local lib = require"advent"
local load = lib.load.load
local disp = lib.disp
local fmt2arr = lib.disp.fmt2arr
local map = lib.stream.map

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

VecSet = {}

function VecSet:new ()
  set = {}
  setmetatable(set, self)
  self.__index = self
  return set
end

function VecSet.key (set, vec)
  return tostring(vec[1]) .. "," .. tostring(vec[2])
end

function VecSet.add (set, vec)
  set[set:key(vec)] = true
end

function VecSet.contains (set, vec)
  return set[set:key(vec)]
end

function VecSet.count (set)
  local count = 0
  for k,v in pairs(set) do
    if v then
      count = count + 1
    end
  end
  return count
end

function calcAnti (vec1, vec2)
  delta = {vec2[1] - vec1[1], vec2[2] - vec1[2]}
  return {vec1[1] - delta[1], vec1[2] - delta[2]}, {vec2[1] + delta[1], vec2[2] + delta[2]}
end


function inbounds(vec)
  return vec[1] > 0 and vec[1] <= width and vec[2] > 0 and vec[2] <= height
end

function computeAllAntinodes (antennas)
  local antinodes = VecSet:new()
  for k,ants in pairs(antennas) do
    for i=1,#ants do
      for j=i+1,#ants do
        local an1, an2 = calcAnti(ants[i], ants[j])
        if inbounds(an1) then
          antinodes:add(an1)
        else
          print("OOB an1", disp.fmtarr(an1), width, height)
        end
        if inbounds(an2) then
          antinodes:add(an2)
        else
          print("OOB an2", disp.fmtarr(an2), width, height)
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


