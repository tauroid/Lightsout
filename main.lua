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
    print(key,"pressed")
end

function love.keyreleased(key)
    keyIsPressed[key] = false
    print(key,"released")
end

function love.draw()
    love.graphics.draw(esprite,e.x_loc,e.y_loc,0,4)
end

function love.update()
    processInput()
    e.update()
end

function processInput()
    if getKeyPressed("a") or getKeyPressed("left") then
        e.moveLeft = true
    else
        e.moveLeft = false
    end
    if getKeyPressed("d") or getKeyPressed("right") then
        e.moveRight = true
    else
        e.moveRight = false
    end
end
    
function getKeyPressed(key)
    if keyIsPressed[key] ~= nil and keyIsPressed[key] then
        return true
    else
        return false
    end
end