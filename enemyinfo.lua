function refEnemy(typeE, x, y)
  local ref = {}  -- define local ref
  ref.x = x  -- position
  ref.y = y
  ref.typeE = typeE  -- type of enemy
  if typeE == "square" then  -- if "square" enemies ...
    ref.hp = 50  -- hp not variable on movement, equal to 50pts
    ref.onDeath = function(self, i)  -- on-death method
      spawnPowerUp(self.x, self.y, "health")
      table.remove(enemies, i)
    end
    ref.onSpawn = function(self) end  -- no on-spawn method
    ref.shape = collider:addRectangle(x, y, 30, 30)
    ref.draw = function(self)  -- shape method
      love.graphics.setColor(255, 0, 255)
      self.shape:draw("fill")  -- "square" shape
    end
    ref.onCollide = function(self, obj, i)  -- on-colide method
      obj.hp = obj.hp - 25
      self:onDeath(i)  -- call on-death method
    end
    ref.bullets = {{typeB = "unblock", rate = 0.25},{typeB = "basic", rate = 0.25},{typeB = "basic", rate = 0.5}} -- bullet shooting pattern
    ref.movement = {{},{}}  -- movement directory for all variable data
    ref.movement[1].move = function(self, dt)  -- move method for movement[1]
      self.shape:move(-40 * dt, 40 * dt)  -- down, left, 40 px/sec
    end
    ref.movement[1].switch = 1
    ref.movement[1].onSwitch = function(self) end  -- no on switch action
    ref.movement[2].move = function(self, dt)  -- move method for movement[2]
      self.shape:move(40 * dt, 40 * dt)  -- down, right, 40 px/sec, will be in movement[1] when called
    end
    ref.movement[2].switch = 1 -- time until movement[i+1]
    ref.movement[2].onSwitch = function(self) end  -- no on switch action
  end
  if typeE == "mine" then  -- if it's a mine
    ref.hp = 1  -- hp not variable on movement, instant kills
    ref.onDeath = function(self, i)  -- on-death method
      spawnPowerUp(self.x, self.y, "health")
      table.remove(enemies, i)
    end
    ref.onSpawn = function(self) end  -- no on spawn method
    ref.movement = {{},{}}  -- movement directory for all variable data
    ref.shape = collider:addCircle(x, y, 10)
    ref.draw = function (self)  -- shape method
      love.graphics.setColor(255, 0, 255)  -- magenta enemy
      self.shape:draw("fill")  -- "mine" shape, it's a samll circle
    end
    ref.onCollide = function(self, obj, i)  -- on-colide method
      obj.hp = obj.hp - 50
      self:onDeath(i)
    end
    ref.bullets = {{typeB = "noshoot", rate = 0}}  -- doesn't shoot
    ref.movement = {{},{}}
    ref.movement[1].move = function(self, dt)  -- move method for movement[1]
      self.shape:move(0, 50 * dt)
    end
    ref.movement[1].switch = 1  -- movement[1] switch after one second
    ref.movement[1].onSwitch = function(self) end  -- no method on-switch
    ref.movement[2].move = function(self, dt)  -- move method for movement[2]
      self.shape:move(0, -50 * dt)
    end
    ref.movement[2].switch = 0.25  -- movement[2] switch after quarter second
    ref.movement[2].onSwitch = function(self) end  -- no method on-switch
  end
  if typeE == "mach" then  -- if it's a "mach"
    ref.hp = 25
    ref.onDeath = function(self, i)  -- on-death method
      spawnPowerUp(self.x, self.y, "health")
      table.remove(enemies, i)
    end
    ref.onSpawn = function(self) end
    ref.shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y -30)
    ref.draw = function(self)  -- shape method
      love.graphics.setColor(255, 0, 255)
      self.shape:draw("fill")  -- "mach" shape
    end
    ref.onCollide = function(self, obj, i)  -- on-colide method
      obj.hp = obj.hp - 25
      self:onDeath(i)
    end
    ref.bullets = {{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 0.5},{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 1}}  -- long delay after every 6th bullet, short on the 3rd
    ref.movement = {{},{},{}}
    ref.movement[1].move = function(self, dt)  -- move method for movement[1]
      self.shape:move(0, 50 * dt)
    end
    ref.movement[1].switch = 4
    ref.movement[1].onSwitch = function(self) -- override movement[1] onSwitch
      table.insert(self.movement, self.movement[1])  -- replaces brake
      table.remove(self.movement, 1)
      -- call on-switch for new movement specs
    end
    ref.movement[2].move = function(self, dt)  -- move method for movement[2]
      self.shape:move(25 * dt, 0)
    end
    ref.movement[2].switch = 2
    ref.movement[2].onSwitch = function(self) end  -- no method on-switch
    ref.movement[3].move = function(self, dt)
      self.shape:move(-25* dt, 0)
    end
    ref.movement[3].switch = 2
    ref.movement[3].onSwitch = function(self) end  -- no method on-switch
  end
  return ref  -- return the generated reference information
end