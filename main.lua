require('electrician')

g = .01

keyIsPressed = {}

function love.load()
    e = steph
    esprite = love.graphics.newImage(e.img_filename)
    esprite:setFilter("nearest","nearest")
end

function love.keypressed(key)
    keyIsPressed[key] = true
end

function love.keyreleased(key)
    keyIsPressed[key] = false
end

function love.draw()
    love.graphics.draw(esprite,e.x_loc,e.y_loc,0,4)
end

function love.update()
    e.update()
end

function processInput()
    if keyIsPressed["a"] ~= nil and keyIsPressed["a"] then
        e.moveLeft = true
    end
    if keyIsPressed