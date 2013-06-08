require("animation")

steph = {
    animations = { walk = { name = "walk", currentFrame = 1, frames = {} },
                   idle = { name = "idle", currentFrame = 1, frames = {} },
                   eating = { name = "eating", currentFrame = 1, frames = {} } },
    curAnim = idle,
    x_loc = 50,
    y_loc = 100,
    x_vel = 0.5,
    y_vel = 0,
    jumping = false,
    movingLeft = false,
    movingRight = false,
    direction = 1,
    frameDelayms = 80,
    timeSinceLastFrame = 0,
}

function steph:initialise()
    Animation.generate("Animations/Walk",self.animations.walk.frames)
    Animation.generate("Animations/Idle_1",self.animations.idle.frames)
    Animation.generate("Animations/Eating_1",self.animations.eating.frames)
end

function steph:update(delta)
    self:doMovement()
    self.timeSinceLastFrame = self.timeSinceLastFrame + delta*1000
end

function steph:doMovement()
    if self.movingLeft and self.movingRight then
        -- Friction constant
        self.x_vel = self.x_vel * 0.8
        Animation.start(self.animations.idle.currentFrame)
        self.curAnim = self.animations.idle
    elseif not self.movingLeft and not self.movingRight then
        self.x_vel = self.x_vel * 0.8
        Animation.start(self.animations.idle.currentFrame)
        self.curAnim = self.animations.idle
    elseif self.movingLeft then
        self.x_vel = self.x_vel - 1
        self.direction = -1
        Animation.start(self.animations.walk.currentFrame)
        self.curAnim = self.animations.walk
    elseif self.movingRight then
        steph.x_vel = self.x_vel + 1
        self.direction = 1
        Animation.start(self.animations.walk.currentFrame)
        self.curAnim = self.animations.walk
    end
    
    -- Cap speed
    if self.x_vel >= 2 then
        self.x_vel = 2
    end
    if self.x_vel <= -2 then
        self.x_vel = -2
    end
    
    self.x_loc = self.x_vel + self.x_loc
    self.y_loc = self.y_vel + self.y_loc
end

function steph:moveLeft()
    self.movingLeft = true
end

function steph:moveRight()
    self.movingRight = true
end

function steph:jump()
    if not self.jumping then
        self.jumping = true
        self.y_vel = -5
    end
end

function steph:draw()
    if self.timeSinceLastFrame > self.frameDelayms then
        Animation.getFrame(self.curAnim,self)
        self.timeSinceLastFrame = 0
    end
    if self.frame ~= nil then
        love.graphics.draw(self.frame,self.x_loc,self.y_loc,0,self.direction*5,5,5.5)
    end
end
        