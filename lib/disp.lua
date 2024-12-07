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

return Disp 

