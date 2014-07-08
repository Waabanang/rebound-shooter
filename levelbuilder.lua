function loadBuilder()
  BE = require 'builderenememies'
  love.window.setMode(900, 700)
  love.graphics.setBackgroundColor(0, 0, 0)
  collider = HC(100, on_collide)
  enemiesCreate = {}
  enemiesCreate.t = 0
  enemiesCreate.TypeE = "square"
  enemiesCreate.shape = collider:addRectangle(0, 10, 30, 30)
  if not love.filesystem.exists("testlevel.lua") then
    love.filesystem.newFile("testlevel.lua")
    love.filesystem.write("testlevel.lua", "{}")
  end
  TL = love.filesystem.load("testlevel.lua")()
  enemiesSpawn = testLevel()
  timeChange = "pause"
  cTime = love.timer.getTime()
  love.mouse.setVisible(false)
  loadEnemiesB()
end
function updateBuilder(dt)
  if timeChange == "forward" then
    cTime = cTime + dt
    dTime = dt
  elseif timeChange == "backward" then
    cTime = cTime - dt
    dTime = -dt
  else
    dTime = 0
  end
  local cx, cy = love.mouse.getPosition()
  if checkClass() == "class 1" then
    enemiesCreate.y = 10
    if cx >= 50 and cx <= 850 th  en
      enemiesCreate.x = cx
    elseif cx < 50 then
      enemiesCreate.x = 50
    elseif cx > 850 then
      enemiesCreate.x = 850
    end
    if enemiesCreate.typeE == "square" then
      enemiesCreate.shape = collider:addRectangle(enemiesCreate.x, 10, 30, 30)
    elseif enemiesCreate.typeE == "mine" then
      enemiesCreate.shape = collider:addCircle(enemiesCreate.x, 20, 10)
    elseif enemiesCreate.typeE == "mach" then
      enemiesCreate.shape = collider:addPolygon(0.667 * enemiesCreate.x, 0, 0.667 * enemeisCreate.x + 6.67, 45, 0.667 * enemiesCreate.x - 6.67, 5)
    end
  end
  updateEnemiesB(dt)
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
    enemiesCreate.shape = collider:addRectangle(enemiesCreate.x, 15, 30, 30)
  end
  if key == "m" then
    enemiesCreate.typeE = "mine"
    enemiesCreate.shape = collider:addCircle(enemiesCreate.x, 20, 10)
  end
  if key == "a" then
    enemiesCreate.typeE = "mach"
    enemiesCreate.shape = collider:addPolygon(0.667 * enemiesCreate.x, 0, 0.667 * enemeisCreate.x + 6.67, 45, 0.667 * enemiesCreate.x - 6.67, 5)
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
    if v.c and v.t >= cTime - 2 then
      if v.typeE == "square" then
        local shape = collider:addRectangle(v.x, 15 30, 30)
      elseif v.typeE == "mine" then
        local shape = collider:addCircle(v.x, 20, 10)
      elseif v.typeE == "mach" then
        local shape = collider:addPolygon(0.667 * enemiesCreate.x, 0, 0.667 * enemeisCreate.x + 6.67, 45, 0.667 * enemiesCreate.x - 6.67, 5)
      end
      shape:draw("fill")
    end
  end
  drawEnemiesB()
end