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
local function bhv_tower_door_render96_loop(o)
    if (m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 200) then
        obj_explode_and_spawn_coins(80.0, 0)
        create_sound_spawner(SOUND_GENERAL_WALL_EXPLOSION)
    end
end

id_bhvRender96TowerDoor = hook_render96_behavior(id_bhvTowerDoor, false, nil, bhv_tower_door_render96_loop)
