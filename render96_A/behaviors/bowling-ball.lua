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
