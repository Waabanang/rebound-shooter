function refEnemy(typeE, x, y)
  local ref = {}  -- define local ref
  ref.x = x  -- position
  ref.y = y
  ref.typeE = typeE  -- type of enemy
  if typeE == "square" then  -- if "square" enemies ...
    ref.hp = 50  -- hp not variable on movement, equal to 50pts
    ref.onDeath = function(ie, x, y)  -- on-death method
      areaEffect(x, y, "fire", 25)  -- call area-effect function, type fire, deal 25 damage
      table.remove(enemies, ie)  -- destroy enemy
    end
    ref.onSpawn = function(ie, x, y) end  -- no on-spawn method
    ref.shape = collider:addRectangle(x, y, 30, 30)
    ref.draw = function(ie)  -- shape method
      love.graphics.setColor(255, 0, 255)
      enemies[ie].shape:draw("fill")  -- "square" shape
    end
    ref.onColide = function(ie, x, y)  -- on-colide method
      enemies[ie].onDeath(ie, x, y)  -- call on-death method
    end
    ref.bullets = {{typeB = "unblock", rate = 0.25},{typeB = "basic", rate = 0.25},{typeB = "basic", rate = 0.5}} -- bullet shooting pattern
    ref.movement = {{},{}}  -- movement directory for all variable data
    ref.movement[1].move = function(ie, shape, dt)  -- move method for movement[1]
      shape:move(-40 * dt, 40 * dt)  -- down, left, 40 px/sec
    end
    ref.movement[1].switch = 1
    ref.movement[1].onSwitch = function(ie, x, y) end  -- no on switch action
    ref.movement[2].move = function(ie, shape, dt)  -- move method for movement[2]
      shape:move(40 * dt, 40 * dt)  -- down, right, 40 px/sec, will be in movement[1] when called
    end
    ref.movement[2].switch = 1 -- time until movement[i+1]
    ref.movement[2].onSwitch = function(ie, x, y) end  -- no on switch action
  end
  if typeE == "mine" then  -- if it's a mine
    ref.hp = 1  -- hp not variable on movement, instant kills
    ref.onDeath = function(ie, x, y)  -- on-death method
      spawnPowerUp(x, y, "charge")  -- spawn charge
      table.remove(enemies, ie)  -- destroy enemy
    end
    ref.onSpawn = function(ie, x, y) end  -- no on spawn method
    ref.movement = {{},{}}  -- movement directory for all variable data
    ref.shape = collider:addCircle(x, y, 10)
    ref.draw = function (ie)  -- shape method
      love.graphics.setColor(255, 0, 255)  -- magenta enemy
      enemies[ie].shape:draw("fill")  -- "mine" shape, it's a samll circle
    end
    ref.onColide = function(ie, x, y)  -- on-colide method
      areaEffect(x, y, "fire", 50)  -- call area-effect function, type fire, deal 50 damage
      table.remove(enemies, ie)  -- destroy mine
    end
    ref.bullets = {{typeB = "noshoot", rate = 0}}  -- doesn't shoot
    ref.movement = {{},{}}
    ref.movement[1].move = function(ie, shape, dt)  -- move method for movement[1]
      shape:move(0, 50 * dt)
    end
    ref.movement[1].switch = 1  -- movement[1] switch after one second
    ref.movement[1].onSwitch = function(ie, x, y) end  -- no method on-switch
    ref.movement[2].move = function(ie, shape, dt)  -- move method for movement[2]
      shape:move(0, -50 * dt)
    end
    ref.movement[2].switch = 0.25  -- movement[2] switch after quarter second
    ref.movement[1].onSwitch = function(ie, x, y) end  -- no method on-switch
  end
  if typeE == "mach" then  -- if it's a "mach"
    ref.hp = 25
    ref.onDeath = function(ie, x, y)
      local chance = math.random(1, 5)  -- generate random integer betweeen 1 and 5
      if chance == 5 then  -- if it's 5 then
        spawnPowerUp(x, y, "health")  -- spawn health
      elseif chance == 4 then  -- or, if it's a 4
        spawnPowerUp(x, y, "charge")  -- spawn charge
      else  -- otherwise
        areaEffect(x, y, "fire", 35)  -- blow the fuck up
      end
      table.remove(enemies, ie)
    end
    ref.onSpawn = function(ie, x, y) end
    ref.shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y -30)
    ref.draw = function(ie)  -- shape method
      love.graphics.setColor(255, 0, 255)
      enemies[ie].shape:draw("fill")  -- "mach" shape
    end
    ref.onColide = function(ie, x, y)  -- on-colide method
      areaEffect(x, y, "fire", 35)  -- blow the fuck up
      table.remove(enemies, ie)
    end
    ref.bullets = {{typeB = "basic", rate = 0.1},{typeB = "basic", rate = 0.1},{typeB = "basic", rate = 0.2},{typeB = "basic", rate = 0.1},{typeB = "basic", rate = 0.1},{typeB = "basic", rate = 0.5}}  -- long delay after every 6th bullet, short on the 3rd
    ref.movement = {{},{},{}}
    ref.movement[1].move = function(ie,shape, dt)  -- move method for movement[1]
      shape:move(0, 50 * dt)
    end
    ref.movement[1].switch = 4
    ref.movement[1].onSwitch = function(ie, x, y) -- override movement[1] onSwitch
      table.insert(enemies[ie].movement, enemies[ie].movement[1])  -- replaces brake
      table.remove(enemies[ie].movement, 1)
      enemies[ie].onSwitch(ie, x, y) -- call on-switch for new movement specs
    end
    ref.movement[2].move = function(ie, shape, dt)  -- move method for movement[2]
      shape:move(25 * dt, 0)
    end
    ref.movement[2].switch = 2
    ref.movement[2].onSwitch = function(ie, x, y) end  -- no method on-switch
    ref.movement[3].move = function(ie, shape, dt)
      shape:move(-25* dt, 0)
    end
    ref.movement[3].switch = 2
    ref.movement[3].onSwitch = function(ie, x, y) end  -- no method on-switch
  end
  return ref  -- return the generated reference information
end