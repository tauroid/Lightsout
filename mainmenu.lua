require('animation')
require('window')

mainmenu = { bgimage = { animation = { name = "flicker", folder = "Main_menu/bgimage", currentFrame = 1, frames = {} }},
             play_button = { animation = { folder = "Main_menu/play", currentFrame = 1, frames = {} },
                             x_loc = 0,
                             y_loc = 0,
                             x_offset = 26,
                             y_offset = 16,
                             width = 0,
                             height = 0 },
             quit_button = { animation = { folder = "Main_menu/quit", currentFrame = 1, frames = {} },
                             x_loc = 0,
                             y_loc = 0,
                             x_offset = 36,
                             y_offset = 21,
                             width = 0,
                             height = 0 },
             leveltype = "mainmenu",
             play = false }


function mainmenu:initialise()
    self.music = love.audio.newSource("Music/Theme.ogg")
    love.audio.setVolume(1)
    self.music:setLooping(true)
    love.audio.play(self.music)
    Animation.generate(self.bgimage.animation.folder,self.bgimage.animation.frames)
    Animation.generate(self.play_button.animation.folder,self.play_button.animation.frames)
    if self.play_button.animation.frames[1] ~= nil then
        self.play_button.width = self.play_button.animation.frames[1]:getWidth()
        self.play_button.height = self.play_button.animation.frames[1]:getHeight()
    end
    self.play_button.x_loc = screen.width/2 - self.play_button.width/2
    self.play_button.y_loc = screen.height/2 - self.play_button.height/2 + 15
    Animation.generate(self.quit_button.animation.folder,self.quit_button.animation.frames)
    if self.quit_button.animation.frames[1] ~= nil then
        self.quit_button.width = self.quit_button.animation.frames[1]:getWidth()
        self.quit_button.height = self.quit_button.animation.frames[1]:getHeight()
    end
    self.quit_button.x_loc = screen.width/2 - self.quit_button.width/2
    self.quit_button.y_loc = 2*screen.height/3 - self.quit_button.height/2
end

function mainmenu:update()
    local ran = math.random(2000)
    local ran2 = math.random(5)
    if ran < 10 then
        self.bgimage.animation.currentFrame = ran2
    end
end

function mainmenu.bgimage:getFrame()
    return self.animation.frames[self.animation.currentFrame]
end

function mainmenu.play_button:getFrame()
    if love.mouse.getX() >= self.x_loc + self.x_offset and
       love.mouse.getX() <= self.x_loc + self.width - self.x_offset and
       love.mouse.getY() >= self.y_loc + self.y_offset and
       love.mouse.getY() <= self.y_loc + self.height - self.y_offset then
        if love.mouse.isDown("l") then
            mainmenu.play = true 
        end
        return self.animation.frames[2]
    else
        return self.animation.frames[1]
    end
end

function mainmenu.quit_button:getFrame()
    if love.mouse.getX() >= self.x_loc + self.x_offset and
       love.mouse.getX() <= self.x_loc + self.width - self.x_offset and
       love.mouse.getY() >= self.y_loc + self.y_offset and
       love.mouse.getY() <= self.y_loc + self.height - self.y_offset then
        if love.mouse.isDown("l") then love.event.quit() end
        return self.animation.frames[2]
    else
        return self.animation.frames[1]
    end
end