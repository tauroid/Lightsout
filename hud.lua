require('animation')
hud = {}

function hud:initialise()
    self.canvas = nil
    self.panic_bar = { name = "panic_bar",
                      graphics = { folder = "HUD/Panic_Bar", currentFrame = 1, frames = {} },
                      x_loc = 8,
                      y_loc = 70,
                      paniclevel = 0 }
    self.gameover = { name = "gameover",
                      image = 0,
                      filename = "HUD/gameover.png",
                      x_loc = 25,
                      y_loc = 9,
                      scale = 3 }
    self.frameDelayms = 100
    self.timeSinceLastFrame = 0
    self.game_over = false
    Animation.generate(self.panic_bar.graphics.folder,self.panic_bar.graphics.frames)
    self.gameover.image = love.graphics.newImage(self.gameover.filename)
    self.gameover.image:setFilter("nearest","nearest")
    self.canvas = love.graphics.newCanvas(128,96)
end

function hud:update(delta,panic)
    self.panic_bar.paniclevel = panic

    self.timeSinceLastFrame = self.timeSinceLastFrame + delta*1000
end

function hud:getFrame()
    self.canvas:clear()
    love.graphics.setCanvas(self.canvas)
    self.canvas:setFilter("nearest","nearest")
    if self.game_over then
        self:gameOver()
    else
        self:inGame()
    end
    love.graphics.setCanvas()
    return self.canvas
end

function hud:inGame()
    local pb = self.panic_bar
    local newanimframe
    if self.timeSinceLastFrame > self.frameDelayms then newframe = true end
    if pb.paniclevel < 1 then
        pb.graphics.currentFrame = math.floor(self.panic_bar.paniclevel*(table.getn(self.panic_bar.graphics.frames)-6)) + 1
    elseif pb.graphics.currentFrame < table.getn(pb.graphics.frames) then
        if newframe then
            pb.graphics.currentFrame = pb.graphics.currentFrame + 1
        end
    end
    if newanimframe then
        self.timeSinceLastFrame = self.timeSinceLastFrame - self.frameDelayms
    end
    local frame = pb.graphics.frames[pb.graphics.currentFrame]
    if frame ~= nil then
        love.graphics.draw(frame,pb.x_loc,pb.y_loc)
    end
end

function hud:gameOver()
    if self.gameover.image ~= nil then
        love.graphics.draw(self.gameover.image,self.gameover.x_loc,self.gameover.y_loc,0,self.gameover.scale)
    end
end