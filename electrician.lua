require("animation")

steph = {
    animations = { walk = { name = "walk", currentFrame = 1, frames = {} },
                   jumping = { name = "jumping", currentFrame = 1, frames = {} },
                   idle = { name = "idle", currentFrame = 1, frames = {} },
                   idle2 = { name = "idle2", currentFrame = 1, frames = {} },
                   fixing = { name = "fixing", currentFrame = 1, frames = {} },
                   eating = { name = "eating", currentFrame = 1, frames = {} } },
    curAnim = 0,
    x_loc = 10,
    y_loc = 10,
    x_vel = 0.5,
    y_vel = 0,
    jumping = false,
    movingLeft = false,
    movingRight = false,
    stopped = false,
    fixing = false,
    fixtime = 3,
    timeSinceFixStart = 0,
    direction = 1,
    frameDelayms = 80,
    timeSinceLastFrame = 0,
    collision = {"none",0}
}

function steph:initialise()
    Animation.generate("Animations/Walk",self.animations.walk.frames)
    Animation.generate("Animations/Jumping_1",self.animations.jumping.frames)
    Animation.generate("Animations/Idle_1",self.animations.idle.frames)
    Animation.generate("Animations/Idle_2",self.animations.idle2.frames)
    Animation.generate("Animations/Fixing_1",self.animations.fixing.frames)
    Animation.generate("Animations/Eating1",self.animations.eating.frames)
    self.curAnim = self.animations.idle2
end

function steph:update(delta)
    if not self.fixing then
        self:doMovement()
    else
        self:continueFixing(delta)
    end
    
    local rand = math.random(4000)
    if self.curAnim.name == "idle2" and rand <= 10 then
        self.curAnim = self.animations.eating
        Animation.start(self.animations.eating)
    elseif self.curAnim.name == "idle2" and rand > 10 and rand <= 15 then
        self.curAnim = self.animations.idle
        Animation.start(self.animations.idle)
    end
    
    if self.curAnim.name == "idle" or self.curAnim.name == "eating" then
        if self.curAnim.currentFrame == table.getn(self.curAnim.frames) then
            self.curAnim = self.animations.idle2
        end
    end
    
    self.timeSinceLastFrame = self.timeSinceLastFrame + delta*1000
end

function steph:doMovement()
    if self.jumping then
        self.curAnim = self.animations.jumping
        if self.y_vel < 0 then self.curAnim.currentFrame = 1
        else self.curAnim.currentFrame = 2 end
    elseif self.movingLeft and self.movingRight then
        -- Friction constant
        self.x_vel = self.x_vel * 0.8
        self:stop()
    elseif not self.movingLeft and not self.movingRight then
        self.x_vel = self.x_vel * 0.8
        self:stop()
    elseif self.movingLeft then
        self.x_vel = self.x_vel - 1
        self.direction = -1
        self.curAnim = self.animations.walk
        self.stopped = false
    elseif self.movingRight then
        steph.x_vel = self.x_vel + 1
        self.direction = 1
        self.curAnim = self.animations.walk
        self.stopped = false
    end
    
    -- Cap speed
    if self.x_vel >= .4 then
        self.x_vel = .4
    end
    if self.x_vel <= -.4 then
        self.x_vel = -.4
    end
    
    self.x_loc = self.x_vel + self.x_loc
    self.y_loc = self.y_vel + self.y_loc
end

function steph:moveLeft()
    self.stopped = false
    self.movingLeft = true
    Animation.start(self.animations.walk)
end

function steph:moveRight()
    self.stopped = false
    self.movingRight = true
    Animation.start(self.animations.walk)
end

function steph:jump()
    if not self.jumping then
        self.jumping = true
        self.y_vel = -1
        Animation.start(self.animations.jumping)
    end
end

function steph:stop()
    if not self.stopped then
        print("Stopping")
        self.stopped = true
        Animation.start(self.animations.idle2)
        self.curAnim = self.animations.idle2
    end
end

function steph:getFrame()
    if self.timeSinceLastFrame > self.frameDelayms then
        Animation.getFrame(self.curAnim,self)
        self.timeSinceLastFrame = self.timeSinceLastFrame - self.frameDelayms
    end
    return self.frame
end

function steph:startFixing()
    if not self.fixing and not self.jumping then
        self.fixing = true
        Animation.start(self.animations.fixing)
        self.curAnim = self.animations.fixing
    end
end

function steph:continueFixing(delta)
    if self.timeSinceFixStart > self.fixtime then
        self.fixing = false
        self.timeSinceFixStart = 0
        self.curAnim = self.animations.idle2
        Animation.start(self.animations.idle2)
        return
    else
        self.timeSinceFixStart = self.timeSinceFixStart + delta
    end
    if self.fixtime - self.timeSinceFixStart < self.frameDelayms*9/1000 and self.fixtime - self.timeSinceFixStart > 0 then
        if self.curAnim.currentFrame < 16 then
            self.currentFrame = 16
            self.timeSinceFixStart = self.fixtime - self.frameDelayms*9/1000
        end
    elseif self.curAnim.currentFrame > 15 then self.curAnim.currentFrame = 10 end
end
    