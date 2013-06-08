steph = {
    img_filename = 'Right_Walk/steph_r1.png',
    x_loc = 0,
    y_loc = 0,
    x_vel = 0.5,
    y_vel = 0,
    jumping = false,
    moveLeft = false,
    moveRight = false
}

function steph.update()
    steph.doMovement()
end

function steph.doMovement()
    if steph.moveLeft then
        steph.x_vel = steph.x_vel - 1
    end
    if steph.moveRight then
        steph.x_vel = steph.x_vel + 1
    end
    
    -- Friction constant
    if steph.moveLeft and steph.moveRight then
        steph.x_vel = steph.x_vel * 0.8
    end
    if not steph.moveLeft and not steph.moveRight then
        steph.x_vel = steph.x_vel * 0.8
    end
    
    -- Cap speed
    if steph.x_vel >= 2 then
        steph.x_vel = 2
    end
    if steph.x_vel <= -2 then
        steph.x_vel = -2
    end
    if e.jumping then
        steph.y_vel = .01 + steph.y_vel
    end
    steph.x_loc = steph.x_vel + steph.x_loc
    steph.y_loc = steph.y_vel + steph.y_loc
end
    
        