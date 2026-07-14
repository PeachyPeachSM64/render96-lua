require("constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_tuxie_mother_render96_loop(o)
    local player = nearest_player_to_object(o)
    local distanceToPlayer = dist_between_objects(o, player)
    local smallPenguin = obj_get_nearest_object_with_behavior_id(o, id_bhvUnused20E0)

    if smallPenguin ~= nil and smallPenguin.oPosY < -4850 then
        o.oAction = 4
        obj_mark_for_deletion(smallPenguin)
    end

    if o.oAction == 4 then
        o.oForwardVel = 30.0
        cur_obj_rotate_yaw_toward(o.oAngleToMario, 0x1000)
        cur_obj_init_animation_with_accel_and_sound(0, 3)
        if distanceToPlayer < 300 then
            hurt_and_set_mario_action(m, ACT_QUICKSAND_DEATH, 0, 16)
            o.oAction = 2
        end
        --if m.health == 255 then
        --    o.oAction = 2
        --end
    end

    -- TODO: WTF
    -- TP to origin if falling to death barrier?
    if o.oPosY < -4850 then
        o.oPosX = 3450
        o.oPosY = -4700
        o.oPosZ = 4550
    end

    o.oSwitchTimer1 = o.oSwitchTimer1 + 1
    local timer = o.oSwitchTimer1 % 50
    o.oSwitchState1 = 0

    if timer < 43 then
        o.oSwitchState1 = 0
    elseif timer < 45 then
        o.oSwitchState1 = 1
    elseif timer < 47 then
        o.oSwitchState1 = 2
    else
        o.oSwitchState1 = 1
    end
    -- Angry eyes if chasing Mario
    if o.oForwardVel > 5.0 then
        o.oSwitchState1 = 3
    end
end

id_bhvRender96TuxiesMother = hook_render96_behavior(id_bhvTuxiesMother, false, nil, bhv_tuxie_mother_render96_loop)
