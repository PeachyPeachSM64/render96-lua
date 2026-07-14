local version = require("/lib/version")
local o2oint = require("/lib/o2oint")
local r96lib = require("/lib/r96lib")
--local UvScroll = require("/lib/uv-scroll")
require("constants")

local _floor  = math.floor
local _abs    = math.abs
local _max    = math.max
local _min    = math.min
local _sqrt   = math.sqrt
local _random = math.random
local _sin    = math.sin
local _cos    = math.cos
local _lerp   = math.lerp
local _atan2  = math.atan2
local _pi     = math.pi

------------------------
-- Behavior functions --
------------------------

local YOSHI_RIDING_ACTIONS = {
    [ACT_YOSHI_RIDE_IDLE]    = true,
    [ACT_YOSHI_RIDE_WALK]    = true,
    [ACT_YOSHI_RIDE_JUMP]    = true,
    [ACT_YOSHI_RIDE_FLUTTER] = true,
    [ACT_YOSHI_RIDE_FALL]    = true,
}

---@param o Object
local function bhv_yoshi_rideable_render96_init(o)
    cur_obj_init_animation(0)
    o.oFlags = OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oGravity = -3
    o.oFriction = 1
    o.activeFlags = o.activeFlags | ACTIVE_FLAG_UNK9
    o.oAnimations = gObjectAnimations.yoshi_seg5_anims_05024100
    o.oHealth = 1
    o.oIntangibleTimer = 0
    o.oYoshiBlinkTimer = 0
    o.oYoshiIdleTimer = 0
    o.hitboxRadius = 50
    o.hitboxHeight = 40
end

---@param o Object
local function yoshi_update_blink(o)
    if o.oYoshiBlinkTimer ~= 0 then
        o.oYoshiBlinkTimer = o.oYoshiBlinkTimer - 1
    else
        o.oYoshiBlinkTimer = random_linear_offset(30, 60)
    end
    o.oAnimState = (o.oYoshiBlinkTimer <= 4) and 1 or 0
end

---@param o Object
local function bhv_yoshi_unridden(o)
    local player = nearest_mario_state_to_object(o)
    local dist = dist_between_objects(o, player.marioObj)

    o.oYoshiIdleTimer = o.oYoshiIdleTimer + 1
    r96lib.yoshi_run(o)
    if dist < 100 then r96lib.push_mario_out_of_object(player, o, 2) end

    if o.oYoshiIdleTimer >= 600 then
        spawn_mist_particles_with_sound(SOUND_OBJ_DYING_ENEMY1)
        obj_mark_for_deletion(o)
    end

    o.oInteractStatus = 0
    -- Mount check
    if not YOSHI_RIDING_ACTIONS[player.action] then
        local airborne = (player.action & ACT_FLAG_AIR) ~= 0
            and (player.action & ACT_FLAG_SWIMMING_OR_FLYING) == 0
            and player.vel.y <= 0
            and dist < 85
        if airborne then
            player.pos.x = o.oPosX
            player.pos.z = o.oPosZ
            player.faceAngle.y = o.oMoveAngleYaw
            cur_obj_play_sound_2(SOUND_GENERAL_YOSHI_TALK)
            player.interactObj = o
            player.usedObj = o
            player.riddenObj = o
            o.oAction = 1
            o.heldByPlayerIndex = player.playerIndex
            set_mario_action(player, ACT_YOSHI_RIDE_FALL, 0)
        end
    end
end

---@param o Object
local function bhv_yoshi_rideable_render96_loop(o)
    yoshi_update_blink(o)

    if o.oAction == 0 then
        cur_obj_init_animation(0)
        o.oForwardVel = 0
        return bhv_yoshi_unridden(o)
    elseif o.oAction == 2 then
        cur_obj_init_animation_with_accel_and_sound(1, 3)
        cur_obj_play_sound_at_anim_range(0, 15, SOUND_GENERAL_YOSHI_WALK)
        o.oForwardVel = 30
        return bhv_yoshi_unridden(o)
    elseif o.oAction == 1 then
        -- Ridden
        local rider = gMarioStates[o.heldByPlayerIndex]
        local animInfo = o.header.gfx.animInfo
        o.oYoshiIdleTimer = 0
        obj_copy_pos(o, rider.marioObj)
        --rider.marioObj.header.gfx.pos.y = rider.marioObj.header.gfx.pos.y - 30
        o.oMoveAngleYaw = rider.faceAngle.y
        o.oFaceAnglePitch = 0
        o.oFaceAngleRoll = 0

        local action = rider.action
        if action == ACT_YOSHI_RIDE_IDLE then
            smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_IDLE)
        elseif action == ACT_YOSHI_RIDE_WALK then
            --cur_obj_init_animation_with_accel_and_sound(1, _abs(rider.forwardVel) / 14)
            --if cur_obj_check_anim_frame(3) then
            --    play_sound(SOUND_GENERAL_YOSHI_WALK, m.marioObj.header.gfx.cameraToObject)
            --end
            --play_step_sound(m, 1, 2);
            smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_RUN)
            cur_obj_play_sound_at_anim_range(3, 9, SOUND_GENERAL_YOSHI_WALK)
        elseif action == ACT_YOSHI_RIDE_JUMP then
            if rider.vel.y >= -21 then
                smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_JUMP)
                if o.header.gfx.animInfo.animFrame >= 4 then
                    o.header.gfx.animInfo.animFrame = 4
                end
            else
                smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_JUMP_FALL)
            end
        elseif action == ACT_YOSHI_RIDE_FALL then
            smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_JUMP_FALL)
        elseif action == ACT_YOSHI_RIDE_FLUTTER then
            smlua_anim_util_set_animation(o, YOSHI_ANIM_RIDABLE_FLUTTER)
        else
            mario_stop_riding_object(rider)
        end

        if (o.oInteractStatus & INT_STATUS_STOP_RIDING) ~= 0 then
            o.heldByPlayerIndex = 0
            if rider.hurtCounter ~= 0 then
                cur_obj_play_sound_2(SOUND_GENERAL_YOSHI_TALK)
                o.oAction = 2
            else
                o.oAction = 0
            end
            o.oInteractStatus = 0
        end
        return
    end
end

id_bhvRender96YoshiRideable = hook_render96_behavior(nil, true, bhv_yoshi_rideable_render96_init, bhv_yoshi_rideable_render96_loop, OBJ_LIST_PUSHABLE)
