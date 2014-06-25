function loadEnemies()
  enemies = {} --holds all on screen enemies
 end
function updateEnemies(dt)
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
    local move = v.movement[1]
    moveEnemy(v.shape, move.move, v.speed, dt)
    if move.switch + v.time <= love.timer.getTime() then
      v.time = love.timer.getTime()
      table.insert(v.movement, v.movement[1])
      table.remove(v.movement, 1)
    end
  end
  for k,v in pairs(enemiesSpawn) do
    if v.c and cTime >= v.t then
      if v.typeE == "square" then
        spawnEnemySquare(v.x, v.y)
      elseif v.typeE == "mine" then
        spawnEnemyMine(v.x, v.y)
      elseif v.typeE == "mach" then
        spawnEnemyMach(v.x)
      end
      v.c = false
    end 
  end
end
function drawEnemies(dt)
    love.graphics.setColor(255, 0, 255) --magenta enemies
    for k,v in pairs(enemies) do
      v.shape:draw("fill")
    end
  end
function spawnEnemySquare(x, y)
  if y == nil then
    y = 0
  end
  local test = {} --simple test enemy
  test.shape = collider:addRectangle(x, y, 30, 30)  --enemies shape
  test.hp = 50 --health
  test.damage = 25
  test.time = love.timer.getTime()
  test.movement = {{move = "dl", switch = 1.0},{move = "dr", switch =  1.0}}
  test.speed = 50 --speed at which the enemy moves
  test.rate = 0.25 --time between bullets in seconds
  test.n = 1 --accumulator for test.p to function
  test.p = 4 --defines that the 4th bullet will be negated
  test.nextShot = love.timer.getTime() + test.rate --first 'ghost' bullet, yet to be fired
  table.insert(enemies, test)
end
function spawnEnemyMine(x, y)
  if y == nil then
    y = 0
  end
  local mine = {} --just creating the mine now
  mine.time = love.timer.getTime()
  mine.shape = collider:addCircle(x, y, 10) --twice the size of a bullet
  mine.hp = 1 --if it hits something, it dies
  mine.movement = {{move = "d", switch = 1}, {move = "u", switch = 0.25}} --floating effect
  mine.speed = 40 -- will edit later to scroll speed * 1.25
  mine.damage = 50 -- only from collision
  mine.nextShot = 0
  mine.rate = 0
  mine.n = 1
  mine.p = 1
  table.insert(enemies, mine)
end
function spawnEnemyMach(x, y)
  if y == nil then
    y = 0
  end
  local mach = {} --machine gun enemy, should move down until a point, then left-right
  mach.time = love.timer.getTime()
  mach.shape = collider:addPolygon(x, y, x + 10, y - 30, x - 10, y - 30)
  mach.hp = 25 -- easy to kill
  mach.movement = {{move = "d", switch = 1}, {move = "d", switch = 1}} --just down for now
  mach.speed = 50
  mach.rate = 0.1
  mach.damage = 25
  mach.n = 1
  mach.p = 7
  mach.nextShot = love.timer.getTime() + mach.rate
  table.insert(enemies, mach)
end
function moveEnemy(shape, dir, speed, dt)
  if dir == "l" then
   shape:move(-speed*dt, 0)
  elseif dir == "r" then
   shape:move(speed*dt, 0)
  elseif dir == "d" then
   shape:move(0, speed*dt)
  elseif dir == "u" then
   shape:move(0, -speed*dt)
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