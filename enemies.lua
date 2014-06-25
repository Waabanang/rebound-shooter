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