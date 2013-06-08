require('electrician')
require('level1')
camera = { x_loc = 0,
           y_loc = 0,
           scale = 1.2 }
pixelsize = 5
paused = false
g = .1

function love.load()
    e = steph
    level = level1
    level:initialise()
    e:initialise()
    esprite = e:getFrame()
    e.level = level1
end

function love.keypressed(key)
    processInput{intype="key",keycode=key,pressed=1}
    print(key .. " pressed")
end

function love.keyreleased(key)
    processInput{intype="key",keycode=key,pressed=0}
    print(key .. " released")
end

function love.draw()
    drawLevel(level)
    esprite = e:getFrame()
    if esprite ~= nil then
        love.graphics.draw(esprite,
                           (e.x_loc*pixelsize-camera.x_loc)*camera.scale,
                           (e.y_loc*pixelsize-camera.y_loc)*camera.scale,
                           0,
                           e.direction*pixelsize*camera.scale,
                           pixelsize*camera.scale,5.5)
    end
end

function love.update()
    if not paused then
        e:update(love.timer.getDelta())
        e:doPhysics()
    end
end

function processInput(input)
    if input.intype == "key" then
        if input.keycode == "escape" then love.event.quit() end
        if input.pressed == 1 and (input.keycode == "a" or input.keycode == "left") then
            e:moveLeft()
        elseif input.pressed == 0 and (input.keycode == "a" or input.keycode == "left") then
            e.movingLeft = false
        elseif input.pressed == 1 and (input.keycode == "d" or input.keycode == "right") then
            e:moveRight()
        elseif input.pressed == 0 and (input.keycode == "d" or input.keycode == "right") then
            e.movingRight = false
        elseif input.pressed == 1 and (input.keycode == "w" or input.keycode == "up") then
            e:jump()
        elseif input.pressed == 1 and input.keycode == " " then
            e:startFixing()
        elseif input.pressed == 1 and input.keycode == "p" then
            paused = 1
        end
    end
end

function drawLevel(thelevel)
    if thelevel.fgimage.image ~= nil then
        love.graphics.draw(thelevel.fgimage.image,
                           (thelevel.fgimage.x_loc-camera.x_loc)*camera.scale,
                           (thelevel.fgimage.y_loc-camera.y_loc)*camera.scale,
                           0,5*camera.scale)
    end
end