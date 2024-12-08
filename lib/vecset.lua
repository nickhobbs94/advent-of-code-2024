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

return VecSet

