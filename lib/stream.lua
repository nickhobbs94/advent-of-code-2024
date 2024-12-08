Stream = {}

function Stream.map (arr, fn)
  local newarr = {}
  for i,k in ipairs(arr) do
    newarr[i] = fn(i,k)
  end
end

function Stream.reduce (arr, fn, initial)
  local acc = initial
  for i,k in ipairs(arr) do
    acc = fn(acc, i, k)
  end
end

return Stream
