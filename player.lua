shipTypes = {"basic", "cherryBomb"}
function loadPlayer()
  ship = {} -- everying about our ship
  ship.bullets = {} --stores bullets stolen
  ship.shots = {}
  ship.shield = {}
  ship.shield.draw = function(self)
    if ship.hp > 0 and love.keyboard.isDown(" ") and ship.charge > 0 then
      love.graphics.setColor(0, 255, 255)
      self.shape:draw("line")
    end
  end
  if typeP == "basic" or typeP == nil then
    ship.shape =  collider:addPolygon(400, 500, 390, 530, 410, 530)--creates our triangular ship
    ship.draw = function(self)
      if self.hp > 0 then
        love.graphics.setColor(0, 255, 200)  --ship and shield color, cyan
        self.shape:draw("fill")
      end
    end
    ship.speed = 250 --ship speed
    ship.sCharge = 200
    ship.sHp = 200
    ship.shield.shape = collider:addCircle(400, 515, 30) --creates the shield, it's always there
    ship.shield.depleteRate = 100
    ship.shield.recharge = 50
    ship.shield.capacity = 10
  elseif typeP == "cherryBomb" then
    ship.shape =  collider:addPolygon(400, 500, 390, 515, 410, 515)--creates our triangular ship
    ship.draw = function(self)
      if self.hp > 0 then
        love.graphics.setColor(255, 0, 50)  --ship and shield color, cyan
        self.shape:draw("fill")
      end
    end
    ship.speed = 400 --ship speed
    ship.sCharge = 10
    ship.sHp = 150
    ship.shield.shape = collider:addCircle(400, 515, 60) --creates the shield, it's always there
    ship.shield.depleteRate = 100
    ship.shield.recharge = 200
    ship.shield.capacity = 100
  end
  ship.charge = ship.sCharge
  ship.hp = ship.sHp
  collider:addToGroup(ship, ship.shape, ship.shield.shape) --shield doesn't collide with ship
end
function updatePlayer(dt)
  ship.x, ship.y = ship.shape:center()--needs to be assigned here, so that they update as the ship moves
  ship.shield.isVisible = false --shield is normally not visisble
  collider:addToGroup(bullets, ship.shield.shape) --shield does not collide with bullets
  collider:addToGroup(enemies, ship.shield.shape)
  if ship.hp > 0 then
    if love.keyboard.isDown(" ") and ship.charge > 0 then --when you press space, and the shield has charge, it'll pop up
      ship.charge = ship.charge - ship.shield.depleteRate * dt --depletes charge while up
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
      for i,v in ipairs(ship.bullets) do
        ship.bullets[i].shape:move((-ship.speed / 1.5) * dt, 0)
      end
    elseif love.keyboard.isDown("d") then
      ship.shape:move(ship.speed * dt, 0)
      ship.shield.shape:move(ship.speed * dt, 0)
      for i,v in ipairs(ship.bullets) do
        ship.bullets[i].shape:move((ship.speed / 1.5) * dt, 0)
      end
    end
   --basic movement, vertical
    if love.keyboard.isDown("w") then
      ship.shape:move(0, - ship.speed * dt)
      ship.shield.shape:move(0, - ship.speed * dt)
      for i,v in ipairs(ship.bullets) do
        ship.bullets[i].shape:move(0, (-ship.speed / 1.5) * dt)
      end
    elseif love.keyboard.isDown("s") then
      ship.shape:move(0, ship.speed * dt)
      ship.shield.shape:move(0, ship.speed * dt)
      for i,v in ipairs(ship.bullets) do
        ship.bullets[i].shape:move(0, (ship.speed / 1.5) * dt)
      end
    end
    for i,v in ipairs(ship.bullets) do
      v:move(dt)
      ship.bullets[i].x, ship.bullets[i].y = ship.bullets[i].shape:center()
    end
  end
  if ship.hp <= 0 and ship.time == nil then
    ship.bullets = {}
    ship.time = cTime + 2
  elseif ship.hp <= 0 and ship.time <= cTime then
    loadPlayer()
    ship.time = nil
  end
 end
function keyPlayer(key)
  if key == "j" and #ship.bullets > 0 and typeP ~= "cherryBomb" then
    local bullet = ship.bullets[1]
    bullet.velocity = nil
    bullet.shape:move(ship.x - bullet.x, ship.y - bullet.y - 25)
    bullet.x, bullet.y = bullet.shape:center()
    if bullet.typeB == "basic" then
      bullet.draw = function(self)
        love.graphics.setColor(255, 255, 250)  -- off white
        self.shape:draw("fill")
      end
      bullet.move = function(self, dt)
        self.shape:move(0, -150 * dt)
      end
      bullet.onCollide = function(self, obj, i)
        obj.hp = obj.hp - 20
        table.remove(ship.shots, i)
      end
    elseif bullet.typeB == "unblock" then
      bullet.draw = function(self)
        love.graphics.setColor(255, 0, 0)  -- off white
        self.shape:draw("fill")
      end
      bullet.move = function(self, dt)
        self.shape:move(0, -200 * dt)
      end
      bullet.onCollide = function(self, obj, i)
        obj.hp = obj.hp - 15
        table.remove(ship.shots, i)
      end
    end
    bullet.time = cTime
    table.insert(ship.shots, bullet)
    table.remove(ship.bullets, 1)
  end
end
function drawPlayer()
  for i,v in ipairs(ship.bullets) do --draws all stolen shots
    v:draw()
  end
  ship.shield:draw()
  ship:draw()
  love.graphics.setColor(0,255,0)--health bar color, green
  love.graphics.rectangle("line", 0, 0, ship.sHp, 20) --outline
  love.graphics.rectangle("fill", 0, 0, ship.hp, 20) --draws according to current ammount of health
  love.graphics.setColor(255, 255, 0)--shield charge bar color, yellow
  love.graphics.rectangle("line", 0, 21, ship.sCharge, 20) --outline of the bar
  love.graphics.rectangle("fill", 0, 21, ship.charge, 20) --draws according to current charge
end