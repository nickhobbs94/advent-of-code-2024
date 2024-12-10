VecSet = {}

function VecSet:new ()
  local set = {}
  setmetatable(set, self)
  self.__index = self
  return set
end

function VecSet.key (set, vec)
  return tostring(vec[1]) .. "," .. tostring(vec[2])
end

function inverse_key (k)
  local x,y = k:match("(%d+),(%d+)")
  return {tonumber(x), tonumber(y)}
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

function VecSet.iter (set)
  local truekeys = {}
  for k,v in pairs(set) do
    if v then
      truekeys[#truekeys + 1] = k
    end
  end

  local i = 0
  return function()
    i = i + 1
    if i <= #truekeys then
      return inverse_key(truekeys[i])
    end
  end
end

VecSet["__tostring"] = function (self)
  local s = ""
  for k,v in pairs(self) do
    if v then
      s = s .. "{" .. k .. "},"
    end
  end
  return s
end

return VecSet

