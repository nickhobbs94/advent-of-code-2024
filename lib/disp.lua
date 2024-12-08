Disp = {}

function Disp.print2d (data)
  for k,v in pairs(data) do
    for j,x in pairs(v) do
      print(k,j,x)
    end
  end
end

function Disp.printtab (data)
  for k,v in pairs(data) do
    print(k, v)
  end
end

function Disp.fmt2arr (arr2)
  local s = "{"
  for _, arr in ipairs(arr2) do
    s = s .. Disp.fmtarr(arr) .. ","
  end
  s = s .. "}"
  return s
end

function Disp.fmtarr (arr)
  local s = "{"
  for _,e in ipairs(arr) do
    s = s .. e .. ","
  end
  s = s .. "}"
  return s
end

return Disp 

