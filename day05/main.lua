local re = require"re"

d1 = "real1.txt"
d2 = "real2.txt"

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
input = io.open(d1, "r")
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

function prints(set)
  local s = "{"
  for k,v in pairs(set or {}) do
    if v then
      s = s .. " " .. k
    end
  end
  s = s .. " }"
  return s
end


-- lookup what a number must be before
ruletree = {}

for _,r in ipairs(allrules) do
  beforeNode = ruletree[r.b] or {before = {}, after = {}}
  afterNode = ruletree[r.a] or {before = {}, after = {}}
  beforeNode.before[r.a] = true
  afterNode.after[r.b] = true
  ruletree[r.b] = beforeNode
  ruletree[r.a] = afterNode
end

function validInsert(arr, num, index, beforeNums, afterNums)
  for k,v in ipairs(arr) do
    if k < index then
      if afterNums[v] then
        return false
      end
    else
      if beforeNums[v] then
        return false
      end
    end
  end
  return true
end

function reorder(q, rules)
  local new = {}
  for _,v in ipairs(q) do
    local node = ruletree[v]
    local bf = node and node.before or {}
    local af = node and node.after or {}
    local inserted = false
    for i=1,#new+1,1 do
      if not inserted and validInsert(new, v,i,bf,af) then
        new = insert(new, v, i)
        inserted = true
      end
    end
  end
  print(printr(new))
  return new
end

-- load queues
input = io.open(d2, "r")

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

