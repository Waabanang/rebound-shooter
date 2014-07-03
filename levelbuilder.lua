EN = require "enemies"
function loadBuilder()
  enemiesCreate = {}
  enemiesCreate.t = 0
  enemiesCreate.TypeE = "square"
  enemiesCreate.c = true
  if not love.filesystem.exists("testlevel.lua") then
    love.filesystem.newFile("testlevel.lua")
    love.filesystems.write("testlevel.lua", "{}")
  end
  enemiesSpawn = love.filesystem.load("testlevel.lua")
  timeChange = "pause"
  cTime = love.timer.getTime()
  love.mouse.setVisible(false)
end
function updateBuilder(dt)
  collider:update(dt)
  local cx, cy = love.mouse.getPosition()
  if checkClass() == "class 1" then
    enemiesCreate.y = 10
    if cx >= 50 and cx <= 850 then
      enemiesCreate.x = cx
    elseif cx < 50 then
      enemiesCreate.x = 50
    elseif cy > 850 then
      enemiesCreate.x = 820
    end
    if enemiesCreate.typeE == "square" then
      enemiesCreate.shape = collider:addRectangle(enemiesCreate.x, enemiesCreate.y, 30, 30)
    elseif enemiesCreate.typeE == "mine" then
      enemiesCreate.shape = collider:addCircle(x, y, 10)
    elseif enemiesCreate.typeE == "mach" then
      enemiesCreate.shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30)
    end
  end
  if timeChange == "forward" then
    cTime = cTime + dt
    updateEnemies()
  end
  if timeChange == "backward" then
    cTime = cTime - dt
    for i,v in ipairs(enemiesSpawn) do
      if v.c == false and v.t >= cTime then
        v.c = true
      end
    end
  end
  for k,v in pairs(enemiesSpawn) do
    if v.c and cTime >= v.t then
      if v.typeE == "square" then
        spawnEnemySquare(v.x, v.y)
      elseif v.typeE == "mine" then
        spawnEnemyMine(v.x, v.y)
      elseif v.typeE == "mach" then
        spawnEnemyMach(v.x)
      end
      v.c = false
    end 
  end
end
function checkClass()
  if enemiesCreate.typeE == "square" or enemiesCreate.typeE == "mine" or enemiesCreate.typeE == "mach" then
    return "class 1"
  end
end
function createSpawn()
  if checkClass() == "class 1" then
    table.insert(enemiesSpawn, {t = enemiesCreate.t, x = enemiesCreate.x, y = 0, typeE = enemiesCreate.TypeE, c = true})
  end
end
function mouseBuilder(x, y, button)
  if button == "l" then
    createSpawn()
  end
end
function keyBuilder(key)
  if key == "s" then
    enemiesCreate.typeE = "square"
  end
  if key == "m" then
    enemiesCreate.typeE = "mine"
  end
  if key == "a" then
    enemiesCreate.typeE = "mach"
  end
  if key == "f" then
    timeChange = "forward"
  end
  if key == "p" then
    timeChange = "pause"
  end
  if key == "b" then
    timeChange = "backward"
  end
  if key == "i" then
    love.filesystem.write("testlevel.lua", enemiesSpawn)
  end
end
function drawBuilder()
  love.graphics.setColor(70, 70, 70)
  collider:addRectangle(0, 0, 900, 50):draw("fill")
  collider:addRectangle(0, 50, 50, 600):draw("fill")
  collider:addRectangle(0, 650, 900, 50):draw("fill")
  collider:addRectangle(850, 50, 50, 600):draw("fill")
  love.graphics.setColor(255, 0, 255)
  enemiesCreate.shape:draw("fill")
  for i,v in ipairs(enemiesSpawn) do
    for ke,ve in pairs(enemiesSpawn[i]) do
      v.shape:draw("fill")
    end
  end
end