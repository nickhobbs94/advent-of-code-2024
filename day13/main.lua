#!/usr/bin/env lua

local filename = arg[1] or "testdata.txt"

local lib = require"advent"
local fmt = lib.disp.fmt2arr
local fmtarr = lib.disp.fmtarr
local VecSet = lib.VecSet

function parser (inputLine, pattern)
  local x,y = inputLine:match(pattern)
  return tonumber(x), tonumber(y)
end

local input = io.open(filename, "r")

local line = input:lines()

function isint (n) return n == math.floor(n) end

cost = 0
done = false
while not done do
  buttonA = line()
  buttonB = line()
  prize = line()
  _ = line()
  if buttonA == nil then
    done = true
    x=string.format("Final cost: %d",cost)
    print(x)
    return
  end
  print(buttonA, buttonB, prize)
  aX,aY = parser(buttonA, "Button A: X%+(%d+), Y%+(%d+)")
  bX,bY = parser(buttonB, "Button B: X%+(%d+), Y%+(%d+)")
  pX,pY = parser(prize, "Prize: X=(%d+), Y=(%d+)")
  print(aX,aY,bX,bY,pX,pY)

  -- add 10000000000000 for part 2
  pX = pX + 10000000000000
  pY = pY + 10000000000000

  -- pX = aX * nA + bX * nB
  -- pY = aY * nA + bY * nB
  -- nA,nB are positive integers
  --
  -- ( aX bX ) (nA)  =  (pX)
  -- ( aY bY ) (nB)     (pY)
  --
  -- determinant must be nonzero to be invertible (in the reals)
  local determinant = aX * bY - bX * aY
  print("det", determinant)
  if determinant ~= 0 then
    nA = (bY * pX - bX * pY) / determinant
    nB = (-aY * pX + aX * pY) / determinant

    if isint(nA) and isint(nB) then
      local costdelta = 3*nA + nB
      print("costdelta", costdelta)
      cost = cost + costdelta
    else
      print(nA, nB, "not ints")
    end
  end
end

