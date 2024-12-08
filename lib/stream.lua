Stream = {}

function Stream.map (arr, fn)
  local newarr = {}
  for i,k in iparis(arr) do
    newarr[i] = fn(i,k)
  end
end

function Stream.reduce (arr, fn, initial)
  local acc = initial
  for i,k in iparis(arr) do
    acc = fn(acc, i, k)
  end
end

return Stream
