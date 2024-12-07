Sleep = {}

function Sleep.sleep(n)
  os.execute("sleep " .. tonumber(n))
end

return Sleep

