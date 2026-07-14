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
local function bhv_wooden_post_render96_loop(o)
    if get_character(m).type == CT_WARIO then
        o.oWoodenPostSpeedY = -210
    end
end

id_bhvRender96WoodenPost = hook_render96_behavior(id_bhvWoodenPost, false, nil, bhv_wooden_post_render96_loop, OBJ_LIST_SURFACE)
