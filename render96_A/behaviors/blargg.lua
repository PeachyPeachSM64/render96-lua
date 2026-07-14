require("constants")

local _floor = math.floor

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_blargg_render96_init(o)
    -- Hitbox
    local sBlaargHitbox = get_temp_object_hitbox()
    sBlaargHitbox.interactType      = INTERACT_FLAME
    sBlaargHitbox.downOffset        = 0
    sBlaargHitbox.damageOrCoinValue = 1
    sBlaargHitbox.health            = 0
    sBlaargHitbox.numLootCoins      = 0
    sBlaargHitbox.radius            = 300
    sBlaargHitbox.height            = 235
    sBlaargHitbox.hurtboxRadius     = 300
    sBlaargHitbox.hurtboxHeight     = 110

    o.oHomeX = o.oPosX
    o.oHomeZ = o.oPosZ
    o.oGravity = 4.0
    o.oFriction = 0.91
    o.oBuoyancy = 1.3
    o.oAnimations = gObjectAnimations.blargg_seg5_anims_0500616C
    -- drop to floor
    o.oPosY, o.oFloor = find_floor(o.oPosX, o.oPosY, o.oPosZ)
    o.oMoveFlags = (o.oMoveFlags | OBJ_MOVE_ON_GROUND)

    obj_set_hitbox(o, sBlaargHitbox)
    o.oAction = BLARGG_MODE_CHASE
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
end

---@param o Object
local function bhv_blargg_render96_check_mario_collision(o)
    if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
        cur_obj_play_sound_and_rumble_if_visible(SOUND_MOVING_LAVA_BURN)
        o.oInteractStatus = o.oInteractStatus & (~INT_STATUS_INTERACTED)
        o.oAction = BLARGG_MODE_KNOCKBACK
        o.oFlags = o.oFlags & ~OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
        cur_obj_init_animation(BLARGG_ANIM_ATK)
        o.oBullyMarioCollisionAngle = o.oMoveAngleYaw
    end
end

---@param o Object
local function bhv_blargg_render96_swim(o)
    o.oForwardVel = 5.0
    if obj_return_home_if_safe(o, o.oHomeX, o.oHomeY, o.oHomeZ, 1000) == 1 then
        if m.floor.type == SURFACE_BURNING then
            o.oAction = BLARGG_MODE_CHASE
        else
            o.oAction = BLARGG_MODE_SWIM
       end
        cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_chase(o)
    local homeX = o.oHomeX
    local posY  = o.oPosY
    local homeZ = o.oHomeZ

    o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
    o.oMoveAngleYaw = o.oFaceAngleYaw

    obj_turn_toward_object(o, m.marioObj, 16, 0x2000)

    if m.riddenObj == nil then o.oForwardVel = 10 else o.oForwardVel = 20 end

    if not is_point_within_radius_of_mario(homeX, posY, homeZ, 5000) or m.floor.type == 0 or posY < o.oPosY then
        o.oAction = BLARGG_MODE_SWIM
        cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_knockback(o)
    if o.oForwardVel < 10.0 and _floor(o.oVelY) == 0 then
        o.oForwardVel = 1.0
        o.oBullyKBTimerAndMinionKOCounter = o.oBullyKBTimerAndMinionKOCounter + 1
        o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
        o.oMoveAngleYaw = o.oFaceAngleYaw
        obj_turn_toward_object(o, m.marioObj, 16, 0x2000)
    end
    if cur_obj_check_anim_frame(26) ~= 0 then
        cur_obj_play_sound_if_visible(SOUND_OBJ2_PIRANHA_PLANT_BITE)
    end
    if cur_obj_check_if_near_animation_end() ~= 0 then
        o.oAction = BLARGG_MODE_SWIM
        cur_obj_init_animation(BLARGG_ANIM_SWIM)
    end
end

---@param o Object
local function bhv_blargg_render96_backup(o)
    if o.oTimer == 0 then
        o.oFlags = o.oFlags & ~OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
        o.oMoveAngleYaw = o.oMoveAngleYaw + 0x8000
    end

    o.oForwardVel = 5.0

    if o.oTimer == 15 then
        o.oMoveAngleYaw = o.oFaceAngleYaw
        o.oFlags = o.oFlags | OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW
        o.oAction = BLARGG_MODE_SWIM
    end
end

---@param o Object
local function bhv_blargg_render96_backup_check(o, collisionFlags)
    if (collisionFlags & OBJ_COL_FLAG_NO_Y_VEL) == 0 and o.oAction ~= BLARGG_MODE_KNOCKBACK then
        o.oPosX = o.oBullyPrevX
        o.oPosZ = o.oBullyPrevZ
        o.oAction = BLARGG_MODE_BACKUP
    end
end

---@param o Object
local function bhv_blargg_render96_step(o)
    local collisionFlags = object_step()
    bhv_blargg_render96_backup_check(o, collisionFlags)
end

---@param o Object
local function bhv_blargg_render96_loop(o)
    o.oBullyPrevX = o.oPosX
    o.oBullyPrevY = o.oPosY
    o.oBullyPrevZ = o.oPosZ

    bhv_blargg_render96_check_mario_collision(o)
    spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
    if o.oAction == BLARGG_MODE_SWIM then
        bhv_blargg_render96_swim(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_CHASE then
        bhv_blargg_render96_chase(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_KNOCKBACK then
        bhv_blargg_render96_knockback(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BLARGG_MODE_BACKUP then
        o.oForwardVel = 10.0
        bhv_blargg_render96_backup(o)
        bhv_blargg_render96_step(o)

    elseif o.oAction == BULLY_ACT_DEATH_PLANE_DEATH then
        o.activeFlags = 0
    end

    set_object_visibility(o, 3000)
end

id_bhvRender96Blargg = hook_render96_behavior(nil, true, bhv_blargg_render96_init, bhv_blargg_render96_loop, OBJ_LIST_GENACTOR, "Blargg")
