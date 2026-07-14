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

local function bhv_breakable_box_render96_loop(o)
    if obj_hit_by_wario_charge(o, 240) then
        obj_explode_and_spawn_coins(46, 1)
        create_sound_spawner(SOUND_GENERAL_BREAK_BOX)
    end
end

id_bhvRender96BreakableBox = hook_render96_behavior(id_bhvBreakableBox, false, nil, bhv_breakable_box_render96_loop)
