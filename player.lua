shipTypes = {"basic", "cherryBomb"}
function loadPlayer()
  if typeP == "basic" or typeP == nil then
   ship = {} -- everying about our ship
   ship.bullets = {} --stores bullets stolen
   ship.bullets.dummy = "dummy" --dummy varible so that the table is populated
   ship.shots = {}
   ship.shape =  collider:addPolygon(400, 500, 390, 530, 410, 530)--creates our triangular ship
   ship.speed = 250 --ship speed
   ship.charge = 200 --starting charge
   ship.sCharge = 200
   ship.hp = 200 --starting health
   ship.sHp = 200
   ship.shield = {} --holds all information about our shield
   ship.shield.isVisible = true --holds wheather or not our shield should be visible
   ship.shield.shape = collider:addCircle(400, 515, 30) --creates the shield, it's always there
   ship.shield.depleteRate = 100
   ship.shield.recharge = 50
   ship.shield.capacity = 10
   ship.death = false
   collider:addToGroup(ship, ship.shape, ship.shield.shape) --shield doesn't collide with ship
  elseif typeP == "cherryBomb" then
   ship = {} -- everying about our ship
   ship.bullets = {} --stores bullets stolen
   ship.bullets.dummy = "dummy" --dummy varible so that the table is populated
   ship.shots = {}
   ship.shape =  collider:addPolygon(400, 500, 390, 515, 410, 515)--creates our triangular ship
   ship.speed = 400 --ship speed
   ship.charge = 10 --starting charge
   ship.sCharge = 10
   ship.hp = 150 --starting health
   ship.sHp = 150
   ship.shield = {} --holds all information about our shield
   ship.shield.isVisible = true --holds wheather or not our shield should be visible
   ship.shield.shape = collider:addCircle(400, 515, 60) --creates the shield, it's always there
   ship.shield.depleteRate = 100
   ship.shield.recharge = 200
   ship.shield.capacity = 100
   ship.death = false
   collider:addToGroup(ship, ship.shape, ship.shield.shape) --shield doesn't collide with ship
  end
end
function updatePlayer(dt)
  ship.x, ship.y = ship.shape:center()--needs to be assigned here, so that they update as the ship moves
  ship.shield.isVisible = false --shield is normally not visisble
  collider:addToGroup(bullets, ship.shield.shape) --shield does not collide with bullets
  collider:addToGroup(enemies, ship.shield.shape)
  if not ship.death then
    for i,v in pairs(ship.shots) do
      v.x, v.y = v.shape:center()
      v:move(dt)
      if v.time >= cTime then
        v:afterTime(i)
      end
    end
    if love.keyboard.isDown(" ") and ship.charge > 0 then --when you press space, and the shield has charge, it'll pop up
      ship.charge = ship.charge - ship.shield.depleteRate * dt --depletes charge while up
      ship.shield.isVisible = true --is visible while up
      collider:removeFromGroup(bullets, ship.shield.shape) --can collide with bullets while up
      collider:removeFromGroup(enemies, ship.shield.shape)
    elseif ship.charge <= ship.sCharge  and not love.keyboard.isDown(" ") then --if the space bar isn't being pressed, and charge isn't maxed
    ship.charge = ship.charge + ship.shield.recharge * dt --the shield will recharge
    end
--world borders
    if  ship.x > 799 then --when this border is reached
      ship.shape:move(-ship.speed * dt,0) --opposite force is applied
      ship.shield.shape:move(-ship.speed * dt,0) --shield moves with ship
    end
    if  ship.x < 1 then
      ship.shape:move(ship.speed * dt,0)
      ship.shield.shape:move(ship.speed * dt,0)
    end
    if  ship.y > 599 then
      ship.shape:move(0,-ship.speed * dt)
      ship.shield.shape:move(0,-ship.speed * dt)
    end
    if  ship.y < 1 then
      ship.shape:move(0,ship.speed * dt)
      ship.shield.shape:move(0,ship.speed * dt)
    end
  --basic movement, horizontal  
    if love.keyboard.isDown("a") then
      ship.shape:move(-ship.speed * dt, 0) --moves the player and shield left
      ship.shield.shape:move(-ship.speed * dt, 0)
      for i, v in ipairs(ship.bullets) do --stolen bullets move with player
        v.shape:move(-ship.speed * dt, 0)
      end
    elseif love.keyboard.isDown("d") then
      ship.shape:move(ship.speed * dt, 0)
      ship.shield.shape:move(ship.speed * dt, 0)
      for i, v in ipairs(ship.bullets) do
        v.shape:move(ship.speed * dt, 0)
      end
  end
   --basic movement, vertical
    if love.keyboard.isDown("w") then
      ship.shape:move(0, - ship.speed * dt)
      ship.shield.shape:move(0, - ship.speed * dt)
      for i, v in ipairs(ship.bullets) do
        v.shape:move(0, - ship.speed * dt)
      end
    elseif love.keyboard.isDown("s") then
      ship.shape:move(0, ship.speed * dt)
      ship.shield.shape:move(0, ship.speed * dt)
      for i, v in ipairs(ship.bullets) do
        v.shape:move(0, ship.speed * dt)
      end
    end
    if ship.hp <= 0 then
     ship.death = true
     ship.tod = love.timer.getTime()
   end
  end
  if ship.death and ship.tod <= love.timer.getTime() - 2 then
    loadPlayer()
  end
 end
function keyPlayer(key)
  if not ship.death and key == "j" and #ship.bullets > 0 and typeP ~= "cherryBomb" then
    ship.bullets[1].move = function(self, dt)
      self.shape:move(0, -110 * dt)
    end
    ship.bullets[1].time = love.timer.getTime()
    table.insert(ship.shots, ship.bullets[1])
    table.remove(ship.bullets, 1)
  end
end
function drawPlayer()
  if not ship.death then
    if typeP == "basic" then
      love.graphics.setColor(0, 255, 200)--ship and shield color, cyan
    elseif typeP == "cherryBomb" then
      love.graphics.setColor(255, 0, 50)
    end
    if ship.shield.isVisible then --only draws the ship when visible is true
      ship.shield.shape:draw('line') 
    end
    ship.shape:draw('fill')
    for i,v in ipairs(ship.bullets) do --draws all stolen shots
      v.shape:draw("fill")
    end
  end
  love.graphics.setColor(0,255,0)--health bar color, green
  love.graphics.rectangle("line", 0, 0, ship.sHp, 20) --outline
  love.graphics.rectangle("fill", 0, 0, ship.hp, 20) --draws according to current ammount of health
  love.graphics.setColor(255, 255, 0)--shield charge bar color, yellow
  love.graphics.rectangle("line", 0, 21, ship.sCharge, 20) --outline of the bar
  love.graphics.rectangle("fill", 0, 21, ship.charge, 20) --draws according to current charge
end