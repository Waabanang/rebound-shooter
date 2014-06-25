HC = require 'hardoncollider' --basic importing
function love.load()
  love.graphics.setBackgroundColor(0, 0, 0) --sets background color to black
  love.window.setMode(800, 600) --screen size 800x600
  collider = HC(100, on_collide) --no idea, really... basic setup
  
  ship = {} -- everying about our ship
  ship.bullets = {} --stores bullets stolen
  ship.bullets.dummy = "dummy" --dummy varible so that the table is populated
  ship.shots = {}
  ship.shape =  collider:addPolygon(400, 500, 390, 530, 410, 530)--creates our triangular ship
  ship.speed = 250 --ship speed
  ship.charge = 200 --starting charge
  ship.hp = 200 --starting health
  ship.shield = {} --holds all information about our shield
  ship.shield.isVisible = true --holds wheather or not our shield should be visible
  ship.shield.shape = collider:addCircle(400, 515, 30) --creates the shield, it's always there
  ship.death = false
  collider:addToGroup(ship, ship.shape, ship.shield.shape) --shield doesn't collide with ship
  
  enemies = {} --holds all on screen enemies
  bullets = {} --holds all non-friendly bullets
  bullets.fuck = "fuck" --dummy varible
  enemiesSpawn = {{t=5, x=400, y=0, c=true, typeE = "square"}, {t=20, x=200, y=0, c=true, typeE = "square"}, {t=20, x=550, y=0, c=true, typeE = "square"}}
  sTime = love.timer.getTime()
end
function love.update(dt)
  collider:update(dt) --sets world in motion
  cTime = love.timer.getTime() - sTime
  ship.x, ship.y = ship.shape:center()--needs to be assigned here, so that they update as the ship moves
  for i,v in ipairs(enemies) do
    v.x, v.y = v.shape:center() --same as above, but for our test enemies
    if v.y > 601 then
      table.remove(enemies, i)
    end
    if v.hp <= 0 then
      table.remove(enemies, i)
    end
    if v.nextShot <= love.timer.getTime() and v.n % v.p ~= 0 then 
      createBullet(v.x, v.y, 5, 300, 50) --then the shoot function will be called
      v.nextShot = love.timer.getTime() + v.rate
      v.n = v.n + 1 --accumulates
    elseif v.nextShot <= love.timer.getTime() and v.n % v.p == 0 then
      v.n = 1
      v.nextShot = love.timer.getTime() + v.rate
    end
    local move = v.movement[1].move
    moveEnemy(v.shape, move, v.speed, dt)
    if v.movement[1].switch + v.time <= love.timer.getTime() then
      v.time = love.timer.getTime()
      table.insert(v.movement, v.movement[1])
      table.remove(v.movement, 1)
    end
  end
  ship.shield.isVisible = false --shield is normally not visisble
  collider:addToGroup(bullets, ship.shield.shape) --shield does not collide with bullets
  if not ship.death then
    if love.keyboard.isDown(" ") and ship.charge > 0 then --when you press space, and the shield has charge, it'll pop up
      ship.charge = ship.charge - 100 * dt --depletes charge while up
      ship.shield.isVisible = true --is visible while up
      collider:removeFromGroup(bullets, ship.shield.shape) --can collide with bullets while up
    elseif ship.charge <= 200  and not love.keyboard.isDown(" ") then --if the space bar isn't being pressed, and charge isn't maxed
    ship.charge = ship.charge + 50 * dt --the shield will recharge
    end
    if ship.hp <= 0 then
      ship.death = true
      ship.tod = love.timer.getTime()
    end
  end
  if ship.death and ship.tod <= love.timer.getTime() - 2 then
    ship = {} -- everying about our ship
    ship.bullets = {} --stores bullets stolen
    ship.bullets.dummy = "dummy" --dummy varible so that the table is populated
    ship.shots = {}
    ship.shape =  collider:addPolygon(400, 500, 390, 530, 410, 530)--creates our triangular ship
    ship.speed = 250 --ship speed
    ship.charge = 200 --starting charge
    ship.hp = 200 --starting health
    ship.shield = {} --holds all information about our shield
    ship.shield.isVisible = true --holds wheather or not our shield should be visible
    ship.shield.shape = collider:addCircle(400, 515, 30) --creates the shield, it's always there
    ship.death = false
    collider:addToGroup(ship, ship.shape, ship.shield.shape) --shield doesn't collide with ship
    ship.x, ship.y = ship.shape:center()--needs to be assigned here, so that they update as the ship moves
    sTime = love.timer.getTime()
    cTime = love.timer.getTime() - sTime
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
  for i,v in ipairs(bullets) do 
    v.shape:move(0, v.speed*dt) --bullets go down
    if love.timer.getTime()-v.time > 3 then
      table.remove(bullets, i) --deletes bullets that have been around for three seconds
    end
  end
  for i,v in pairs(ship.shots) do
    v.shape:move(0, -v.speed*dt) --bullets go up
    if love.timer.getTime()-v.time > 3 then
      table.remove(ship.shots, i) --deletes bullets that have been around for three seconds
    end
  end
  for k,v in pairs(enemiesSpawn) do
    if v.c and cTime >= v.t then
      if v.typeE == "square" then
        spawnEnemySquare(v.x, v.y)
      end
      v.c = false
    end 
  end
end
function love.keypressed(key)
  if not ship.death and key == "j" then
    if #ship.bullets > 0 then
      ship.bullets[1].time = love.timer.getTime()
      table.insert(ship.shots, ship.bullets[1])
      table.remove(ship.bullets, 1)
    end
  end
end
function on_collide(dt, shape_a, shape_b) --collision callback
  for i,v in ipairs(bullets) do --all bullet collisions
    if not ship.death and shape_a == v.shape and shape_b == ship.shape then --when a bullet and the ship collide
      ship.hp = ship.hp - v.damage --bullet reduces health by damage amount
      table.remove(bullets, i) --remove the bullet
    elseif not ship.death and shape_b == v.shape and shape_a == ship.shape then --same, just repeated in case of other
      ship.hp = ship.hp - v.damage
      table.remove(bullets, i)
    end
    if shape_a == v.shape and shape_b == ship.shield.shape then --when a bullet and the shield collide
      if #ship.bullets <= 10 then --if the ship hasn't already stolen ten bullets
        table.insert(ship.bullets, v) --add that bullet to the ships
      end
      table.remove(bullets, i) --and remove the bullet those that are being fired
    elseif shape_b == v.shape and shape_a == ship.shield.shape then --repeat
      if #ship.bullets <= 10 then
        table.insert(ship.bullets, v)
      end
      table.remove(bullets, i)
    end
  end
  for i,v in ipairs(ship.shots) do --all bullet collisions
    for ie, ve in ipairs(enemies) do
      if not ship.death and shape_a == v.shape and shape_b == ve.shape then --when a bullet and the ship collide
        ve.hp = ve.hp - v.damage --bullet reduces health by damage amount
        table.remove(ship.shots, i) --remove the bullet
      elseif not ship.death and shape_b == v.shape and shape_a == ve.shape then --same, just repeated in case of other
      ve.hp = ve.hp - v.damage
      table.remove(ship.shots, i)
      end
    end
  end 
end
function love.draw() 
  if not ship.death then
    love.graphics.setColor(0, 255, 200)--ship and shield color, cyan
    if ship.shield.isVisible then --only draws the ship when visible is true
      ship.shield.shape:draw('line') 
    end
    ship.shape:draw('fill')
    for i,v in ipairs(ship.bullets) do --draws all stolen shots
      v.shape:draw("fill")
    end
  end
  love.graphics.setColor(0,255,0)--health bar color, green
  love.graphics.rectangle("line", 0, 0, 200, 20) --outline
  love.graphics.rectangle("fill", 0, 0, ship.hp, 20) --draws according to current ammount of health
  love.graphics.setColor(255, 255, 0)--shield charge bar color, yellow
  love.graphics.rectangle("line", 0, 21, 200, 20) --outline of the bar
  love.graphics.rectangle("fill", 0, 21, ship.charge, 20) --draws according to current charge
  love.graphics.setColor(255, 255, 255)--white bullets
  for i,v in ipairs(bullets) do --draws all bullets
    v.shape:draw("fill")
  end
  for i,v in ipairs(ship.shots) do --draws all bullets shot by ship
    v.shape:draw("fill")
  end
  love.graphics.setColor(255, 0, 255) --magenta enemies
  for k,v in pairs(enemies) do
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
function moveEnemy(shape, dir, speed, dt)
  if dir == "l" then
    shape:move(-speed*dt, 0)
  elseif dir == "r" then
    shape:move(speed*dt, 0)
  elseif dir == "d" then
    shape:move(0, speed*dt)
  elseif dir == "u" then
    shapeLmove(0, -speed*dt)
  elseif dir == "dr" then
    shape:move(speed*dt, speed*dt)
  elseif dir == "dl" then
    shape:move(-speed*dt, speed*dt)
  elseif dir == "ur" then
    shape:move(speed*dt, -speed*dt)
  elseif dir == "dl" then
    shape:move(-speed*dt, -speed*dt)
  end
end
function spawnEnemySquare(x, y)
  local test = {} --simple test enemy
  test.shape = collider:addRectangle(x, y, 30, 30)  --enemies shape
  test.hp = 50 --health
  test.time = love.timer.getTime()
  test.movement = {{move = "dl", switch = 1.0},{move = "dr", switch =  1.0}}
  test.speed = 50 --speed at which the enemy moves
  test.rate = 0.25 --time between bullets in seconds
  test.n = 1 --accumulator for test.p to function
  test.p = 4 --defines that the 4th bullet will be negated
  test.nextShot = love.timer.getTime() + test.rate --first 'ghost' bullet, yet to be fired
  table.insert(enemies, test)
end