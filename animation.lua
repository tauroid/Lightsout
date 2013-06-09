Animation = {}

function Animation.generate(foldername,frames)
    local dir = love.filesystem.enumerate(foldername)
    local pics = {}
    local frameno = 0
    local framenumber = 0
    local nostart = 0
    local noend = 0
    for i=1,table.getn(dir) do
        nostart,noend = string.find(dir[i],"%d+")
        if nostart ~= nil then
            frameno = tonumber(string.sub(dir[i],nostart,noend))
        else
            frameno = 0
        end

        if string.find(dir[i],'png') and frameno > 0 then
            pics[tonumber(frameno)] = dir[i]
            if frameno > framenumber then framenumber = frameno end
        end
    end
    if framenumber > 0 then
        for i=1,framenumber do
            if pics[i] ~= nil then
                print(pics[i])
                frames[i] = love.graphics.newImage(foldername .. "/" .. pics[i])
                frames[i]:setFilter("nearest","nearest")
            end
        end
    end
end

function Animation.start(anim)
    anim.currentFrame = 1
end

function Animation.stop(anim)
    anim.currentFrame = 0
end

-- Steps the frame forwards
function Animation.getFrame(anim,frameowner)
    local previousFrame = anim.currentFrame
    if anim.currentFrame ~= 0 then
        anim.currentFrame = anim.currentFrame + 1
        if anim.currentFrame > table.getn(anim.frames) then
            anim.currentFrame = 1
        end
        frameowner.frame = anim.frames[previousFrame]
    end
end

function Animation.getFramebyNumber(anim,frameowner,number)
    frameowner.frame = anim.frames[number]
end