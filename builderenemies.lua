function loadEnemiesB()
  enemies = {}
 end
function updateEnemiesB(dTime)
  for i,v in ipairs(enemies) do
    v.x, v.y = v.shape:center()
    if v.x > 850 or v.x < 50 or v.y > 750 or v.y < 50 then
      table.remove(enemies, i)
    end
    if timeChange == "forward" then
      local move = v.movement[1]
      if v.time + move.switch <= cTime then
        v.lastTime = v.time
        v.time = v.time + move.switch
        if move.brake then
          table.remove(v.movement, 1)
        else
          table.insert(v.movement, move)
          table.remove(v.movement, 1)
        end
        collider:addToGroup(enemies, move.movement.shape)
      end
    elseif timeChange == "backward" then
      local move = v.movement[#v.movement]
      if v.lastTime + move.switch >= cTime then
        v.time = v.lastTime
        v.lastTime = v.lastTime - move.switch
        if move.brake then 
          -- what am I supposed to do here? --
        else
          table.insert(v.movement, [1,] move)
          table.remove(v.movement, #v.movement)
        end
        collider:addToGroup(enemies, move.movement.shape)
      end
    end
    moveEnemy(move.shape, move.move, move.speed, dTime)
  end
  for k,v in pairs(enemiesSpawn) do
    if v.c and timeChange ~= "backward" and cTime >= v.t then
      spawnEnemy(v.x, v.y, v.typeE)
      v.c = false
    elseif not v.c and timeChange == "backward" and cTime >= v.t then
      -- hmmm... --
    end 
  end
end
function drawEnemiesB()
    love.graphics.setColor(255, 0, 255) --magenta enemies
    for i,v in ipairs(enemies) do
      v[1].shape:draw("fill")
    end
  end
function spawnEnemy(x, y, typeE)
  local test = {}
  test.time = love.timer.getTime()
  if typeE == "square" then
    table.insert(test.movement, {typeEn = typeE, shape = collider:addRectangle(x, y, 30, 30), move = "dl", speed = 50, brake = false, switch = 1.0})
    table.insert(test.movement, {typeEn = typeE, shape = collider:addRectangle(x, y, 30, 30), move = "dr", speed = 50, brake = false, switch =  1.0})
  elseif typeE == "mine" then
    table.insert(test.movement, {typeEn = typeE, shape = collider:addCircle(x, y, 10), move = "d", speed = 50, brake = false, switch = 1})
    table.insert(test.movement, {typeEn = typeE, shape = collider:addCircle(x, y, 10), move = "u", speed = 50, brake = false, switch = 0.25})
  elseif typeE = "mach" then
    table.insert(test.movement, {typeEn = typeE, shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30), move = "d", speed = 50, brake = true, switch = 4})
    table.insert(test.movement, {typeEn = typeE, shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30), move = "l", speed = 50, brake = false, switch = 2})
    table.insert(test.movement, {typeEn = typeE, shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30), move = "r", speed = 50, brake = false, switch = 4})
    table.insert(test.movement, {typeEn = typeE, shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30), move = "l", speed = 50, brake = false, switch = 2}) 
  end
  table.insert(enemies, test)
  collider:addToGroup(enemies, test.movement[1].shape)
end
function moveEnemy(shape, dir, speed, dTime)B
  if dir == "l" then
   shape:move(-speed*dTime, 0)
  elseif dir == "r" then
   shape:move(speed*dTime, 0)
  elseif dir == "d" then
   shape:move(0, speed*dTime)
  elseif dir == "u" then
   shape:move(0, -speed*dTime)
  elseif dir == "dr" then
   shape:move(speed*dTime, speed*dTime)
  elseif dir == "dl" then
   shape:move(-speed*dTime, speed*dTime)
  elseif dir == "ur" then
   shape:move(speed*dTime, -speed*dTime)
  elseif dir == "dl" then
   shape:move(-speed*dTime, -speed*dTime)
  end
end