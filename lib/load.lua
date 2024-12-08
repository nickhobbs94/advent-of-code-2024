Load = {}

local function parse(instring, pattern, opts)
  local codes = {}
  for s in instring:gmatch(pattern) do
    if opts.tonum then
      local n = tonumber(s)
      codes[#codes + 1] = n
    else
      codes[#codes + 1] = s
    end
  end
  return codes
end

function Load.load (filename, linepattern, opts)
  opts = opts or {}
  local input = io.open(filename, "r")
  local result = {}
  for line in input:lines() do
    result[#result + 1] = parse(line, linepattern, opts)
  end
  return result
end

return Load

