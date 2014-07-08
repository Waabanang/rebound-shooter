HC = require 'hardoncollider' --basic importing
EN = require 'enemies'
PA = require 'player'
LV = require 'levels'
BU = require 'bullets'
LF = require 'loveframes'
GU = require 'gui'

function love.load()
  love.graphics.setBackgroundColor(0, 0, 0) --sets background color to black
  love.window.setMode(800, 600) --screen size 800x600
  collider = HC(100, on_collide) --no idea, really... basic setup
  typeP = "basic"
  mainmenu()
  play = false
  timePaused = 0
end
function love.update(dt)
  collider:update(dt) --sets world in motion
  if play then
    cTime = love.timer.getTime() - sTime - timePaused
    updatePlayer(dt)
    updateEnemies(dt)
    updateBullets(dt)
  end
  loveframes.update(dt)
end
function love.draw() 
  if play then
    drawPlayer()
    drawBullets()
    drawEnemies()
  end
  loveframes.draw()
end
function love.keypressed(key)
  keyPlayer(key)
  if key == "escape" and play then
    pTime = love.timer.getTime()
    pausemenu()
  end
  loveframes.keypressed(key)
end
function love.keyreleased(key)
  loveframes.keyreleased(key)
end
function love.mousepressed(x, y, button)
  loveframes.mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button)
end
function on_collide(dt, shape_a, shape_b) --collision callback
  for i,v in ipairs(bullets) do --all bullet collisions
    if not ship.death and shape_a == v.shape and shape_b == ship.shape then --when a bullet and the ship collide
      ship.hp = ship.hp - v.damage --bullet reduces health by damage amount
        if typeP == "cherryBomb" then
          ship.bullets = {} --stores bullets stolen
          ship.bullets.dummy = "dummy" --dummy varible so that the table is populated
        end
      table.remove(bullets, i) --remove the bullet
    elseif not ship.death and shape_b == v.shape and shape_a == ship.shape then --same, just repeated in case of other
      ship.hp = ship.hp - v.damage
      table.remove(bullets, i)
       if typeP == "cherryBomb" then
          ship.bullets = {} --stores bullets stolen
          ship.bullets.dummy = "dummy" --dummy varible so that the table is populated
        end
    end
    if shape_a == v.shape and shape_b == ship.shield.shape and v.type ~= "unblock" then --when a bullet and the shield collide
      if #ship.bullets <= ship.shield.capacity then --if the ship hasn't already stolen ten bullets
        table.insert(ship.bullets, v) --add that bullet to the ships
      end
      table.remove(bullets, i) --and remove the bullet those that are being fired
    elseif shape_b == v.shape and shape_a == ship.shield.shape and v.type ~= "unblock"  then--repeat
      if #ship.bullets <= ship.shield.capacity then
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
  for i,v in ipairs(enemies) do
    if not ship.death and shape_a == v.shape and shape_b == ship.shape then
      ship.hp = ship.hp - v.damage
      v.hp = v.hp - (#ship.bullets + #ship.shots) * 5
    elseif not ship.death and shape_a == ship.shape and shape_b == v.shape then
      ship.hp = ship.hp - v.damage
      v.hp = v.hp - (#ship.bullets + #ship.shots) * 5
    end
    if typeP == "cherryBomb" then
      if not ship.death and shape_a == v.shape and shape_b == ship.shield.shape then
        v.hp = v.hp - #ship.bullets * 5
      elseif not ship.death and shape_a == ship.shield.shape and shape_b == v.shape then
        v.hp = v.hp - #ship.bullets  * 5
      end
    end
  end
  for i,v in ipairs(powerUps) do
    if shape_a == v.shape and shape_b == ship.shape then
      v.effect()
      table.remove(powerUps, i)
    elseif shape_a == ship.shape and shape_b == v.shape then
      v.effect()
      table.remove(powerUps, i)
    end
  end
end