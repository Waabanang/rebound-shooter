function loadBullets()
  bullets = {} --holds all non-friendly bullets
  powerUps = {}
end
function updateBullets(dt)
  for i,v in ipairs(bullets) do
<<<<<<< HEAD
    v.x, v.y = v.shape:center()
    v.move(i, v.x, v.y, dt)  -- bullets move function, moves bullets
    if v.x > 800 or v.x < 0 or v.y > 600 or v.y < 0 then
      table.remove(bullets, i)
    end
    if v.time >= cTime then
      v.afterTime(i, v.x, v.y)  -- calls after-time to check if a time based effect needs to be called
=======
    if v.time <= cTime then
      v:afterTime(i)
>>>>>>> pr/12
    end
    v:move(dt)  -- bullets move function, moves bullets
    v.x, v.y = v.shape:center()
  end
  for i,v in ipairs(ship.shots) do
<<<<<<< HEAD
    v.x, v.y = v.shape:center()
    v.move(i, v.x, v.y)  -- bullets move function, moves bullets
    if v.x > 800 or v.x < 0 or v.y > 600 or v.y < 0 then
      table.remove(bullets, i)
    end
    if v.time >= cTime then
      v.afterTime(i, v.x, v.y)  -- calls after-time to check if a time based effect needs to be called
=======
    if v.time <= cTime then
      v:afterTime(i)
>>>>>>> pr/12
    end
    v:move(dt)
    v.x, v.y = v.shape:center()
  end
  for i,v in ipairs(powerUps) do
    if v.time <= cTime then
      v:afterTime(i)
    end
    v:move(dt)  -- moves the powerups
    v.x, v.y = v.shape:center()
  end
end
function drawBullets()
  for i,v in ipairs(bullets) do -- draws all bullets
    v:draw()  -- call the bullets[i].draw function, draws bullets
  end
  for i,v in ipairs(ship.shots) do
    v:draw()
  end
  for i,v in ipairs(powerUps) do --draws all bullets
<<<<<<< HEAD
    v.draw(i, v.x, v.y)
  end
end
function createBullet(x, y, typeB, tbl)  -- tbl is table to add to
  local bullet = {}
  bullet.typeB = typeB
  if typeB == "basic" then
    bullet.shape = collider:addCircle(x, y, 5)  -- creates the bullets shape
    bullet.move = function(i, x, y, dt)
      tbl[i].shape:move(0, 70 * dt)
    end
    bullet.onCollide = function(i)
      table.remove(tbl, i)
      return "damage", 15  -- how much damage that bullet will deal
    end
    bullet.draw = function(i)
      tbl[i].shape:draw("fill")
    end
    bullet.afterTime = function(i, xPos, yPos) end
  elseif typeB == "unblock" then
    bullet.shape = collider:addCircle(x, y, 3)  -- creates the bullets shape
    bullet.move = function(i, x, y, dt)
      tbl[i].shape:move(0, 100 * dt)
    end
    bullet.onCollide = function(i)
      table.remove(tbl, i)
      return "damage", 7  -- how much damage that bullet will deal
    end
    bullet.draw = function(i)
      tbl[i].shape:draw("fill")
    end
    bullet.afterTime = function(i, xPos, yPos) 
    end
  end
  bullet.time = cTime + 5  -- records when bullet needs to be destroyed
  table.insert(tbl, bullet)
  collider:addToGroup(tbl, bullet.shape)
=======
    v:draw()
  end
end
function createBullet(x, y, typeB)  -- self is table to add to
  local bullet = {}
  bullet.typeB = typeB
  bullet.x = x
  bullet.y = y
  if typeB == "basic" then
    bullet.shape = collider:addRectangle(x, y, 3, 6)  -- creates the bullets shape
    bullet.move = function(self, dt)  -- move method for movement[2]
      self.shape:move(0, 150 * dt)  -- down, right, 40 px/sec, will be in movement[1] when called
    end
    bullet.onCollide = function(self, obj, i)
      obj.hp = obj.hp - 20
      table.remove(bullets, i)
    end
    bullet.draw = function(self)
      love.graphics.setColor(255, 255, 250)  -- off white
      self.shape:draw("fill")
    end
    bullet.afterTime = function(self, i) end
  elseif typeB == "unblock" then
    bullet.shape = collider:addRectangle(x, y, 2, 7)  -- creates the bullets shape
    bullet.move = function(self, dt)
      self.shape:move(0, 200 * dt)
    end
    bullet.onCollide = function(self, obj, i)
      obj.hp = obj.hp - 15
      table.remove(bullets, i)
    end
    bullet.draw = function(self)
      love.graphics.setColor(255, 0, 0)  -- red
      self.shape:draw("fill")
    end
    bullet.afterTime = function(self, i) end
  end
  bullet.time = cTime + 5  -- records when bullet needs to be destroyed
  table.insert(bullets, bullet)
  collider:addToGroup(bullets, bullet.shape)
>>>>>>> pr/12
end
function spawnPowerUp(x, y, typeP)
  local powerup = {}
  powerup.typeP = typeP
<<<<<<< HEAD
  if typeP == "health" then
    powerup.shape = collider:addCircle(x, y, 5)
    powerup.draw = function(i)
      if powerUps[i].time - 2 < cTime or math.floor(10 * (powerUps[i].time - cTime)) % 2 ~= 0 then
=======
  powerup.x = x
  powerup.y = y
  powerup.afterTime = function(self, i)
    table.remove(powerUps, i)
  end
  if typeP == "health" then
    powerup.shape = collider:addCircle(x, y, 5)
    powerup.draw = function(self)
      if self.time - 2 > cTime or math.floor(10 * (self.time - cTime)) % 2 ~= 0 then
>>>>>>> pr/12
        love.graphics.setColor(0, 255, 0)
        self.shape:draw("fill")
      end
    end
<<<<<<< HEAD
    powerup.move = function(i, x, y, dt)
      powerUps[i].shape:move(0, 30 * dt)
    end
    powerup.onCollide = function(i)
      if ship.hpStart - ship.hp >= 50 then
        ship.hp = ship.hp + 50
=======
    powerup.move = function(self, dt)
      self.shape:move(0, 50 * dt)  -- scrolling speed
    end
    powerup.onCollide = function(self, obj, i)
      if obj.sHp - obj.hp >= 50 then
        obj.hp = obj.hp + 50
>>>>>>> pr/12
      else
        obj.hp = obj.sHp
      end
      table.remove(powerUps, i)
    end
<<<<<<< HEAD
  elseif typeOf == "charge" then
    powerup.shape = collider:addRectangle(x, y, 4, 4)
    powerup.draw = function(i)
      if powerUps[i].time - 2 < cTime or math.floor(10 * (powerUps[i].time - cTime)) % 2 ~= 0 then
        love.graphics.setColor(0, 255, 0)
        powerUps[i].shape:draw("fill")
      end
    end
    powerup.move = function(i, x, y, dt)
      powerUps[i].shape:move(0, 30 * dt)
    end
    powerup.onCollide = function(i)
      if ship.chargeStart - ship.charge > 70 then
        ship.chargeStart = ship.chargeStart + 50
=======
  elseif typeP == "charge" then
    powerup.shape = collider:addRectangle(x, y, 8, 8)
    powerup.draw = function(self)
      if self.time - 2 > cTime or math.floor(10 * (self.time - cTime)) % 2 ~= 0 then
        love.graphics.setColor(255, 255, 0)
        self.shape:draw("fill")
      end
    end
    powerup.move = function(self, dt)
      self.shape:move(0, 50 * dt)  -- scrolling speed
    end
    powerup.onCollide = function(self, obj, i)
      if obj.sCharge - obj.charge > 50 then
        obj.charge = obj.charge + 50
>>>>>>> pr/12
      else
        obj.charge = obj.sCharge
      end
      table.remove(powerUps, i)
    end
  end
  powerup.time = cTime + 5
  table.insert(powerUps, powerup)
end