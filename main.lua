require('electrician')

g = .01

function love.load()
    e = electrician
    esprite = love.graphics.newImage(e.img_filename)
    esprite:setFilter("nearest","nearest")
end

function love.draw()
    love.graphics.draw(esprite,e.x_loc,e.y_loc,0,4)
end

function love.update()
    e.y_vel = g + e.y_vel
    e.x_loc = e.x_vel + e.x_loc
    e.y_loc = e.y_vel + e.y_loc
end