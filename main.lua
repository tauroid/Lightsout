require('electrician')
require('mainmenu')
require('level1')
require('level2')
require('level3')
require('hud')
require('window')
bgimage = { image = 0,
            filename = "Sunset.png",
            x_loc = 0,
            y_loc = 0,
            scale = 1.3}
score = 0
pixelsize = 5
thresholdintensity = 5
darken = .7
paused = false
g = .1
levelno = 1
levels = {level1, level2, level3}

function love.load()
    love.graphics.setMode(screen.width,screen.height)
    love.graphics.setCaption("Filament Failure")
    bgimage.image = love.graphics.newImage(bgimage.filename)
    bgimage.image:setFilter("nearest","nearest")
    definePixelShaders()
    mainmenu:initialise()
    level = mainmenu
    e = steph
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
    if not paused and level.leveltype == "level" then
        drawLevel()
    elseif level.leveltype == "mainmenu" then
        drawMainMenu()
    end
end

function love.update()
    if not paused and level.leveltype == "level" then
        updateLevel()
    elseif level.leveltype == "mainmenu" then
        level:update()
        if level.play then
            level.play = false
            levelno = 1
            enterGame()
            loadLevel(level1) 
        end
    end
end

function processInput(input)
    if level.leveltype == "level" then
        if input.intype == "key" then
            if input.keycode == "escape" then
                level = mainmenu
                levelno = 1
            end
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
            elseif input.pressed == 1 and (input.keycode == "s" or input.keycode == "down") then
                e:descend()
            elseif input.pressed == 1 and input.keycode == " " then
                e:startFixing()
            elseif input.pressed == 1 and input.keycode == "p" and not paused then
                paused = true
            elseif input.pressed == 1 and input.keycode == "p" and paused then
                paused = false
            end
        end
    end
end

function drawMainMenu()
    local mmbgimage = level.bgimage:getFrame()
    if mmbgimage ~= nil then
        love.graphics.draw(mmbgimage,0,0)
    end
    local pbimage = level.play_button:getFrame()
    if pbimage ~= nil then
        love.graphics.draw(pbimage,level.play_button.x_loc,level.play_button.y_loc)
    end
    local qbimage = level.quit_button:getFrame()
    if qbimage ~= nil then
        love.graphics.draw(qbimage,level.quit_button.x_loc,level.quit_button.y_loc)
    end
end

function enterGame()
    hud:initialise()
    e:initialise()
end

function loadLevel(thelevel)
    level = thelevel
    level:initialise(e)
    e.level = thelevel
end

function drawLevel()
    drawBackground()
    drawForeground(level)
    updateLitShader(level)
    drawProps(level)
    drawLights(level)
    esprite = e:getFrame()
    love.graphics.setPixelEffect(litShader)
    litShader:send("darken",.4)
    if esprite ~= nil then
        love.graphics.draw(esprite,
                        (e.x_loc*pixelsize-camera.x_loc)*camera.scale,
                        (e.y_loc*pixelsize-camera.y_loc)*camera.scale,
                        0,
                        e.direction*pixelsize*camera.scale,
                        pixelsize*camera.scale,5.5)
    end
    love.graphics.setPixelEffect()
    drawOverlays(level)
    drawHUD()
end

function updateLevel()
    if level.gameover then
        level = mainmenu
        levelno = 1
        return
    end
    if level.status == "panic" then hud.game_over = true end
    if level.nextlevel then
        print("going next")
        score = score + 50*levelno - 50*levelno*level.timetaken/level.panictime
        levelno = levelno + 1
        if levelno <= table.getn(levels) then
            print("going to level " .. levelno)
            hud:initialise()
            loadLevel(levels[levelno])
            return
        elseif levelno > table.getn(levels) then
            hud:initialise()
            levelno = 1
            loadLevel(levels[levelno])
            return
        end
    end
    local delta = love.timer.getDelta()
    level:update(delta)
    hud:update(delta,level.timetaken/level.panictime)
    e:update(delta)
    e:doPhysics()
    updateCamera()
end

function drawHUD()
    love.graphics.setPixelEffect()
    local image = hud:getFrame()
    if image ~= nil then
        love.graphics.draw(image,0,0,0,pixelsize)
    end
end

function drawBackground()
    love.graphics.setPixelEffect()
    if bgimage.image ~= nil then
        love.graphics.draw(bgimage.image,
                           bgimage.x_loc,
                           bgimage.y_loc,
                           0,pixelsize/bgimage.scale)
    end
end
function drawForeground(thelevel)
    darkenShader:send("darken",darken)
    love.graphics.setPixelEffect(darkenShader)
    if thelevel.fgimage.image ~= nil then
        love.graphics.draw(thelevel.fgimage.image,
                           (thelevel.fgimage.x_loc*pixelsize-camera.x_loc)*camera.scale,
                           (thelevel.fgimage.y_loc*pixelsize-camera.y_loc)*camera.scale,
                           0,pixelsize*camera.scale)
    end
    love.graphics.setPixelEffect()
end

function updateLitShader(thelevel)
    local lightsdetails = thelevel:getLightsDetails(thelevel.lights)
    lightsources = table.getn(lightsdetails)
    if lightsources <= 20 and lightsources > 0 then
        for k,v in pairs(lightsdetails) do
            v[1] = v[1] + 0.5
            v[2] = screen.height/pixelsize - v[2] - 0.5
        end
        litShader:send("lightsources",unpack(lightsdetails))
        litShader:send("numsources",lightsources)
    else
        litShader:send("numsources",0)
    end
    litShader:send("camera",{camera.x_loc,screen.height*(1-1/camera.scale)-camera.y_loc,camera.scale})
end

function drawProps(thelevel)
    local renderorder = {}
    for k,v in pairs(thelevel.props) do
        if v.z ~= nil then
            renderorder[v.z] = v
        end
    end
    local i = table.getn(renderorder) + 1
    for k,v in pairs(thelevel.props) do
        if v.z == nil then
            renderorder[i] = v
            i = i + 1
        end
    end

    for i=1,table.getn(renderorder) do
        local v = renderorder[i]
        if v.ignore_shading then
            love.graphics.setPixelEffect()
        elseif v.lit_up and lightsources > 0 then
            litShader:send("darken",darken)
            love.graphics.setPixelEffect(litShader)
        else
            darkenShader:send("darken",darken)
            love.graphics.setPixelEffect(darkenShader)
        end
        local image
        if v.animated then
            image = thelevel:getPropFrame(v)
        else
            image = v.image
        end
        if image ~= nil then
            love.graphics.draw(image,
                               (v.x_loc*pixelsize-camera.x_loc)*camera.scale,
                               (v.y_loc*pixelsize-camera.y_loc)*camera.scale,
                               0,pixelsize*camera.scale)
        end
    end
    love.graphics.setPixelEffect()
end

function drawLights(thelevel)
    for k,v in pairs(thelevel.lights) do
        if lightsources > 0 then
            litShader:send("darken",darken)
            love.graphics.setPixelEffect(litShader)
        else
            darkenShader:send("darken",darken)
            love.graphics.setPixelEffect(darkenShader)
        end
        if v.lit then
            if v.image_on ~= nil then
                love.graphics.draw(v.image_on,
                                  (v.x_loc*pixelsize-camera.x_loc)*camera.scale,
                                  (v.y_loc*pixelsize-camera.y_loc)*camera.scale,
                                  0,pixelsize*camera.scale)
            end
        else
            if v.image_off ~= nil then
                love.graphics.draw(v.image_off,
                                  (v.x_loc*pixelsize-camera.x_loc)*camera.scale,
                                  (v.y_loc*pixelsize-camera.y_loc)*camera.scale,
                                  0,pixelsize*camera.scale)
            end
        end
    end
    love.graphics.setPixelEffect()
end

function drawOverlays(thelevel)
    love.graphics.setPixelEffect(overlayShader)
    local renderorder = {}
    for k,v in pairs(thelevel.overlays) do
        if v.z ~= nil then
            renderorder[v.z] = v
        end
    end
    local i = table.getn(renderorder) + 1
    for k,v in pairs(thelevel.overlays) do
        if v.z == nil then
            renderorder[i] = v
            i = i + 1
        end
    end

    for i=1,table.getn(renderorder) do
        local v = renderorder[i]
        if v.fade then
            local distance = thelevel:getFadeDistance(e,v,v.faderange)
            overlayShader:send("distance",distance)
        else
            overlayShader:send("distance",1)
        end
        if v.image ~= nil then
            love.graphics.draw(v.image,
                               (v.img_x_loc*pixelsize-camera.x_loc)*camera.scale,
                               (v.img_y_loc*pixelsize-camera.y_loc)*camera.scale,
                               0,pixelsize*camera.scale)
        end
    end
    love.graphics.setPixelEffect()
end

function updateCamera()
    if e.x_loc*pixelsize < camera.x_loc + 2*screen.width/5/camera.scale then
        camera.x_loc = e.x_loc*pixelsize - 2*screen.width/5/camera.scale
    elseif (e.x_loc-e.x_offset+e.width)*pixelsize > camera.x_loc + 3*screen.width/5/camera.scale then
        camera.x_loc = (e.x_loc-e.x_offset+e.width)*pixelsize - 3*screen.width/5/camera.scale
    end
    if camera.x_loc <= 0 then camera.x_loc = 0 end
    if camera.x_loc >= screen.width - screen.width/camera.scale then
        camera.x_loc = screen.width - screen.width/camera.scale end
        
    if (e.y_loc-e.y_offset)*pixelsize < camera.y_loc + screen.height/3/camera.scale then
        camera.y_loc = (e.y_loc-e.y_offset)*pixelsize - screen.height/3/camera.scale
    elseif (e.y_loc-e.y_offset+e.height)*pixelsize > camera.y_loc + 2*screen.height/3/camera.scale then
        camera.y_loc = (e.y_loc-e.y_offset+e.height)*pixelsize - 2*screen.height/3/camera.scale
    end
    if camera.y_loc <= 0 then camera.y_loc = 0 end
    if camera.y_loc >= screen.height - screen.height/camera.scale then
        camera.y_loc = screen.height - screen.height/camera.scale end
end

function definePixelShaders()
    overlayShader = love.graphics.newPixelEffect [[
        extern number distance;
        extern number darken;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            vec4 pixel = Texel( texture, texture_coords );
            {pixel.a = distance*pixel.a;}
            {pixel.rgb = pixel.rgb - vec3(darken*pixel.r,darken*pixel.g,darken*pixel.b);}
            return pixel;
        }
    ]]
    darkenShader = love.graphics.newPixelEffect [[
        extern number darken;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            vec4 pixel = Texel( texture, texture_coords );
            {pixel.rgb = pixel.rgb - vec3(darken*pixel.r,darken*pixel.g,darken*pixel.b);}
            return pixel;
        }
    ]]
    -- (x,y,intensity)
    litShader = love.graphics.newPixelEffect [[
        extern vec3 lightsources[20];
        extern number numsources;
        extern number darken;
        extern vec3 camera;
        extern number pixelsize;
        extern number thresholdintensity;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            number distance;
            vec4 pixel = Texel( texture, texture_coords );
            vec2 pixel_location = vec2((pixel_coords.x/camera.z+camera.x)/pixelsize,(pixel_coords.y/camera.z+camera.y)/pixelsize);
            vec2 distance_vector;
            number light_level = 0;
            for(int i=0;i<numsources;++i)
            {
                distance_vector = pixel_location - vec2(lightsources[i].x,lightsources[i].y);
                distance = length(distance_vector);
                light_level = light_level + lightsources[i].z/.2/(distance+1);
            }
            if(light_level > thresholdintensity)
            {
                light_level = thresholdintensity;
            }
            {pixel.rgb = pixel.rgb - darken*(1-light_level/thresholdintensity)*pixel.rgb;}
            return pixel;
        }
    ]]
    overlayShader:send("distance",1)
    overlayShader:send("darken",darken)
    darkenShader:send("darken",darken)
    litShader:send("darken",darken)
    litShader:send("pixelsize",pixelsize)
    litShader:send("thresholdintensity",thresholdintensity)
end