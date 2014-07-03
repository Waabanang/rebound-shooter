function loadBullets()
  bullets = {} --holds all non-friendly bullets
  bullets.fuck = "fuck" --dummy varible
  powerUps = {}
end
function updateBullets(dt)
  for i,v in ipairs(bullets) do 
    v.shape:move(0, v.speed*dt) --bullets go down
    if cTime-v.time > 3 then
      table.remove(bullets, i) --deletes bullets that have been around for three seconds
    end
  end
  for i,v in ipairs(powerUps) do 
    v.shape:move(0, 50*dt) --bullets go down
    if cTime-v.time > 5 then
      table.remove(bullets, i) --deletes bullets that have been around for three seconds
    end
  end
end
function drawBullets()
  love.graphics.setColor(255, 255, 255)--white bullets
  for i,v in ipairs(bullets) do --draws all bullets
    if v.type == "unblock" then
      love.graphics.setColor(255, 0, 0)
    else
      love.graphics.setColor(255, 255, 255)
    end
    v.shape:draw("fill")
  end
  love.graphics.setColor(255, 255, 255)--white bullets
  for i,v in ipairs(ship.shots) do --draws all bullets shot by ship
    v.shape:draw("fill")
  end
  for i,v in ipairs(powerUps) do --draws all bullets
    if v.type == "health" then
      love.graphics.setColor(0, 255, 0)
    elseif v.type == "charge" then
      love.graphics.setColor(255, 255, 0)
    end
    v.shape:draw("fill")
  end
end
function createBullet(startX, startY, size, speed, damage, typeB) --shoot function, five varibles
  local bullet = {}
  bullet.time = cTime --records how long the bullet has been around
  bullet.shape = collider:addCircle(startX, startY, size) --creates the bullets shape
  bullet.damage = damage --how much damage that bullet will deal
  bullet.speed = speed --how fast it moves
  bullet.type = typeB
  table.insert(bullets, bullet) --add the bullet to the bullets table
  collider:addToGroup(bullets, bullet.shape) --bullets don't collide with other bullets (also shield)
end
function spawnPowerUp(startX, startY, typeOf)
  local powerup = {}
  powerup.time = cTime
  powerup.shape = collider:addCircle(startX, startY, 5)
  powerup.type = typeOf
  if typeOf == "health" then
    powerup.effect = function()
      if ship.sHp - ship.hp < 50 then
        ship.hp = ship.sHp
      else
        ship.hp = ship.hp + 50
      end
    end
  elseif typeOf == "charge" then
    powerup.effect = function()
      if ship.sCharge - ship.charge < 70 then
        ship.charge = ship.sCharge
      else
        ship.charge = ship.charge + 70
      end
    end
  end
  table.insert(powerUps, powerup)
end
