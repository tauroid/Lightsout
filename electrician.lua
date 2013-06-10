require("animation")

steph = {}

function steph:initialise()
    self.animations = { walk = { name = "walk", currentFrame = 1, frames = {} },
                   jumping = { name = "jumping", currentFrame = 1, frames = {} },
                   idle = { name = "idle", currentFrame = 1, frames = {} },
                   idle2 = { name = "idle2", currentFrame = 1, frames = {} },
                   fixing = { name = "fixing", currentFrame = 1, frames = {} },
                   eating = { name = "eating", currentFrame = 1, frames = {} },
                   climbing = { name = "climbing", currentFrame = 1, frames = {} },
                   descending = { name = "descending", currentFrame = 1, frames = {} }}
    self.curAnim = nil
    self.x_loc = 10
    self.y_loc = 10
    self.x_vel = 0
    self.y_vel = 0
    self.width = 5
    self.height = 15
    self.x_offset = 3
    self.y_offset = 5
    self.jumping = false
    self.climbing = false
    self.climbingDirection = 0
    self.climbingDestination = 0
    self.movingLeft = false
    self.movingRight = false
    self.stopped = false
    self.fixing = false
    self.fixtime = 3
    self.currentlight = nil
    self.timeSinceFixStart = 0
    self.direction = 1
    self.frameDelayms = 80
    self.timeSinceLastFrame = 0
    self.collisions = {}
    self.level = 0
    
    Animation.generate("Animations/Walk",self.animations.walk.frames)
    Animation.generate("Animations/Jumping_1",self.animations.jumping.frames)
    Animation.generate("Animations/Idle_1",self.animations.idle.frames)
    Animation.generate("Animations/Idle_2",self.animations.idle2.frames)
    Animation.generate("Animations/Fixing_1",self.animations.fixing.frames)
    Animation.generate("Animations/Eating1",self.animations.eating.frames)
    Animation.generate("Animations/Stairs_1",self.animations.climbing.frames)
    Animation.generate("Animations/Downstairs_1",self.animations.descending.frames)
    self.curAnim = self.animations.idle2
end

function steph:update(delta)
    if not self.fixing then
        self:doMovement()
    else
        self:continueFixing(delta)
    end
    
    local rand = math.random(4000)
    if self.curAnim.name == "idle2" and rand <= 5 then
        self.curAnim = self.animations.eating
        Animation.start(self.animations.eating)
    elseif self.curAnim.name == "idle2" and rand > 5 and rand <= 15 then
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
    elseif self.climbing then
        if self.climbingDirection == 1 then self.curAnim = self.animations.climbing
        elseif self.climbingDirection == -1 then self.curAnim = self.animations.descending end
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
end

function steph:doPhysics()
    if self.jumping then
        self.y_vel = self.y_vel + g
    end

    self.collisions = self.level:checkCollision(self.x_loc-self.width/2,self.y_loc+self.y_offset,self.x_vel,self.y_vel,self.width,self.height)
    if self.climbing then
        self.x_vel = 0
        self.y_vel = -self.climbingDirection*.5
        if self.climbingDirection == 1 and self.y_loc <= self.climbingDestination then self.climbing = false end
        if self.climbingDirection == -1 and self.y_loc + self.y_vel >= self.climbingDestination then self.climbing = false end
    else
        if self.collisions.bottom.exists then
            self.jumping = false
            self.y_loc = self.collisions.bottom.correctloc-self.y_offset
            self.y_vel = 0
        end
        if self.collisions.left.exists then
            self.x_vel = 0
            self.x_loc = self.collisions.left.correctloc+self.width/2
        end
        if self.collisions.right.exists then
            self.x_vel = 0
            self.x_loc = self.collisions.right.correctloc+self.width/2
        end
        if self.collisions.none then
            self.jumping = true
            self.stopped = false
        end
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
    if self.level.hasstairs and not self.climbing then
        local currentstairs
        local x_distance
        currentstairs, x_distance = unpack(self.level:getNearestStairs(self,self.level.stairs))
        if math.abs(x_distance) < 2 then
            self.x_loc = self.x_loc - x_distance
            self.climbing = true
            self.climbingDestination = currentstairs.y_loc - self.height - self.y_offset
            self.climbingDirection = 1
            Animation.start(self.animations.climbing)
        end
    end
    if not self.jumping and not self.climbing and not self.fixing then
        self.jumping = true
        self.y_vel = -1.2
        Animation.start(self.animations.jumping)
    end
end

function steph:descend()
    if self.level.hasstairs and not self.climbing then
        local currentstairs
        local x_distance
        currentstairs, x_distance = unpack(self.level:getNearestStairs(self,self.level.stairs))
        if math.abs(x_distance) < 2 then
            if self.y_loc < currentstairs.y_loc + currentstairs.height - self.height - self.y_offset then
                self.x_loc = self.x_loc - x_distance
                self.climbing = true
                self.climbingDestination = currentstairs.y_loc + currentstairs.height - self.height - self.y_offset -1
                self.climbingDirection = -1
                Animation.start(self.animations.descending)
            end
        end
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
    local distance
    local x_distance = 0
    currentlight, distance, x_distance = unpack(self.level:getNearestLight(self,self.level.lights))
    print("Distance: " ..  distance)
    if currentlight.lit == true or self.level.status == "panic" then return end
    if not self.fixing and not self.jumping and distance <= 8 then
        self.fixing = true
        if distance <= 0.5 then
            self.x_vel = 0
            Animation.start(self.animations.fixing)
            self.curAnim = self.animations.fixing
        else
            Animation.start(self.animations.walk)
            self.curAnim = self.animations.walk
            if x_distance >= 0 then
                self.x_vel = -.5
                direction = -1
            else
                self.x_vel = .5
                direction = 1
            end
        end
    end
end

function steph:continueFixing(delta)
    local lightdetails = self.level:getNearestLight(self,self.level.lights)
    local x_distance = lightdetails[3]
    if math.abs(x_distance) < 0.5 then
        if self.x_vel ~= 0 then
            self.x_vel = 0 
            self.x_loc = self.x_loc - x_distance
        end
        if self.curAnim.name ~= "fixing" then
            Animation.start(self.animations.fixing)
            self.curAnim = self.animations.fixing
        end
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
            if self.curAnim.currentFrame < 16 and self.curAnim.currentFrame > 2 then
                self.currentFrame = 16
                self.timeSinceFixStart = self.fixtime - self.frameDelayms*9/1000
                if self.level.status ~= "panic" then
                    self.level:fixLight(currentlight)
                end
            end
        elseif self.curAnim.currentFrame > 15 then self.curAnim.currentFrame = 10 end
    end
end
