require("/constants")

local _floor  = math.floor
local _abs    = math.abs
local _min    = math.min
local _random = math.random
local _sin    = math.sin
local _pi     = math.pi

------------------------
-- Behavior functions --
------------------------

local MR_I_DEATH_THRESHOLD = 4 * _pi
local MR_I_FOV_THRESHOLD = degrees_to_sm64(30)
local MR_I_CIRCLE_MIN_DELTA = 200

local sMrIBlinkStates = { 0, 1, 2, 3, 4, 3, 2, 1, 0 }

---@param o Object
local function bhv_mr_i_render96_init(o)
    o.oFlags = (OBJ_FLAG_COMPUTE_ANGLE_TO_MARIO | OBJ_FLAG_COMPUTE_DIST_TO_MARIO | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE)
    o.oPosY = o.oPosY + 60

    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ

    local sMrIHitbox = get_temp_object_hitbox()
    sMrIHitbox.interactType      = INTERACT_DAMAGE
    sMrIHitbox.health            = 2
    sMrIHitbox.numLootCoins      = 5
    sMrIHitbox.damageOrCoinValue = 2
    sMrIHitbox.radius            = 80
    sMrIHitbox.height            = 150
    sMrIHitbox.hurtboxRadius     = 50
    sMrIHitbox.hurtboxHeight     = 100
    sMrIHitbox.downOffset        = 0
    obj_set_hitbox(o, sMrIHitbox)

    o.oIntangibleTimer  = 0
    o.oDrawingDistance  = 4000
    o.oDeathSound       = SOUND_OBJ_ENEMY_DEATH_HIGH
    o.oAction           = MR_I_IDLE
    o.oMrISize          = 2
    o.oSwitchState2     = 0
    o.oSwitchTimer1     = 0
    o.oMrIBlinkIndex    = 1
    o.oMrIDetectRadius  = 500
    o.oMrIDizzyTimer    = 0
    o.oMrIDizzyDuration = 120
    o.oMrITracking      = 0
    o.oMrILastAngle     = obj_angle_to_object(o, nearest_player_to_object(o))
    o.oMrIFireTimer     = 0
    o.oBehParams2ndByte = (o.oBehParams >> 16) & 0xFF

    if o.oBehParams2ndByte == 0x01 then
        o.oMrISize = 4
        o.oPosY = o.oPosY + 120
        o.oHomeY = o.oPosY
    end
    cur_obj_scale(o.oMrISize)
    obj_set_model_extended(o, E_MODEL_MR_I)
end

---@param o Object
---@param player Object
local function bhv_mr_i_render96_fire(o, player)
    local yaw   = o.oFaceAngleYaw
    local pitch = o.oFaceAnglePitch
    local speed = 25.0
    local spawnY = o.oPosY - 40
    local particle = nil

    if o.oBehParams2ndByte == 0x01 then
        spawnY = spawnY - 40
        particle = spawn_non_sync_object(id_bhvRender96MrIFireParticle, E_MODEL_BLUE_FLAME, o.oPosX, spawnY, o.oPosZ, nil)
    else
        particle = spawn_non_sync_object(id_bhvRender96MrIParticle, E_MODEL_PURPLE_MARBLE, o.oPosX, spawnY, o.oPosZ, nil)
    end
    if particle == nil then return end

    particle.oMoveAngleYaw   = yaw
    particle.oMoveAnglePitch = pitch
    particle.oForwardVel     = speed
    particle.oVelX           = speed * coss(pitch) * sins(yaw)
    particle.oVelY           = speed * sins(-pitch)
    particle.oVelZ           = speed * coss(pitch) * coss(yaw)

    cur_obj_play_sound_and_rumble_if_visible(SOUND_OBJ_MRI_SHOOT)
end

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_track(o, player, dist, angleToPlayer, angleDiff)
    if dist > o.oMrIDetectRadius or angleDiff > MR_I_FOV_THRESHOLD then
        o.oMrITracking = 0
        o.oMrILastAngle = angleToPlayer
        return
    end

    local delta = math.s16(angleToPlayer - o.oMrILastAngle)

    o.oMrILastAngle = angleToPlayer

    if _abs(delta) >= MR_I_CIRCLE_MIN_DELTA then
        o.oMrITracking = o.oMrITracking + _abs(delta) * (_pi / 32768.0)
    else
        o.oMrITracking = 0
    end
end

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_attack(o, player, dist, angleToPlayer, angleDiff)
    o.oFaceAngleYaw = angleToPlayer
    o.oFaceAnglePitch = _min(obj_pitch_to_object(o, player), 0)
    o.oMrIFireTimer = o.oMrIFireTimer + 1
    if o.oMrIFireTimer >= 100 then
        o.oSwitchTimer1 = o.oSwitchTimer1 - 1
        if o.oSwitchTimer1 <= 0 then
            o.oMrIBlinkIndex = o.oMrIBlinkIndex + 1
            if o.oMrIBlinkIndex > #sMrIBlinkStates then
                o.oMrIBlinkIndex = 1
                o.oMrIFireTimer = 0
            else
                o.oSwitchState2 = sMrIBlinkStates[o.oMrIBlinkIndex]
            end
            if o.oSwitchState2 == 4 then
                bhv_mr_i_render96_fire(o, player)
            end
            o.oSwitchTimer1 = 2
        end
    end

    bhv_mr_i_render96_track(o, player, dist, angleToPlayer, angleDiff)
    if o.oMrITracking >= MR_I_DEATH_THRESHOLD then
        o.oAction = MR_I_DIZZY
        o.oMrIDizzyTimer = 0
        o.oMrITracking = 0
        o.oSwitchState2 = 0
    end
    if dist > o.oMrIDetectRadius * 1.5 then
        o.oAction = MR_I_IDLE
        o.oMrITracking = 0
    end
end

---@param o Object
local function bhv_mr_i_render96_dizzy(o)
    local frames = o.oMrIDizzyDuration - o.oMrIDizzyTimer

    o.oMrIDizzyTimer = o.oMrIDizzyTimer + 1
    o.oFaceAngleYaw = (o.oFaceAngleYaw + 0x1500) & 0xFFFF
    o.oFaceAnglePitch = _floor(-0x4000 * _min(o.oMrIDizzyTimer / o.oMrIDizzyDuration, 1.0))

    if frames > 20 and frames % 15 == 0 then cur_obj_play_sound_and_rumble_if_visible(SOUND_OBJ2_MRI_SPINNING) end
    if frames == 15 then cur_obj_play_sound_and_rumble_if_visible(SOUND_OBJ_MRI_DEATH) end
    if frames <= 10 then cur_obj_scale(o.oMrISize + (0.5 - o.oMrISize) * (1.0 - (frames / 10.0))) end
    if frames > 10 then cur_obj_scale(o.oMrISize + _sin(o.oMrIDizzyTimer * 0.3) * 0.15) end

    if o.oMrIDizzyTimer >= o.oMrIDizzyDuration then o.oAction = MR_I_DEAD end
end

---@param o Object
local function bhv_mr_i_render96_dead(o)
    spawn_mist_particles()
    if o.oBehParams2ndByte == 0x01 then
        spawn_default_star(1370, 2000.0, -320.0)
    else
        cur_obj_spawn_loot_blue_coin()
    end
    obj_mark_for_deletion(o)
end

---@param o Object
---@param player Object
---@param dist number
---@param angleToPlayer integer
---@param angleDiff integer
local function bhv_mr_i_render96_idle(o, player, dist, angleToPlayer, angleDiff)
    o.oFaceAngleYaw = (o.oFaceAngleYaw - 0x100) & 0xFFFF
    o.oFaceAnglePitch = 0

    o.oSwitchTimer1 = o.oSwitchTimer1 - 1
    if o.oSwitchTimer1 <= 0 then
        o.oMrIBlinkIndex = o.oMrIBlinkIndex + 1
        if o.oMrIBlinkIndex > #sMrIBlinkStates then
            o.oMrIBlinkIndex = 1
            o.oSwitchTimer1 = _random(30, 100)
        else
            o.oSwitchState2 = sMrIBlinkStates[o.oMrIBlinkIndex]
            o.oSwitchTimer1 = 2
        end
    end

    if dist < o.oMrIDetectRadius and angleDiff < MR_I_FOV_THRESHOLD then
        o.oSwitchState2 = 0
        o.oAction = MR_I_ATTACK
        o.oMrIFireTimer = 0
    end
end

local sMrIActionStates = {
    bhv_mr_i_render96_idle,
    bhv_mr_i_render96_attack,
    bhv_mr_i_render96_dizzy,
    bhv_mr_i_render96_dead
}

---@param o Object
local function bhv_mr_i_render96_loop(o)
    local player = nearest_player_to_object(o)
    local dist   = dist_between_objects(o, player)
    local angleToPlayer = obj_angle_to_object(o, player)
    local angleDiff = abs_angle_diff(o.oFaceAngleYaw, angleToPlayer)
    sMrIActionStates[o.oAction + 1](o, player, dist, angleToPlayer, angleDiff)

    obj_squish_on_action_enter(o, 1, 0.15, -0.20, 0.15)

    o.oInteractStatus = 0
end

id_bhvRender96MrI = hook_render96_behavior(id_bhvMrI, true, bhv_mr_i_render96_init, bhv_mr_i_render96_loop)

---@param o Object
local function bhv_mr_i_render96_fire_particle_init(o)
    local sParticleHitbox = get_temp_object_hitbox()
    sParticleHitbox.interactType      = INTERACT_FLAME
    sParticleHitbox.downOffset        = 0
    sParticleHitbox.damageOrCoinValue = 2
    sParticleHitbox.health            = 1
    sParticleHitbox.numLootCoins      = 0
    sParticleHitbox.radius            = 100
    sParticleHitbox.height            = 100
    sParticleHitbox.hurtboxRadius     = 50
    sParticleHitbox.hurtboxHeight     = 50
    obj_set_hitbox(o, sParticleHitbox)

    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
    o.oDrawingDistance = 4000

    cur_obj_scale(6)
end

---@param o Object
local function bhv_mr_i_render96_fire_particle_loop(o)
    cur_obj_move_using_fvel_and_gravity()
    cur_obj_update_floor_and_walls()
    o.oAnimState = _floor(_random() * 10)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0
        or o.oTimer >= 101
        or (o.oMoveFlags & OBJ_MOVE_LANDED) ~= 0
        or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0
        or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0
        or (o.activeFlags & ACTIVE_FLAG_IN_DIFFERENT_ROOM) ~= 0 then
        spawn_mist_particles()
        obj_mark_for_deletion(o)
    end
    o.oInteractStatus = 0
end

id_bhvRender96MrIFireParticle = hook_render96_behavior(nil, false, bhv_mr_i_render96_fire_particle_init, bhv_mr_i_render96_fire_particle_loop, OBJ_LIST_GENACTOR, "MrIFireParticle")

---@param o Object
local function bhv_mr_i_render96_particle_init(o)
    local sParticleHitbox = get_temp_object_hitbox()
    sParticleHitbox.interactType      = INTERACT_DAMAGE
    sParticleHitbox.downOffset        = 0
    sParticleHitbox.damageOrCoinValue = 2
    sParticleHitbox.health            = 1
    sParticleHitbox.numLootCoins      = 0
    sParticleHitbox.radius            = 100
    sParticleHitbox.height            = 100
    sParticleHitbox.hurtboxRadius     = 50
    sParticleHitbox.hurtboxHeight     = 50
    obj_set_hitbox(o, sParticleHitbox)

    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_BILLBOARD
    o.oDrawingDistance = 4000

    cur_obj_scale(3)
end

---@param o Object
local function bhv_mr_i_render96_particle_loop(o)
    cur_obj_move_using_fvel_and_gravity()
    cur_obj_update_floor_and_walls()

    if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0
        or o.oTimer >= 101
        or (o.oMoveFlags & OBJ_MOVE_LANDED) ~= 0
        or (o.oMoveFlags & OBJ_MOVE_HIT_WALL) ~= 0
        or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0
        or (o.activeFlags & ACTIVE_FLAG_IN_DIFFERENT_ROOM) ~= 0 then
        spawn_mist_particles()
        obj_mark_for_deletion(o)
    end
    o.oInteractStatus = 0
end

id_bhvRender96MrIParticle = hook_render96_behavior(nil, false, bhv_mr_i_render96_particle_init, bhv_mr_i_render96_particle_loop, OBJ_LIST_GENACTOR, "MrIParticle")
