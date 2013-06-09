require('animation')

level3 = {}
           
function level3:initialise(player)
    self.obstacles = { ground = { name = "ground",
                                    y_top = 70,
                                    y_bottom = 96,
                                    x_left = 0,
                                    x_right = 150,
                                    active = true },
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
                         atticfloor = { name = "atticfloor",
                                       y_top = 39,
                                       y_bottom = 41,
                                       x_left = 15,
                                       x_right = 111,
                                       active = true },
                         attic_left = { name = "attic_left",
                                        y_top = 0,
                                        y_bottom = 39,
                                        x_left = 14,
                                        x_right = 26,
                                        active = true },
                         attic_right = { name = "attic_right",
                                        y_top = 0,
                                        y_bottom = 39,
                                        x_left = 99,
                                        x_right = 120,
                                        active = true },
                         main_menu_warp = { name = "main_menu_warp",
                                          y_top = 0,
                                          y_bottom = 96,
                                          x_left = 135,
                                          x_right = 150,
                                          active = true,
                                          warpzone = true }
                          }
    self.fgimage = { image = 0,
                       filename = "Level2/lv2fg.png",
                       x_loc = 0,
                       y_loc = 0 }
    self.overlays = { partitions = { name = "partitions",
                                       image = 0,
                                       filename = "Level3/lv3partitions.png",
                                       img_x_loc = 0,
                                       img_y_loc = 0,
                                       fade = false,
                                       z = 2
                                     },
                        rightdoor = { name = "rightdoor",
                                      image = 0,
                                      filename = "Level3/lv3rightdoor.png",
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
                        overhang = { name = "overhang",
                                       image = 0,
                                       filename = "Level3/lv3stairoverhang.png",
                                       img_x_loc = 0,
                                       img_y_loc = 0,
                                       fade = false,
                                       z = 3
                                     },
                        housefront = { name = "housefront",
                                       image = 0,
                                       filename = "Level3/lv3gfloorcutaway.png",
                                       img_x_loc = 0,
                                       img_y_loc = 0,
                                       x_loc = 22,
                                       y_loc = 42,
                                       width = 87,
                                       height = 29,
                                       fade = true,
                                       faderange = 7.5,
                                       z = 4
                                     },
                        rooffront = { name = "rooffront",
                                      image = 0,
                                      filename = "Level3/lv3roofcutaway.png",
                                      img_x_loc = 0,
                                      img_y_loc = 0,
                                      x_loc = 14,
                                      y_loc = 17,
                                      width = 97,
                                      height = 25,
                                      fade = true,
                                      faderange = 7.5,
                                      z = 5
                                    } }
    self.props = { lit_ground_interior = { name = "lit_ground_interior",
                                      animated = false,
                                      image = 0,
                                      filename = "Level3/lv3groundinterior.png",
                                      x_loc = 0,
                                      y_loc = 0,
                                      lit_up = true,
                                      z = 1 },
                     lining = {       name = "lining",
                                      animated = false,
                                      image = 0,
                                      filename = "Level3/lv3unlitlining.png",
                                      x_loc = 0,
                                      y_loc = 0,
                                      lit_up = false,
                                      z = 2 },
                     atticinterior = {name = "atticinterior",
                                      animated = false,
                                      image = 0,
                                      filename = "Level3/lv3atticinterior.png",
                                      x_loc = 0,
                                      y_loc = 0,
                                      lit_up = true,
                                      z = 3 },
                     stairs = { name = "stairs",
                                animated = false,
                                image = 0,
                                filename = "Level3/lv3stairs.png",
                                x_loc = 0,
                                y_loc = 0,
                                lit_up = false,
                                z = 5 },
                     skirtingboard = { name = "skirtingboard",
                                       animated = false,
                                       image = 0,
                                       filename = "Level3/lv3skboard.png",
                                       x_loc = 0,
                                       y_loc = 0,
                                       lit_up = true,
                                       z = 4 },
                     attic_hatch = { name = "attic_hatch",
                                       animated = false,
                                       image = 0,
                                       filename = "Level3/lv3attichatch.png",
                                       x_loc = 0,
                                       y_loc = 0,
                                       lit_up = true },
                     dragon_painting = { name = "dragon_painting",
                                         animated = false,
                                         image = 0,
                                         filename = "Level3/lv3dragonpainting.png",
                                         x_loc = 0,
                                         y_loc = 0,
                                         lit_up = true },
                     kids = { name = "kids",
                                     animated = true,
                                     animations = { idle = { name = "idle", currentFrame = 1, folder = "Props/Children", frames = {} } },
                                     x_loc = 30,
                                     y_loc = 59,
                                     lit_up = true,
                                     timeSinceLastFrame = 0,
                                     frameDelayms = 120,
                                     curAnim = nil,
                                     z = 7 },
                     father = { name = "father",
                                     animated = true,
                                     animations = { idle = { name = "idle", currentFrame = 1, folder = "Props/Father/Idle", frames = {} },
                                                    intense = { name = "intense", currentFrame = 1, folder = "Props/Father/Intense", frames = {} },
                                                    panic = { name = "panic", currentFrame = 1, folder = "Props/Father/PANIC", frames = {} }},
                                     x_loc = 43,
                                     y_loc = 50,
                                     lit_up = true,
                                     timeSinceLastFrame = 0,
                                     frameDelayms = 160,
                                     curAnim = nil,
                                     z = 6 } }
    self.lights = { left_room = {   name = "left_room",
                                    image_on = 0,
                                    image_off = 0,
                                    filename_on = "Props/Light.png",
                                    filename_off = "Props/Light_broken.png",
                                    x_loc = 87,
                                    y_loc = 42,
                                    width = 3,
                                    height = 10,
                                    lsource_x = 2,
                                    lsource_y = 9,
                                    intensity = 8,
                                    lit = false },
                    attic = {   name = "left_room",
                                    image_on = 0,
                                    image_off = 0,
                                    filename_on = "Props/Light_short.png",
                                    filename_off = "Props/Light_broken_short.png",
                                    x_loc = 45,
                                    y_loc = 18,
                                    width = 3,
                                    height = 6,
                                    lsource_x = 2,
                                    lsource_y = 5,
                                    intensity = 6,
                                    lit = false }
                    }
    self.stairs = { stairs1 = { name = "stairs1",
                                x_loc = 56,
                                y_loc = 44,
                                width = 16,
                                height = 26 } }
    self.timetaken = 0
    self.panictime = 14
    self.status = "calm"
    self.nextlevel = false
    self.leveltype = "level"
    self.hasstairs = true
    self.gameover = false

    player.x_vel = 0 player.y_vel = 0
    player.x_loc = 5 player.y_loc = 50
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
    
    self.props.kids.curAnim = self.props.kids.animations.idle
    self.props.father.curAnim = self.props.father.animations.idle
end

function level3:update(delta)
    if self.status ~= "fixed" and self.timetaken < self.panictime + 6 then
        self.timetaken = self.timetaken + delta
    elseif self.timetaken >= self.panictime + 6 then
        self.gameover = true
    end
    -- Level specific
    if self.lights.left_room.breaking then 
        self.lights.left_room.breaktimer = self.lights.left_room.breaktimer + delta
        if self.lights.left_room.breaktimer > self.lights.left_room.timeOfBreaking then
            self.lights.left_room.lit = false
            self.lights.left_room.breaking = false
            self.status = "calm"
        end
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
    
    if self.status == "panic" and self.props.father.curAnim.currentFrame == table.getn(self.props.father.curAnim.frames) then
        Animation.stop(self.props.father.curAnim)
    end
end

function level3:setCalmStatus()
    Animation.start(self.props.father.curAnim)
    self.props.father.curAnim = self.props.father.animations.idle
end
    
function level3:setIntenseStatus()
    self.props.father.curAnim = self.props.father.animations.intense
    Animation.start(self.props.father.curAnim)
end

function level3:setPanicStatus()
    self.props.father.curAnim = self.props.father.animations.panic
    Animation.start(self.props.father.curAnim)
end

function level3:checkCollision(xloc,yloc,xvel,yvel,width,height)
    local collisions = { invalid = false,
                         right = { exists = false, correctloc = 0 },
                         left = { exists = false, correctloc = 0 },
                         bottom = { exists = false, correctloc = 0 },
                         top = { exists = false, correctloc = 0 },
                         none = true
                       }
    obstable = self.obstacles
    for k,obs in pairs(obstable) do
        if obs.warpzone then
            if xloc + width > obs.x_left and xloc < obs.x_right and yloc + height > obs.y_top and yloc < obs.y_bottom then
                self.nextlevel = true
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

function level3:getPropFrame(prop)
    if prop.timeSinceLastFrame > prop.frameDelayms then
        Animation.getFrame(prop.curAnim,prop)
        prop.timeSinceLastFrame = prop.timeSinceLastFrame - prop.frameDelayms
    end
    return prop.frame
end

function level3:getFadeDistance(player,rectobject,range)
    local distance_x
    local distance_y
    
    if player.x_loc+player.width/2 < rectobject.x_loc then
        distance_x = (rectobject.x_loc - player.x_loc-player.width/2)/range
    elseif player.x_loc-player.width/2 > rectobject.x_loc + rectobject.width then
        distance_x = (player.x_loc-player.width/2 - rectobject.x_loc - rectobject.width)/range
    else distance_x = 0 end
    
    if player.y_loc+player.height/2+player.y_offset < rectobject.y_loc then
        distance_y = (rectobject.y_loc - player.y_loc-player.height/2-player.y_offset)/range
    elseif player.y_loc+player.height/2+player.y_offset > rectobject.y_loc + rectobject.height then
        distance_y = (player.y_loc+player.height/2+player.y_offset - rectobject.y_loc - rectobject.height)/range
    else distance_y = 0 end
    return distance_x + distance_y
end

function level3:getNearestLight(player,lightslist)
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

function level3:getNearestStairs(player,stairslist)
    local x_distance = 1000
    local stairs = {}
    for k,v in pairs(stairslist) do
        local x_dist = player.x_loc - v.x_loc - v.width/2 + 0.5
        if x_dist < x_distance then
            x_distance = x_dist
            stairs = v
        end
    end
    return {stairs,x_distance}
end

function level3:getLightsDetails(lightslist)
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

function level3:fixLight(light)
    light.lit = true
    if self.lights.left_room.lit and self.lights.attic.lit then
        self.obstacles.rightdoor.active = false
        self.overlays.rightdoor.fade = true
        self.status = "fixed"
        self:setCalmStatus()
    end
end