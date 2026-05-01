

eyeStateCustom = {
    EYES_OPEN = 0,
    EYES_HALF_CLOSED = 1,
    EYES_CLOSED = 2,
    EYES_HALF_OPEN = 3,
    EYES_ANGRY = 4,
    EYES_HAPPY = 5,
    EYES_EXHAUSTED = 6,
    EYES_DEAD = 7,
    EYES_HURT = 8
}

faceStateCustom = {
    FACE_DEFAULT = 0,
    FACE_HAPPY = 3,
    FACE_ANGRY = 4,
    FACE_OPEN = 5
}

local blinkFrame = 1
local blinkTimer = 0

local sleepFrame = 1
local sleepTimer = 1

local longJumpTimer = 0
local gMarioBlinkAnimation = { 0, 1, 2, 1, 0, 1, 2, 1, 0}

function geo_switch_mario_face(node, matStackIndex)
    local m = gMarioStates[0]
    local switchCase = cast_graph_node(node) ---@type GraphNodeSwitchCase
    local marioAction = m.action
    local marioHurtCounter = m.hurtCounter
    local marioHealth = m.health

    switchCase.selectedCase = faceStateCustom.FACE_DEFAULT

    if marioAction == ACT_IDLE or
    marioAction == ACT_HOLD_IDLE or
    marioAction == ACT_HOLD_HEAVY_IDLE or
    marioAction == ACT_CRAWLING or
    marioAction == ACT_WALKING or
    marioAction == ACT_HOLD_WALKING or
    marioAction == ACT_HOLD_HEAVY_WALKING or
    marioAction == ACT_LONG_JUMP_LAND or
    marioAction == ACT_JUMP_LAND or
    marioAction == ACT_JUMP_LAND_STOP or
    marioAction == ACT_DOUBLE_JUMP_LAND or
    marioAction == ACT_DOUBLE_JUMP_LAND_STOP then
        longJumpTimer = 0
        switchCase.selectedCase = faceStateCustom.FACE_DEFAULT end
    
    if (marioAction & ACT_FLAG_ATTACKING) ~= 0 then switchCase.selectedCase = faceStateCustom.FACE_ANGRY end

    if (marioAction & ACT_FLAG_SWIMMING) ~= 0 then switchCase.selectedCase = faceStateCustom.FACE_DEFAULT end
    
    if marioAction == ACT_LONG_JUMP then
        longJumpTimer = longJumpTimer + 1
        if longJumpTimer < 15 then switchCase.selectedCase = faceStateCustom.FACE_HAPPY
        else switchCase.selectedCase = faceStateCustom.FACE_OPEN end
    end

    if marioAction == ACT_DOUBLE_JUMP or
    marioAction == ACT_TRIPLE_JUMP then
        switchCase.selectedCase = faceStateCustom.FACE_DEFAULT end

    if marioAction == ACT_DOUBLE_JUMP_LAND or
    marioAction == ACT_DOUBLE_JUMP_LAND_STOP then
        switchCase.selectedCase = faceStateCustom.FACE_DEFAULT end

    if marioAction == ACT_JUMP or
    marioAction == ACT_TRIPLE_JUMP_LAND or
    marioAction == ACT_TRIPLE_JUMP_LAND_STOP or
    marioAction == ACT_BACKFLIP_LAND or
    marioAction == ACT_BACKFLIP_LAND_STOP then
        switchCase.selectedCase = faceStateCustom.FACE_HAPPY end
    
    if marioAction == ACT_BURNING_GROUND or
    marioAction == ACT_BURNING_JUMP or
    marioAction == ACT_BURNING_FALL or
    marioAction == ACT_LAVA_BOOST or
    marioAction == ACT_LAVA_BOOST_LAND then
        switchCase.selectedCase = faceStateCustom.FACE_OPEN end 

    if marioAction == ACT_DEATH_EXIT or
    marioAction == ACT_DEATH_EXIT_LAND or
    marioAction == ACT_DEATH_ON_STOMACH or
    marioAction == ACT_DEATH_ON_BACK or
    marioAction == ACT_QUICKSAND_DEATH or
    marioAction == ACT_ELECTROCUTION or
    marioAction == ACT_SUFFOCATION then
        switchCase.selectedCase = faceStateCustom.FACE_DEFAULT end

    if marioAction == ACT_START_SLEEPING then
		switchCase.selectedCase = faceStateCustom.FACE_DEFAULT end

	if marioAction == ACT_SLEEPING then
        if sleepTimer % 3 == 0 then 
            switchCase.selectedCase = faceStateCustom.FACE_OPEN
        else switchCase.selectedCase = faceStateCustom.FACE_DEFAULT end
    end

    if marioAction ~= ACT_SLEEPING then sleepTimer = 0 end

    if marioHurtCounter ~= nil and marioHurtCounter > 0 then
        switchCase.selectedCase = faceStateCustom.FACE_ANGRY end

    if marioHealth ~= nil and marioHealth <= 0xFF then
        switchCase.selectedCase = faceStateCustom.FACE_ANGRY end

    if marioAction == ACT_PANTING then
        switchCase.selectedCase = faceStateCustom.FACE_OPEN end

end

function geo_switch_mario_eye_custom(node, matStackIndex)
    --local bodyState = geo_get_body_state()
    local m = gMarioStates[0]
    local switchCase = cast_graph_node(node) ---@type GraphNodeSwitchCase
    local marioAction = m.action
    local marioHurtCounter = m.hurtCounter
    local marioHealth = m.health

    blinkTimer = blinkTimer + 1

    if blinkFrame == 5 then
        if blinkTimer % 20 == 0 then
            blinkFrame = blinkFrame + 1
            blinkTimer = 0
        end
    elseif blinkFrame == 9 then
        if blinkTimer % 50 == 0 then 
            blinkFrame = 1
            blinkTimer = 0
        end
    elseif (blinkFrame < 5 and blinkFrame >= 1) or (blinkFrame < 9 and blinkFrame > 5) then
        if blinkTimer % 2 == 0 then 
            blinkFrame = blinkFrame + 1
        end
    end

    if marioAction ~= ACT_IDLE and 
    marioAction ~= ACT_HOLD_IDLE and
    marioAction ~= ACT_HOLD_HEAVY_IDLE and
    marioAction ~= ACT_JUMP_LAND and 
    marioAction ~= ACT_JUMP_LAND_STOP and 
    marioAction ~= ACT_DOUBLE_JUMP_LAND and 
    marioAction ~= ACT_DOUBLE_JUMP_LAND_STOP then
        blinkFrame = 1
        blinkTimer = 0
        switchCase.selectedCase = eyeStateCustom.EYES_OPEN end

    if marioAction == ACT_IDLE or
    marioAction == ACT_HOLD_IDLE or
    marioAction == ACT_HOLD_HEAVY_IDLE or
    marioAction == ACT_JUMP_LAND or
    marioAction == ACT_JUMP_LAND_STOP or
    marioAction == ACT_DOUBLE_JUMP_LAND or
    marioAction == ACT_DOUBLE_JUMP_LAND_STOP then
        switchCase.selectedCase = gMarioBlinkAnimation[blinkFrame] end

    if (marioAction & ACT_FLAG_ATTACKING) ~= 0 or
    (marioAction & ACT_FLAG_SWIMMING) ~= 0 then
        switchCase.selectedCase = eyeStateCustom.EYES_ANGRY end

    if marioAction == ACT_WALKING or
    marioAction == ACT_HOLD_WALKING or
    marioAction == ACT_HOLD_HEAVY_WALKING then
        local speed = 0
        if m.forwardVel ~= nil then
            speed = math.abs(m.forwardVel)
        end
        if speed < 16 then switchCase.selectedCase = eyeStateCustom.EYES_HALF_OPEN
        else switchCase.selectedCase = eyeStateCustom.EYES_OPEN end
    end

    if marioAction == ACT_START_SLEEPING then
		switchCase.selectedCase = eyeStateCustom.EYES_HALF_CLOSED end

	if marioAction == ACT_SLEEPING then
		switchCase.selectedCase = eyeStateCustom.EYES_CLOSED end

    if marioAction == ACT_CRAWLING then
        switchCase.selectedCase = eyeStateCustom.EYES_HALF_OPEN end

    if marioAction == ACT_JUMP or
    marioAction == ACT_DOUBLE_JUMP or
    marioAction == ACT_TRIPLE_JUMP or
    marioAction == ACT_TRIPLE_JUMP_LAND or
    marioAction == ACT_TRIPLE_JUMP_LAND_STOP or
    marioAction == ACT_BACKFLIP_LAND or
    marioAction == ACT_BACKFLIP_LAND_STOP then
        switchCase.selectedCase = eyeStateCustom.EYES_HAPPY end

    if marioAction == ACT_BURNING_GROUND or
    marioAction == ACT_BURNING_JUMP or
    marioAction == ACT_BURNING_FALL or
    marioAction == ACT_LAVA_BOOST or
    marioAction == ACT_LAVA_BOOST_LAND then
        switchCase.selectedCase = eyeStateCustom.EYES_DEAD end

    if marioAction == ACT_DEATH_EXIT or
    marioAction == ACT_DEATH_EXIT_LAND or
    marioAction == ACT_DEATH_ON_STOMACH or
    marioAction == ACT_DEATH_ON_BACK or
    marioAction == ACT_QUICKSAND_DEATH or
    marioAction == ACT_ELECTROCUTION or
    marioAction == ACT_SUFFOCATION then
        switchCase.selectedCase = eyeStateCustom.EYES_DEAD end

    if marioHurtCounter ~= nil and marioHurtCounter > 0 then
        switchCase.selectedCase = eyeStateCustom.EYES_HURT end

    if marioHealth ~= nil and marioHealth <= 0xFF then
        switchCase.selectedCase = eyeStateCustom.EYES_HURT end

    if marioAction == ACT_PANTING then
        switchCase.selectedCase = eyeStateCustom.EYES_EXHAUSTED end

end

