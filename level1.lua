require('animation')

level1 = { obstacles = { ground = { name = "ground",
                                    y_top = 70,
                                    y_bottom = 96,
                                    x_left = 0,
                                    x_right = 150,
                                    active = true},
                         leftside = { name = "leftside",
                                  y_top = 0,
                                  y_bottom = 96,
                                  x_left = -10,
                                  x_right = 0,
                                  active = true },
                         rightside = { name = "rightside",
                                  y_top = 0,
                                  y_bottom = 96,
                                  x_left = 150,
                                  x_right = 160,
                                  active = true },
                         rightdoor = { name = "rightdoor",
                                       y_top = 0,
                                       y_bottom = 96,
                                       x_left = 108,
                                       x_right = 110,
                                       active = true },
                         level_2_warp = { name = "level_2_warp",
                                          y_top = 0,
                                          y_bottom = 96,
                                          x_left = 135,
                                          x_right = 150,
                                          active = true,
                                          warpzone = true,
                                          warp = "level2" } },
           fgimage = { image = 0,
                       filename = "Level1/lv1housebackground.png",
                       x_loc = 0,
                       y_loc = 0 },
           overlays = { partitions = { name = "partitions",
                                       image = 0,
                                       filename = "Level1/lv1housepartitions.png",
                                       img_x_loc = 0,
                                       img_y_loc = 0,
                                       fade = false,
                                       z = 2
                                     },
                        rightdoor = { name = "rightdoor",
                                      image = 0,
                                      filename = "Level1/lv1rightdoor.png",
                                      img_x_loc = 0,
                                      img_y_loc = 0,
                                      x_loc = 108,
                                      y_loc = 50,
                                      width = 2,
                                      height = 19,
                                      fade = false,
                                      faderange = 12,
                                      z = 1
                                     },
                        housefront = { name = "housefront",
                                       image = 0,
                                       filename = "Level1/lv1housefg.png",
                                       img_x_loc = 0,
                                       img_y_loc = 0,
                                       x_loc = 22,
                                       y_loc = 42,
                                       width = 87,
                                       height = 29,
                                       fade = true,
                                       faderange = 7.5,
                                       z = 3
                                     }
                         },
           props = { lit_interior = { name = "lit_interior",
                                      animated = false,
                                      image = 0,
                                      filename = "Level1/lv1litinterior.png",
                                      x_loc = 0,
                                      y_loc = 0,
                                      lit_up = true,
                                      z = 1 },
                     lining = {       name = "lining",
                                      animated = false,
                                      image = 0,
                                      filename = "Level1/lv1houselining.png",
                                      x_loc = 0,
                                      y_loc = 0,
                                      lit_up = false,
                                      z = 2 },
                     skirtingboard = { name = "skirtingboard",
                                       animated = false,
                                       image = 0,
                                       filename = "Level1/lv1skirtingboard.png",
                                       x_loc = 0,
                                       y_loc = 0,
                                       lit_up = true,
                                       z = 3 },
                     grandmother = { name = "grandmother",
                                     animated = true,
                                     animations = { idle = { name = "idle", currentFrame = 1, folder = "Props/Granny/Idle", frames = {} },
                                                    intense = { name = "intense", currentFrame = 1, folder = "Props/Granny/Intense", frames = {} },
                                                    panic = { name = "panic", currentFrame = 1, folder = "Props/Granny/PANIC", frames = {} } },
                                     x_loc = 62,
                                     y_loc = 50,
                                     lit_up = true,
                                     timeSinceLastFrame = 0,
                                     frameDelayms = 160,
                                     curAnim = nil },
                     cat = { name = "cat",
                             animated = true,
                             animations = { idle = { name = "idle", currentFrame = 1, folder = "Props/Cat/Idle", frames = {} },
                                            intense = { name = "intense", currentFrame = 1, folder = "Props/Cat/Intense", frames = {} },
                                            panic = { name = "panic", currentFrame = 1, folder = "Props/Cat/PANIC", frames = {} } },
                             x_loc = 32,
                             y_loc = 50,
                             lit_up = true,
                             timeSinceLastFrame = 0,
                             frameDelayms = 120,
                             curAnim = nil },
                     wallclock = { name = "clock",
                                   animated = true,
                                   animations = { tick = { name = "tick", currentFrame = 1, folder = "Props/Clock", frames = {} } },
                                   x_loc = 50,
                                   y_loc = 48,
                                   lit_up = true,
                                   timeSinceLastFrame = 0,
                                   frameDelayms = 2000,
                                   curAnim = nil } },
           lights = { middle_room = { image_on = 0,
                                     image_off = 0,
                                     filename_on = "Props/Light.png",
                                     filename_off = "Props/Light_broken.png",
                                     x_loc = 61,
                                     y_loc = 42,
                                     width = 3,
                                     height = 10,
                                     lsource_x = 2,
                                     lsource_y = 9,
                                     intensity = 6,
                                     lit = false } },
           timetaken = 0,
           panictime = 15,
           status = "calm",
           nextlevel = false,
           leveltype = "level"}
                        
                       
function level1:initialise()
    self.fgimage.image = love.graphics.newImage(self.fgimage.filename)
    self.fgimage.image:setFilter("nearest","nearest")
    for k,v in pairs(self.overlays) do
        v.image = love.graphics.newImage(v.filename)
        v.image:setFilter("nearest","nearest")
    end
    for k,v in pairs(self.props) do
        if v.animated then
            for h,w in pairs(v.animations) do
                Animation.generate(w.folder,w.frames)
            end
        else
            v.image = love.graphics.newImage(v.filename)
            v.image:setFilter("nearest","nearest")
        end
    end
    for k,v in pairs(self.lights) do
        v.image_on = love.graphics.newImage(v.filename_on)
        v.image_off = love.graphics.newImage(v.filename_off)
        v.image_on:setFilter("nearest","nearest")
        v.image_off:setFilter("nearest","nearest")
    end
    -- Need manual initialisation of each prop animation
    self.props.grandmother.curAnim = self.props.grandmother.animations.idle
    self.props.wallclock.curAnim = self.props.wallclock.animations.tick
    self.props.cat.curAnim = self.props.cat.animations.idle
    -- Hurry the fuck up
    self.props.wallclock.timeSinceLastFrame = 2000
end

function level1:update(delta)
    if self.status ~= "fixed" and self.status ~= "panic" then
        self.timetaken = self.timetaken + delta
    end
    for k,v in pairs(self.props) do
        if v.animated then
            v.timeSinceLastFrame = v.timeSinceLastFrame + delta*1000
        end
    end
    if self.status == "calm" and self.timetaken/self.panictime >= 0.5 then
        self:setIntenseStatus()
        self.status = "intense"
    end
    if self.status == "intense" and self.timetaken/self.panictime >= 1 then
        self:setPanicStatus()
        self.status = "panic"
    end
    if self.status == "panic" and self.props.cat.curAnim.currentFrame == table.getn(self.props.cat.curAnim.frames) then
        Animation.stop(self.props.cat.curAnim)
    end
    if self.status == "panic" and self.props.grandmother.curAnim.currentFrame == table.getn(self.props.grandmother.curAnim.frames) then
        Animation.stop(self.props.grandmother.curAnim)
    end
end

function level1:setCalmStatus()
    self.props.cat.curAnim = self.props.cat.animations.idle
    Animation.start(self.props.cat.curAnim)
    self.props.grandmother.curAnim = self.props.grandmother.animations.idle
    Animation.start(self.props.grandmother.curAnim)
    self.props.grandmother.frameDelayms = 160
end
    
function level1:setIntenseStatus()
    self.props.cat.curAnim = self.props.cat.animations.intense
    Animation.start(self.props.cat.curAnim)
    self.props.grandmother.curAnim = self.props.grandmother.animations.intense
    Animation.start(self.props.grandmother.curAnim)
    self.props.grandmother.frameDelayms = 120
end

function level1:setPanicStatus()
    self.props.cat.curAnim = self.props.cat.animations.panic
    Animation.start(self.props.cat.curAnim)
    self.props.grandmother.curAnim = self.props.grandmother.animations.panic
    Animation.start(self.props.grandmother.curAnim)
end

function level1:getPropFrame(prop)
    if prop.timeSinceLastFrame > prop.frameDelayms then
        Animation.getFrame(prop.curAnim,prop)
        prop.timeSinceLastFrame = prop.timeSinceLastFrame - prop.frameDelayms
    end
    return prop.frame
end

function level1:checkCollision(xloc,yloc,xvel,yvel,width,height)
    local collisions = { invalid = false,
                         right = { exists = false, correctloc = 0 },
                         left = { exists = false, correctloc = 0 },
                         bottom = { exists = false, correctloc = 0 },
                         top = { exists = false, correctloc = 0 },
                         none = true
                       }
    obstable = self.obstacles
    for k,obs in pairs(obstable) do
        if obs.warpzone and obs.warp == "level2" then
            if xloc + width > obs.x_left and xloc < obs.x_right and yloc + height > obs.y_top and yloc < obs.y_bottom then
                self.next_level = true
                print("Level complete")
            end
        elseif obs.active then
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
    end
    --print("Projected: " .. xloc + xvel .. " " .. yloc + yvel)
    return collisions
end

function level1:getFadeDistance(player,rectobject,range)
    local distance
    if player.x_loc+player.width/2 < rectobject.x_loc then
        distance = (rectobject.x_loc - player.x_loc-player.width/2)/range
    elseif player.x_loc-player.width/2 > rectobject.x_loc + rectobject.width then
        distance = (player.x_loc-player.width/2 - rectobject.x_loc - rectobject.width)/range
    else distance = 0 end
    return distance
end

function level1:getNearestLight(player,lightslist)
    local distance = 1000
    local x_distance = 1000
    local light = {}
    local i = 1
    for k,v in pairs(lightslist) do
        local x_dist = player.x_loc - v.x_loc - v.lsource_x + 0.5
        local y_dist = player.y_loc - v.y_loc - v.lsource_y + 0.5
        local testdistance = math.sqrt(math.pow(x_dist,2) + math.pow(y_dist,2))
        if testdistance < distance then
            distance = testdistance
            x_distance = x_dist
            light = v
        end
        i = i + 1
    end
    return {light,distance,x_distance}
end

function level1:getLightsDetails(lightslist)
    local lightstable = {}
    local i = 1
    for k,v in pairs(lightslist) do
        if v.lit then
            lightstable[i] = {v.x_loc + v.lsource_x - 1, v.y_loc + v.lsource_y - 1, v.intensity}
            i = i + 1
        end
    end
    return lightstable
end

function level1:fixLight(light)
    light.lit = true
    self.obstacles.rightdoor.active = false
    self.overlays.rightdoor.fade = true
    self.status = "fixed"
    self:setCalmStatus()
end