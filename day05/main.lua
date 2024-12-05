local re = require"re"

rules = {}
queues = {}

function parserule(s)
  local x,y = s:match("(%d+)|(%d+)")
  return {b=tonumber(x), a=tonumber(y)}
end

function midp(q) 
  return q[math.floor(#q / 2) + 1]
end

function parsequeue(row)
  local q = {nums = {}}
  for s in row:gmatch("%d+") do
    local n = tonumber(s)
    q.nums[n] = #q + 1
    q[#q + 1] = n
  end
  return q
end

function valid(q, rules)
  for _,r in ipairs(rules) do
    if q.nums[r.a] and q.nums[r.b] then
      if q.nums[r.a] < q.nums[r.b] then
        print(q[1], r.a, r.b)
        return false
      end
    end
  end
  return true
end

-- load rules
f = "test1.txt"
input = io.open(f, "r")
for line in input:lines() do
  rules[#rules + 1] = parserule(line)
end

-- load queues
f = "test2.txt"
input = io.open(f, "r")

total = 0

for line in input:lines() do
  q = parsequeue(line)
  queues[#queues + 1] = q
  if valid(q, rules) then
    total = total + midp(q)
  end
end

print(total)

