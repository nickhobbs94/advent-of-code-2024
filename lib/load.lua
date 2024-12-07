Load = {}

local function parse(instring, pattern)
  local codes = {}
  for s in instring:gmatch(pattern) do
    local n = tonumber(s)
    codes[#codes + 1] = n
  end
  return codes
end

function Load.load (filename, linepattern, opts)
  local input = io.open(filename, "r")
  local result = {}
  for line in input:lines() do
    result[#result + 1] = parse(line, linepattern, opts)
  end
  return result
end

return Load

