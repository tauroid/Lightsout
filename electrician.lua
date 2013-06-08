steph = {
    img_filename = 'steph_r1.png',
    x_loc = 0,
    y_loc = 0,
    x_vel = 0,
    y_vel = 0,
    jumping = false,
    moveLeft = false,
    moveRight = false
}

function steph.update()
    steph.doMovement()
end

function steph.doMovement()
    if moveLeft then
        steph.x_vel = steph.x_vel - 0.1
    end
    if moveRight then
        steph.x_vel = steph.x_vel + 0.1
    end
    
    -- Friction constant
    if moveLeft and moveRight then
        steph.x_vel = steph.x_vel * 0.8
    end
    
    if e.jumping then
        steph.y_vel = .01 + steph.y_vel
    end
    steph.x_loc = steph.x_vel + steph.x_loc
    steph.y_loc = steph.y_vel + steph.y_loc
end
    
        