level1 = { obstacles = { ground = { name = "ground",
                                    y_top = 70,
                                    y_bottom = 96,
                                    x_left = 0,
                                    x_right = 128 } },
           fgimage = { image = 0,
                       filename = "Level1/lv1housebackground.png",
                       x_loc = 0,
                       y_loc = 0 } }
                       
function level1:initialise()
    self.fgimage.image = love.graphics.newImage(self.fgimage.filename)
    self.fgimage.image:setFilter("nearest","nearest")
end

function level1:checkCollision(xloc,yloc,xvel,yvel,width,height)
    for k,obs in pairs(self.obstacles) do
        if xloc + width > obs.x_left and xloc < obs.x_right and yloc + height > obs.y_top and yloc < obs.y_bottom then
            return {"invalid",0}
        elseif xloc + width < obs.x_left and xloc + xvel + width + .1 > obs.x_left and yloc < obs.y_bottom and yloc + height > obs.y_top then
            return {"right",obs.x_left - width}
        elseif xloc > obs.x_right and xloc + xvel - .1 < obs.x_right and yloc < obs.y_bottom and yloc + height > obs.y_top then
            return {"left",obs.x_right}
        elseif yloc + height < obs.y_top and yloc + yvel + height + .1 > obs.y_top and xloc < obs.x_right and xloc + width > obs.x_left then
            return {"bottom",obs.y_top - height}
        elseif yloc > obs.y_bottom and yloc + yvel - .1 < obs.y_bottom and xloc < obs.x_right and xloc + width > obs.x_left then
            return {"top",obs.y_bottom}
        end
    end
    return {"none",0}
end