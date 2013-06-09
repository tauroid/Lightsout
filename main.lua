require('electrician')
require('level1')
screen = { width = 640,
           height = 480 }
camera = { x_loc = 0,
           y_loc = 0,
           scale = 1.2 }
bgimage = { image = 0,
            filename = "Sunset.png",
            x_loc = 0,
            y_loc = 0,
            scale = 1.3}
pixelsize = 5
thresholdintensity = 5
paused = false
g = .1

function love.load()
    love.graphics.setMode(screen.width,screen.height)
    love.graphics.setCaption("Filament Failure")
    bgimage.image = love.graphics.newImage(bgimage.filename)
    bgimage.image:setFilter("nearest","nearest")
    definePixelShaders()
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
    if not paused then
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
        drawLevelOverlays(level)
    end
end

function love.update()
    if not paused then
        local delta = love.timer.getDelta()
        level:update(delta)
        e:update(delta)
        e:doPhysics()
        updateCamera()
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
    darkenShader:send("darken",.7)
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
    for k,v in pairs(thelevel.props) do
        if v.ignore_shading then
            love.graphics.setPixelEffect()
        elseif v.lit_up and lightsources > 0 then
            litShader:send("darken",.7)
            love.graphics.setPixelEffect(litShader)
        else
            darkenShader:send("darken",.7)
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
            litShader:send("darken",.7)
            love.graphics.setPixelEffect(litShader)
        else
            darkenShader:send("darken",.7)
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

function drawLevelOverlays(thelevel)
    love.graphics.setPixelEffect(overlayShader)
    for k,v in pairs(thelevel.overlays) do
        if v.fade then
            local distance = thelevel:getFadeDistance(e,v,7.5)
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
    overlayShader:send("darken",.7)
    darkenShader:send("darken",.7)
    litShader:send("darken",.7)
    litShader:send("pixelsize",pixelsize)
    litShader:send("thresholdintensity",thresholdintensity)
end