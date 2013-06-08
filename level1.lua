level1 = { obstacles = { ground = { name = "ground",
                                    y_top = 70,
                                    y_bottom = 96,
                                    x_left = 0,
                                    x_right = 128 },
                         wall = { name = "wall",
                                  y_top = 0,
                                  y_bottom = 96,
                                  x_left = -10,
                                  x_right = 0 } },
           fgimage = { image = 0,
                       filename = "Level1/lv1housebackground.png",
                       x_loc = 0,
                       y_loc = 0 } }
                       
function level1:initialise()
    self.fgimage.image = love.graphics.newImage(self.fgimage.filename)
    self.fgimage.image:setFilter("nearest","nearest")
end

function level1:checkCollision(xloc,yloc,xvel,yvel,width,height)
    local collisions = { invalid = false,
                         right = { exists = false, correctloc = 0 },
                         left = { exists = false, correctloc = 0 },
                         bottom = { exists = false, correctloc = 0 },
                         top = { exists = false, correctloc = 0 },
                         none = true
                       }
    for k,obs in pairs(self.obstacles) do
        if xloc + width > obs.x_left and xloc < obs.x_right and yloc + height > obs.y_top and yloc < obs.y_bottom then
            collisions.invalid = true
            collisions.none = false
        end
        if xloc + width <= obs.x_left and xloc + xvel + width >= obs.x_left and yloc < obs.y_bottom and yloc + height > obs.y_top then
            collisions.right.exists = true
            collisions.right.correctloc = obs.x_left - width
            collisions.none = false
        end
        if xloc >= obs.x_right and xloc + xvel <= obs.x_right and yloc < obs.y_bottom and yloc + height > obs.y_top then
            collisions.left.exists = true
            collisions.left.correctloc = obs.x_right
            collisions.none = false
        end
        if yloc + height <= obs.y_top and yloc + yvel + height >= obs.y_top and xloc < obs.x_right and xloc + width > obs.x_left then
            collisions.bottom.exists = true
            collisions.bottom.correctloc = obs.y_top - height
            collisions.none = false
        end
        if yloc >= obs.y_bottom and yloc + yvel <= obs.y_bottom and xloc < obs.x_right and xloc + width > obs.x_left then
            collisions.top.exists = true
            collisions.top.correctloc = obs.y_bottom
            collisions.none = false
        end
    end
    print("Projected: " .. xloc + xvel .. " " .. yloc + yvel)
    return collisions
end