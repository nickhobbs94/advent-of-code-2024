local re = require"re"

allrules = {}
queues = {}

function parserule(s)
  local x,y = s:match("(%d+)|(%d+)")
  return {b=tonumber(x), a=tonumber(y)}
end

function midp(q) 
  return q[math.floor(#q / 2) + 1]
end

function parsequeue(row)
  local q = {}
  for s in row:gmatch("%d+") do
    local n = tonumber(s)
    q[#q + 1] = n
  end
  return q
end

function valid(q, rules)
  for _,r in ipairs(rules) do
    if index(q, r.a) and index(q, r.b) then
      if index(q, r.a) < index(q,r.b) then
        return false, r
      end
    end
  end
  return true
end

-- load rules
f = "real1.txt"
input = io.open(f, "r")
for line in input:lines() do
  allrules[#allrules + 1] = parserule(line)
end

function insert(arr, e, i)
  local new = {}
  for k,v in ipairs(arr) do
    if k < i then
      new[k] = v
    elseif k == i then
      new[k] = e
      new[k+1] = v
    else
      new[k + 1] = v
    end
  end
  if i > #arr then
    new[i] = e
  end
  return new
end

function remove(arr, i)
  local new = {}
  local e = nil
  for k,v in ipairs(arr) do
    if k == i then
      e = v
    else
      new[#new + 1] = v
    end
  end
  return new, e
end

function printr(r)
  local s = ""
  if not r then
    return s
  end
  for k,v in ipairs(r) do
    s = s .. v .. ", "
  end
  return s
end

function index(arr, e)
  for k,v in ipairs(arr) do
    if v == e then
      return k
    end
  end
  return nil
end

function fixrule(new, r, rules)
  print("fixrule", r.b, r.a)
  new = remove(new, index(new,r.b))
  new = remove(new, index(new,r.a))
  for i=1,#new+1,1 do
    print("lstart", printr(new))
    new = insert(new, r.b, i)
    for j=i+1,#new+1,1 do
      print("inserting", r.a, j, printr(new))
      new = insert(new, r.a, j)
      print("loop", i,j, printr(new))
      if valid(new, rules) then
        printr("valid", printr(new))
        return new
      end
      new = remove(new, index(new,r.a))
    end
    print("try again")
    new = remove(new, index(new,r.b))
  end
  print("uh oh")
end

function reorder(q, rules)
  local new = q
  local fixedrules = {}
  print("reorder", printr(new))
  while not valid(new, rules) do
    local _, r = valid(new, rules)
    print("fixrule", r.b, "before", r.a)
    fixedrules[#fixedrules + 1] = r
    new = fixrule(new, r, fixedrules)
    print("fixed", printr(new))
  end
  return new
end
  

-- load queues
f = "real2.txt"
input = io.open(f, "r")

total = 0

for line in input:lines() do
  local q = parsequeue(line)
  queues[#queues + 1] = q
  if valid(q, allrules) then
    --total = total + midp(q)
  else
    q = reorder(q, allrules)
    total = total + midp(q)
  end
end

print(total)

