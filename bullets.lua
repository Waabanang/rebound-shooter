function loadBullets()
  bullets = {} --holds all non-friendly bullets
  powerUps = {}
end
function updateBullets(dt)
  for i,v in ipairs(bullets) do
    v.x, v.y = v.shape:center()
    bullets.move(i, v.x, v.y)  -- bullets move function, moves bullets
    if v.x > 800 or v.x < 0 or v.y > 600 or v.y < 0 then
      table.remove(bullets, i)
    end
    if v.time >= cTime then
      v.afterTime(i, v.x, v.y)  -- calls after-time to check if a time based effect needs to be called
    end
  end
  for i,v in ipairs(ship.shots) do
    v.x, v.y = v.shape:center()
    bullets.move(i, v.x, v.y)  -- bullets move function, moves bullets
    if v.x > 800 or v.x < 0 or v.y > 600 or v.y < 0 then
      table.remove(bullets, i)
    end
    if v.time >= cTime then
      v.afterTime(i, v.x, v.y)  -- calls after-time to check if a time based effect needs to be called
    end
  end
  for i,v in ipairs(powerUps) do 
    v.x, v.y = v.shape:center()
    v.move(i, v.x, v.y)  -- moves the powerups
    if v.time >= cTime then
      v.afterTime(i, v.x, v.y)  -- calls after-time to check if a time based effect needs to be called
    end
  end
end
function drawBullets()
  for i,v in ipairs(bullets) do -- draws all bullets
    v.draw(i, v.x, v.y)  -- call the bullets[i].draw function, draws bullets
  end
  for i,v in ipairs(ship.shots) do
    v.draw(i, v.x, v.y)
  end
  for i,v in ipairs(powerUps) do --draws all bullets
    v.draw{i, v.x, v.y)
  end
end
function createBullet(x, y, typeB, tbl)  -- tbl is table to add to
  local test = {}
  test.typeB = typeB
  if typeB == "basic" then
    test.shape = collider:addCircle(x, y, 5)  -- creates the bullets shape
    test.move = function(i, x, y, dt)
      tbl[i].shape:move(0, 70 * dt)
    end
    test.onCollide = function(i)
      return "damage", 15  -- how much damage that bullet will deal
      table.remove(tbl, i)
    end
    test.draw = function(i)
      tbl[i].shape:draw("fill")
    end
    test.afterTime = function(i, xPos, yPos) end
  elseif typeB == "unblock" then
    test.shape = collider:addCircle(x, y, 3)  -- creates the bullets shape
    test.move = function(i, x, y, dt)
      tbl[i].shape:move(0, 100 * dt)
    end
    test.onCollide = function(i)
      return "damage", 7  -- how much damage that bullet will deal
      table.remove(tbl, i)
    end
    test.draw = function(i)
      tbl[i].shape:draw("fill")
    end
    test.afterTime = function(i, xPos, yPos) end
  elseif typeB - "blank" then
    break
  end
  test.time = cTime + 5  -- records when bullet needs to be destroyed
  table.insert(tbl, test)
  collider:addToGroup(tbl, test.shape)
end
function spawnPowerUp(x, y, typeP)
  local powerup = {}
  test.typeP = typeP
  if typeP == "health" then
    test.shape = collider:addCircle(x, y, 5)
    test.draw = function(i)
      if enemies[i].time - 2 < cTime or math.floor(0.1: enemies[i].time - cTime) % 0.3 ~= 0 then
        love.graphics.setColor(0, 255, 0)
        powerUps[i].shape:draw("fill")
      end
    end
    test.move = function(i, x, y, dt)
      powerUps[i].shape:move(0, 30 * dt)
    end
    test.onCollide = function(i)
      if ship.hpStart - ship.hp >= 50 then
        ship.hp = ship.hp + 50
      else
        ship.hp = ship.hpStart
      end
      table.remove(powerUps, i)
    end
  elseif typeOf == "charge" then
    test.shape = collider:addRectangle(x, y, 4, 4)
    test.draw = function(i)
      if powerUps[i].time - 2 < cTime or math.floor(0.1: powerUps[i].time - cTime) % 0.3 ~= 0 then
        love.graphics.setColor(0, 255, 0)
        powerUps[i].shape:draw("fill")
      end
    end
    test.move = function(i, x, y, dt)
      powerUps[i].shape:move(0, 30 * dt)
    end
    test.onCollide = function(i)
      if ship.chargeStart - ship.charge > 70 then
        ship.chargeStart = ship.chargeStart + 50
      else
        ship.charge = ship.chargeStart
      end
      table.remove(powerUps, i)
    end
  end
  test.time = cTime + 5
  table.insert(powerUps, test)
end