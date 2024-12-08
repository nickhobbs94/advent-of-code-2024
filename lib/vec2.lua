Vec2 = {}

function Vec2:new (x, y)
  local vec = {x, y}
  setmetatable(vec, self)
  self.__index = self
  return vec
end

Vec2["__tostring"] = function (self)
  return "< " .. tostring(self[1]) .. "," .. tostring(self[2]) .. " >"
end

Vec2["__add"] = function(a,b)
  local x = a[1] + b[1]
  local y = a[2] + b[2]
  return Vec2:new(x,y)
end

Vec2["__sub"] = function(a,b)
  local x = a[1] - b[1]
  local y = a[2] - b[2]
  return Vec2:new(x,y)
end

Vec2["__eq"] = function(a,b)
  return a[1] == b[1] and a[2] == b[2]
end

function Vec2:transform (matrix)
  local x = matrix[1] * self[1] + matrix[2] * self[2]
  local y = matrix[3] * self[1] + matrix[4] * self[2]
  return Vec2:new(x,y)
end

return Vec2

