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

---@param o Object
local function bhv_goomba_render96_init(o)
    o.oSwitchState2 = 0
    o.oSwitchState1 = 0
    o.oSwitchTimer1 = 0
    o.oSwitchTimer2 = 0
end

---@param o Object
local function bhv_goomba_render96_death(o)
    spawn_mist_particles()
    obj_spawn_yellow_coins(o, o.oNumLootCoins)
    create_sound_spawner(SOUND_OBJ_STOMPED)
    obj_mark_for_deletion(o)
end

local GOOMBA_OPTS = {
    audio = EVENT_THROWN,
    interactions = gThrownInteractions,
    enemy = true
}

local sGoombaWarioDeath = {
    [ACT_WARIO_GROUND_POUND] = true,
    [ACT_GROUND_POUND_LAND] = true,
    [ACT_WARIO_PILE_DRIVER] = true,
    [ACT_WARIO_PILE_DRIVER_LAND] = true,
    [ACT_WARIO_CHARGE] = true,
}

---@param o Object
local function bhv_goomba_render96_loop(o)
    obj_update_eye_blink(o, 3, 8, 30, 100)

    o.oSwitchState2 = 0
    
    if o.oAction == GOOMBA_ACT_JUMP then
        o.oSwitchState1 = 0
        o.oSwitchTimer1 = 0
        o.oSwitchState2 = 1
    end

    if get_character(m).type == CT_WARIO then
        if o.oAction == OBJ_ACT_SQUISHED then
            if not sGoombaWarioDeath[m.action] then
                set_mario_particle_flags(m, PARTICLE_HORIZONTAL_STAR, 0)
                o.oInteractType = INTERACT_GRABBABLE
                o.oAction = GOOMBA_ACT_STUN
                o.oSwitchState2 = 1
                o.oSwitchState1 = 2
                o.oTimer = 0
                cur_obj_init_animation_with_accel_and_sound(0, 0)
            elseif sGoombaWarioDeath[m.action] then
                bhv_goomba_render96_death(o)
            end
        end
    
        --Stunned from wario's jump, checks if going to be grabbed
        if (o.oHeldState == HELD_FREE and o.oAction == GOOMBA_ACT_STUN and o.oTimer <= 150) then
            if sGoombaWarioDeath[m.action] and dist_between_objects(o, m.marioObj) <= 150 then
                bhv_goomba_render96_death(o)
            end
            o.oGoombaTargetYaw = o.oGoombaTargetYaw + 0x1000
            cur_obj_rotate_yaw_toward(o.oGoombaTargetYaw, 0x1000)
            o.oSwitchState2 = 1
            o.oSwitchState1 = 2
            if mario_check_object_grab(m) ~= 0 and (m.heldObj == nil) then
                m.usedObj = o
                mario_grab_used_object(m)
                o.oAction = GOOMBA_ACT_GRAB
            end
        end
        
        r96lib.update_held_object(m, o, GOOMBA_OPTS)

        if o.oHeldState == HELD_HELD then
            o.oSwitchState2 = 1
            o.oSwitchState1 = 2
        end

        --If not picked up after some time, go back to walking
        if (o.oHeldState == HELD_FREE and o.oAction == GOOMBA_ACT_STUN and o.oTimer > 150) then
            o.oInteractType = INTERACT_BOUNCE_TOP;
            o.oAction = GOOMBA_ACT_WALK;
            o.oSwitchState2 = 0
            o.oSwitchState1 = 0
            cur_obj_init_animation_with_accel_and_sound(0, 1) 
            return
        end
    end
end

id_bhvRender96Goomba = hook_render96_behavior(id_bhvGoomba, false, bhv_goomba_render96_init, bhv_goomba_render96_loop)

-------------------
-- Geo functions --
-------------------

function geo_switch_kug(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    cast_graph_node(node).selectedCase = (geo_get_current_object().oTimer // 4) % 4
end

---------------
-- UV scroll --
---------------

-- UvScroll.hook_scrolling_function('kug_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('kug_switchopt1_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt1_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt1_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('kug_switchopt2_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt2_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt2_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('kug_switchopt3_body_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt3_foot_L_mesh_layer_1_tri_0', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt3_foot_R_mesh_layer_1_tri_0', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('kug_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt1_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt2_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)
-- UvScroll.hook_scrolling_function('kug_switchopt3_mouth_mesh_layer_1_tri_2', uv_scroll_spin_slow)

-- UvScroll.hook_scrolling_function('goomba_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_1', uv_scroll_spin)
-- UvScroll.hook_scrolling_function('goomba_underground_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_1', uv_scroll_spin)
-- UvScroll.hook_scrolling_function('goomba_boxart_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_2', uv_scroll_spin)
-- UvScroll.hook_scrolling_function('kug_eyes_dazed_switch_eyes_dazed_mesh_layer_1_tri_2', uv_scroll_spin)
