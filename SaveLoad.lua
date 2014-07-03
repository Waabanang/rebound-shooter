function tableSave(tbl,filename)
  local file = io.open(filename, "wb")
  file:write("enemiesSpawn = {}\n")
  for i,v in ipairs(tbl) do
    file:write("enemiesSpawn["..exportStringS(i).."] = {")
    for ke,ve in pairs(tbl[i]) do
      if exportStringS(ke) ~= "typeE" then
        file:write(""..exportStringS(ke).." = "..exportStringS(ve)..", ")
      end
    end
    file:write("typeE  = "..exportStringQ(tbl[i].typeE).."}\n")
  end
  file:close()
end
function tableLoad(filename)
  local function dofile(filename)
    local f = assert(loadfile(filename))
    return f()
  end
  enemiesSpawn = {}
  dofile(filename)
end
function exportStringS(s)
  return string.format("%s", s)
end
function exportStringQ(s)
  return string.format("%q", s)
end