require("constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_bowling_ball(o)
    if obj_hit_by_wario_charge(o, 200) then
        create_sound_spawner(SOUND_GENERAL2_BOBOMB_EXPLOSION)
        obj_kill_common(o)
    end
end

id_bhvRender96BowlingBall = hook_render96_behavior(id_bhvBowlingBall, false, nil, bhv_bowling_ball)

---@param o Object
local function bhv_pit_bowling_ball(o)
    if obj_hit_by_wario_charge(o, 200) then
        spawn_sync_object(id_bhvBlueCoinJumping, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
        create_sound_spawner(SOUND_GENERAL2_BOBOMB_EXPLOSION)
        obj_kill_common(o)
    end
end

id_bhvRender96PitBowlingBall = hook_render96_behavior(id_bhvPitBowlingBall, false, nil, bhv_pit_bowling_ball)
