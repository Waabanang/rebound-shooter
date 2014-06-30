function loadLevel()
 love.graphics.setBackgroundColor(0, 0, 0) --sets background color to black
 love.window.setMode(800, 600) --screen size 800x600
 collider = HC(100, on_collide) --no idea, really... basic setup
 
 typeP = "cherryBomb"
 enemiesSpawn = {{t=2, x=400, c=true, typeE = "square"}, {t=10, x=200, c=true, typeE = "square"}, {t=10, x=550, c=true, typeE = "square"}, {t=10, x=400, c=true, typeE = "mine"}, {t=10, x = 400,  c=true, typeE = "mach"}}
end
