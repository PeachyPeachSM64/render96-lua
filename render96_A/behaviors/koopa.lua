local charSelect = require("/lib/char-select")
require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_koopa_render96_loop(o)

    -- koopa instantly dies if attacked by Wario
    if o.oKoopaMovementType == KOOPA_BP_UNSHELLED and o.oAction == KOOPA_UNSHELLED_ACT_LYING and o.oTimer < 3 then
        local m = nearest_mario_state_to_object(o)
        if charSelect.character_get_current_number(m.playerIndex) == CT_WARIO then
            create_sound_spawner(SOUND_OBJ_STOMPED)
            o.oAction = OBJ_ACT_SQUISHED
        end
    end
end

id_bhvRender96Koopa = hook_render96_behavior(id_bhvKoopa, false, nil, bhv_koopa_render96_loop)
