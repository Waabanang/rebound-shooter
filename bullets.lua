function loadBullets()
  bullets = {} --holds all non-friendly bullets
  bullets.fuck = "fuck" --dummy varible
end
function updateBullets(dt)
  for i,v in ipairs(bullets) do 
    v.shape:move(0, v.speed*dt) --bullets go down
    if love.timer.getTime()-v.time > 3 then
      table.remove(bullets, i) --deletes bullets that have been around for three seconds
    end
  end
end
function drawBullets()
  love.graphics.setColor(255, 255, 255)--white bullets
  for i,v in ipairs(bullets) do --draws all bullets
    v.shape:draw("fill")
  end
  for i,v in ipairs(ship.shots) do --draws all bullets shot by ship
    v.shape:draw("fill")
  end
end
function createBullet(startX, startY, size, speed, damage) --shoot function, five varibles
  local bullet = {}
  bullet.time = love.timer.getTime() --records how long the bullet has been around
  bullet.shape = collider:addCircle(startX, startY, size) --creates the bullets shape
  bullet.damage = damage --how much damage that bullet will deal
  bullet.speed = speed --how fast it moves
  table.insert(bullets, bullet) --add the bullet to the bullets table
  collider:addToGroup(bullets, bullet.shape) --bullets don't collide with other bullets (also shield)
end
