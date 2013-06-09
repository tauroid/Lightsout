require('electrician')
require('level1')
screen = { width = 640,
           height = 480 }
camera = { x_loc = 0,
           y_loc = 0,
           scale = 1.2 }
pixelsize = 5
paused = false
g = .1

function love.load()
    love.graphics.setMode(screen.width,screen.height)
    love.graphics.setCaption("Filament Failure")
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
    foregroundShader = love.graphics.newPixelEffect [[
        extern number darken;
        vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 pixel_coords)
        {
            vec4 pixel = Texel( texture, texture_coords );
            {pixel.rgb = pixel.rgb - vec3(darken*pixel.r,darken*pixel.g,darken*pixel.b);}
            return pixel;
        }
    ]]
    overlayShader:send("distance",1)
    overlayShader:send("darken",.7)
    foregroundShader:send("darken",.7)
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
    drawLevelForeground(level)
    esprite = e:getFrame()
    love.graphics.setPixelEffect(foregroundShader)
    foregroundShader:send("darken",.4)
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

function love.update()
    if not paused then
        e:update(love.timer.getDelta())
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

function drawLevelForeground(thelevel)
    foregroundShader:send("darken",.7)
    love.graphics.setPixelEffect(foregroundShader)
    if thelevel.fgimage.image ~= nil then
        love.graphics.draw(thelevel.fgimage.image,
                           (thelevel.fgimage.x_loc-camera.x_loc)*camera.scale,
                           (thelevel.fgimage.y_loc-camera.y_loc)*camera.scale,
                           0,pixelsize*camera.scale)
    end
    love.graphics.setPixelEffect()
end

function drawLevelOverlays(thelevel)
    love.graphics.setPixelEffect(overlayShader)
    for k,v in pairs(thelevel.overlays) do
        if v.fade then
            local distance = thelevel:getDistance(e,v,7.5)
            overlayShader:send("distance",distance)
        else
            overlayShader:send("distance",1)
        end
        if v.image ~= nil then
            love.graphics.draw(v.image,
                               (v.img_x_loc-camera.x_loc)*camera.scale,
                               (v.img_y_loc-camera.y_loc)*camera.scale,
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