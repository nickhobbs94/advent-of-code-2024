#!/usr/bin/env lua

filename = arg[1] or "testdata.txt"

function parse(s)
  local x,y = s:match("(%d+): (.*)")
  local codes = {}
  for s in y:gmatch("%d+") do
    local n = tonumber(s)
    codes[#codes + 1] = n
  end
  return {ans=tonumber(x), ins=codes}
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
  os.execute("clear")
end

function fmt(arr)
  local s = ""
  for k,v in ipairs(arr) do
    s = s..tostring(v)..","
  end
  return s
end

function add(a,b) return a+b end
function mul(a,b) return a*b end
function concat(a,b)
  astr = tostring(a)
  bstr = tostring(b)
  return tonumber(a..b)
end

ops = {}
ops["+"] = add
ops["*"] = mul
ops["||"] = concat

function check(equation, operations)
  total = 0
  for i=1,#equation.ins,1 do
    total = ops[operations[i]](total, equation.ins[i])
  end
  return total == equation.ans
end

function loadops(equation)
  local ops = {"+"}
  for i=2,#equation.ins do
    ops[#ops + 1] = "+"
  end
  return ops
end

function incrementops(ops)
  local done = false
  local finished = false
  local i = #ops
  -- + * * +
  -- + * * *
  --
  -- + + * *
  -- + * + +
  --
  -- + + * + *
  -- + + * * +
  -- + + * * *
  while not done do
    if i == 1 then
      done = true
      finished = true
    elseif ops[i] == "+" then
      ops[i] = "||"
      done = true
    elseif ops[i] == "||" then
      ops[i] = "*"
      done = true
    elseif ops[i] == "*" then
      ops[i] = "+"
      i = i - 1
    end
  end
  return finished, ops
end
      

found = 0
function load()
  local input = io.open(filename, "r")
  for line in input:lines() do
    print(line)
    local a = parse(line)
    local loopend = false
    local ops = loadops(a)
    local matches = false
    while not loopend do
      print("checking", fmt(ops))
      if check(a, ops) then
        print("found", fmt(ops), a.ans)
        matches = true
        -- found = found + a.ans
      end
      loopend, ops = incrementops(ops)
    end
    if matches then
      found = found + a.ans
    end
  end
end


map = load()
print(found)



