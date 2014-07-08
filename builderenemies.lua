function loadEnemiesB()
  enemies = {}
  reference.square = {}
  table.insert(reference.square.movement, {typeEn = typeE, shape = collider:addRectangle(x, y, 30, 30), move = "dl", speed = 50, brake = false, switch = 1.0})
  table.insert(reference.square.movement, {typeEn = typeE, shape = collider:addRectangle(x, y, 30, 30), move = "dr", speed = 50, brake = false, switch =  1.0})
  reference.mine = {}
  table.insert(reference.mine.movement, {typeEn = typeE, shape = collider:addCircle(x, y, 10), move = "d", speed = 50, brake = false, switch = 1})
  table.insert(reference.mine.movement, {typeEn = typeE, shape = collider:addCircle(x, y, 10), move = "u", speed = 50, brake = false, switch = 0.25})
  reference.mach = {}
  table.insert(reference.mach.movement, {typeEn = typeE, shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30), move = "d", speed = 50, brake = true, switch = 4})
  table.insert(reference.mach.movement, {typeEn = typeE, shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30), move = "l", speed = 50, brake = false, switch = 2})
  table.insert(reference.mach.movement, {typeEn = typeE, shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30), move = "r", speed = 50, brake = false, switch = 4})
  table.insert(reference.mach.movement, {typeEn = typeE, shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30), move = "l", speed = 50, brake = false, switch = 2}) 
 end
function updateEnemiesB(dTime)
  for i,v in ipairs(enemies) do
    v.x, v.y = v.shape:center()
    if v.x > 850 or v.x < 50 or v.y > 650 or v.y < 50 then
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
          table.insert(v.movement[1], move)
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
      local x, y = spawnPosition(v.t, v.typeE)
      x = x + v.x
      y = y + v.y
      if x < 50 or x > 850 or y < 50 or y > 650 then
        break
      else
        spawnEnemy(x, y, v.typeE)
      end
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
    test.movement = reference.square.movement
  elseif typeE == "mine" then
    test.movement = reference.mine.movement
  elseif typeE == "mach" then
    test.movement = reference.mach.movement
  end
  table.insert(enemies, test)
  collider:addToGroup(enemies, test.movement[1].shape)
end
function spawnPosition(t, typeE)
  local en = {}
  local ref = typeE:gsub('"(%d+)"', "%1")
  local totX, totY, totT = 0
  for i,v in ipairs(reference.ref.movement) do
    local moved = v.speed * v.switch
    en[i].t = v.switch
    en[i].x, en[i].y = 0
    if v.move == "l" then
      en[i].x = -moved
    elseif v.move == "r" then
      en[i].x = moved
    elseif v.move == "d" then
      en[i].y = moved
    elseif v.move == "u" then
      en[i].y = -moved
    elseif v.move == "dr" then
      en[i].x = moved
      en[i].y = moved
    elseif v.move == "dl" then
      en[i].x = -moved
      en[i].y = moved
    elseif v.move == "ur" then
      en[i].x = moved
      en[i].y = -moved
    elseif v.move == "ul" then
      en[i].x = -moved
      en[i].y = -moved
    end
    totX = totX + en[i].x
    totY = totY + en[i].y
    totT = totT + en[i].t
  end
  local testT, testX, testY = 0
  local full = {t = math.floor((t - cTime) / totT) * totT, x = math.floor((t - cTime) / totT) * totX, y = math.floor((t - cTime) / totT) * totY}
  local extraT = (t - cTime) - full.t
  for i, v in ipairs(en) do
    if extraT <= testT then
      break
    end
    testT = testT + v.t
    testX = testX + v.x
    testY = testY + v.y
  end
  x = full.x + testX
  y = full.y + testY
  return x, y
  -- so far all this determines is where the enemy would be at the end of the last movement switch, still need to define enemies[#enemies].time and the amount it's traveled in the last movement phase. --
  end
function moveEnemy(shape, dir, speed, dTime)
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
  elseif dir == "ul" then
   shape:move(-speed*dTime, -speed*dTime)
  end
end