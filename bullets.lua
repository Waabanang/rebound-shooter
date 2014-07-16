function loadBullets()
  bullets = {} --holds all non-friendly bullets
  powerUps = {}
end
function updateBullets(dt)
  for i,v in ipairs(bullets) do
    v.x, v.y = v.shape:center()
    v:move(dt)  -- bullets move function, moves bullets
  end
  for i,v in ipairs(ship.shots) do
    v.x, v.y = v.shape:center()
    v:move(dt)
  end
  for i,v in ipairs(powerUps) do 
    v.x, v.y = v.shape:center()
    v:move(dt)  -- moves the powerups
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
    v:draw()
  end
end
function createBullet(x, y, typeB)  -- self is table to add to
  local bullet = {}
  bullet.typeB = typeB
  if typeB == "basic" then
    bullet.shape = collider:addCircle(x, y, 4)  -- creates the bullets shape
    bullet.move = function(self, dt)  -- move method for movement[2]
      self.shape:move(0, 110 * dt)  -- down, right, 40 px/sec, will be in movement[1] when called
    end
    bullet.onCollide = function(self, obj, i)
      obj.hp = obj.hp - 20
      table.remove(bullets, i)
    end
    bullet.draw = function(self)
      self.shape:draw("fill")
    end
    bullet.afterTime = function(self, i) end
  elseif typeB == "unblock" then
    bullet.shape = collider:addCircle(x, y, 3)  -- creates the bullets shape
    bullet.move = function(self, dt)
      self.shape:move(0, 110 * dt)
    end
    bullet.onCollide = function(self, obj, i)
      obj.hp = obj.hp - 15
      table.remove(bullets, i)
    end
    bullet.draw = function(self)
      self.shape:draw("fill")
    end
    bullet.afterTime = function(self, i) end
  end
  bullet.time = cTime + 5  -- records when bullet needs to be destroyed
  table.insert(bullets, bullet)
  collider:addToGroup(bullets, bullet.shape)
end
function spawnPowerUp(x, y, typeP)
  local powerup = {}
  powerup.typeP = typeP
  powerup.afterTime = function(self, i)
    table.remove(powerUps, i)
  end
  if typeP == "health" then
    powerup.shape = collider:addCircle(x, y, 5)
    powerup.draw = function(self)
      if self.time - 2 > cTime or math.floor(10 * (self.time - cTime)) % 2 ~= 0 then
        love.graphics.setColor(0, 255, 0)
        self.shape:draw("fill")
      end
    end
    powerup.move = function(self, dt)
      self.shape:move(0, 30 * dt)
    end
    powerup.onCollide = function(self, obj, i)
      if obj.sHp - obj.hp >= 50 then
        obj.hp = obj.hp + 50
      else
        obj.hp = obj.sHp
      end
      table.remove(powerUps, i)
    end
  elseif typeOf == "charge" then
    powerup.shape = collider:addRectangle(x, y, 4, 4)
    powerup.draw = function(self)
      if self.time - 2 > cTime or math.floor(10 * (self.time - cTime)) % 2 ~= 0 then
        love.graphics.setColor(0, 255, 0)
        self.shape:draw("fill")
      end
    end
    powerup.move = function(self, dt)
      self.shape:move(0, 30 * dt)
    end
    powerup.onCollide = function(self, obj, i)
      if obj.chargeStart - obj.charge > 50 then
        obj.chargeStart = obj.chargeStart + 50
      else
        obj.charge = obj.chargeStart
      end
      table.remove(powerUps, i)
    end
  end
  powerup.time = cTime + 5
  table.insert(powerUps, powerup)
end