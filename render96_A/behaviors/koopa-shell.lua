local r96lib = require("/lib/r96lib")
require("/constants")

------------------------
-- Behavior functions --
------------------------

local KOOPA_SHELL_OPTS = {
    audio = EVENT_SHELL_THROWN,
    interactions = gThrownInteractions,
}

---@param o Object
local function bhv_koopa_shell_render96_loop(o)
    if get_character(m).type == CT_WARIO then
        o.oInteractType = INTERACT_GRABBABLE
        if mario_check_object_grab(m) ~= 0 and (m.heldObj == nil) then
            o.oAction = 50
        end

        r96lib.update_held_object(m, o, KOOPA_SHELL_OPTS)

        if o.oHeldState == HELD_HELD then
            if gMarioStates[0].heldObj ~= nil then
                spawn_non_sync_object(id_bhvSparkleSpawn, E_MODEL_NONE, gMarioStates[0].marioObj.oPosX, gMarioStates[0].marioObj.oPosY + 100, gMarioStates[0].marioObj.oPosZ, nil)
            end
        end

        if o.oHeldState == HELD_FREE and (m.action == ACT_WARIO_CHARGE or m.action == ACT_JUMP_KICK) and dist_between_objects(o, m.marioObj) <= 200 then
            o.oAction = 50
            o.oMoveAngleYaw = m.faceAngle.y
            o.oForwardVel = 50.0
            o.oVelY = 20.0
            o.oTimer = 0
        end

        if (m.action == ACT_HOLD_WATER_IDLE or m.action == ACT_HOLD_WATER_ACTION_END) and m.heldObj == o then
            mario_drop_held_object(m)
            obj_mark_for_deletion(o)
        end
        o.oInteractStatus = 0
    end
end

id_bhvRender96KoopaShell = hook_render96_behavior(id_bhvKoopaShell, false, nil, bhv_koopa_shell_render96_loop)
