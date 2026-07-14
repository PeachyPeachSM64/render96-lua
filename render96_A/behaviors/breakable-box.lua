require("/constants")

------------------------
-- Behavior functions --
------------------------

local function bhv_breakable_box_render96_loop(o)
    if obj_hit_by_wario_charge(o, 240) then
        obj_explode_and_spawn_coins(46, 1)
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX)
    end
end

id_bhvRender96BreakableBox = hook_render96_behavior(id_bhvBreakableBox, false, nil, bhv_breakable_box_render96_loop)
