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
    if ship.hp > 0 and shape_a == v.shape and shape_b == ship.shape then --when a bullet and the ship collide
      v:onCollide(ship, i)
        if typeP == "cherryBomb" then
          ship.bullets = {} --stores bullets stolen
          ship.bullets.dummy = "dummy" --dummy varible so that the table is populated
        end
    elseif ship.hp > 0 and shape_b == v.shape and shape_a == ship.shape then --same, just repeated in case of other
      v:onCollide(ship, i)
        if typeP == "cherryBomb" then
          ship.bullets = {} --stores bullets stolen
          ship.bullets.dummy = "dummy" --dummy varible so that the table is populated
        end
    end
    if ship.hp > 0 and shape_a == v.shape and shape_b == ship.shield.shape then --when a bullet and the shield collide
      if #ship.bullets <= ship.shield.capacity then --if the ship hasn't already stolen ten bullets
        v.draw = function(self)
          if self.typeB == "basic" then
            love.graphics.setColor(255, 255, 250)
          elseif self.typeB == "unblock" then
            love.graphics.setColor(245, 0, 0)
          end
          self.shape:draw("fill")
          love.graphics.setColor(0, 255, 255)
          self.shape:draw("line")
        end
        v.velocity = {x = (math.random() - 0.5) * 100, y = (math.random() - 0.5) * 100}
        v.move = function(self, dt)
          self.shape:move(self.velocity.x * dt, self.velocity.y * dt)
          if math.sqrt(((self.x - ship.x) ^ (2)) + ((self.y - ship.y) ^ 2)) > 30 then
            self.velocity.x = ((math.random() - 0.5) * 50) + ((ship.x - self.x) * 3)
            self.velocity.y = ((math.random() - 0.5) * 50) + ((ship.y - self.y) * 3)
          end
        end
        table.insert(ship.bullets, v) --add that bullet to the ships
      end
      table.remove(bullets, i) --and remove the bullet those that are being fired
    elseif ship.hp > 0 and shape_b == v.shape and shape_a == ship.shield.shape then--repeat
      if #ship.bullets <= ship.shield.capacity then
        v.draw = function(self)
          if self.typeB == "basic" then
            love.graphics.setColor(245, 255, 250)
          elseif self.typeB == "unblock" then
            love.graphics.setColor(245, 10, 10)
          end
          self.shape:draw("fill")
          love.graphics.setColor(0, 255, 255)
          self.shape:draw("line")
        end
        v.velocity = {x = (math.random() - 0.5) * 100, y = (math.random() - 0.5) * 100}
        v.move = function(self, dt)
          self.shape:move(self.velocity.x * dt, self.velocity.y * dt)
          if math.sqrt(((self.x - ship.x) ^ (2)) + ((self.y - ship.y) ^ 2)) > 30 then
            self.velocity.x = ((math.random() - 0.5) * 50) + ((ship.x - self.x) * 3)
            self.velocity.y = ((math.random() - 0.5) * 50) + ((ship.y - self.y) * 3)
          end
        end
        table.insert(ship.bullets, v)
      end
      table.remove(bullets, i)
    end
  end
  for i,v in ipairs(ship.shots) do --all bullet collisions
    for ie, ve in ipairs(enemies) do
      if ship.hp > 0 and shape_a == v.shape and shape_b == ve.shape[1] then --when a bullet and the ship collide
        v:onCollide(ve, i)
      elseif ship.hp > 0 and shape_b == v.shape and shape_a == ve.shape[1] then --same, just repeated in case of other
        v:onCollide(ve, i)
      end
    end
  end 
  for i,v in ipairs(enemies) do
    if ship.hp > 0 and shape_a == v.shape[1] and shape_b == ship.shape then
      v:onCollide(ship, i)
      v.hp = v.hp - (#ship.bullets + #ship.shots) * 5
    elseif ship.hp > 0 and shape_a == ship.shape and shape_b == v.shape[1] then
      v:onCollide(ship, i)
      v.hp = v.hp - (#ship.bullets + #ship.shots) * 5
    end
    if typeP == "cherryBomb" then
      if ship.hp > 0 and shape_a == v.shape and shape_b == ship.shield.shape then
        v.hp = v.hp - #ship.bullets * 5
      elseif ship.hp > 0 and shape_a == ship.shield.shape and shape_b == v.shape then
        v.hp = v.hp - #ship.bullets  * 5
      end
    end
  end
  for i,v in ipairs(powerUps) do
    if ship.hp > 0 and shape_a == v.shape and shape_b == ship.shape then
      v:onCollide(ship, i)
    elseif ship.hp > 0 and shape_a == ship.shape and shape_b == v.shape then
      v:onCollide(ship, i)
    end
  end
end