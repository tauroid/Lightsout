require('electrician')

g = .4

function love.load()
    e = steph
    e:initialise()
end

function love.keypressed(key)
    processInput{intype="key",keycode=key,pressed=1}
    print(key,"pressed")
end

function love.keyreleased(key)
    processInput{intype="key",keycode=key,pressed=0}
    print(key,"released")
end

function love.draw()
    e:draw()
end

function love.update()
    e:update(love.timer.getDelta())
    doPhysics()
    e:draw()
end

function processInput(input)
    if input.intype == "key" then
        if input.keycode == "escape" then love.event.quit() end
        if input.pressed == 1 and input.keycode == "a" or input.keycode == "left" then
            e:moveLeft()
        elseif input.pressed == 0 and input.keycode == "a" or input.keycode == "left" then
            e.movingLeft = false
        end
        if input.pressed == 1 and input.keycode == "d" or input.keycode == "right" then
            e:moveRight()
        elseif input.pressed == 0 and input.keycode == "d" or input.keycode == "right" then
            e.movingRight = false
        end
        if input.keycode == " " and input.pressed == 1 then
            e:jump()
        end
    end
end

function doPhysics()
    if e.jumping then
        e.y_vel = e.y_vel + g
    end
    if e.y_loc >= 100 then
        e.jumping = false
        e.y_loc = 100
    end
end