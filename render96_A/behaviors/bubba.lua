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
local function bhv_bubba_render96_init(o)
    smlua_anim_util_set_animation(o, "bubba_swim")
end

local function bhv_bubba_render96_loop(o)
    o.oSwitchState1 = o.oAnimState
end

id_bhvRender96Bubba = hook_render96_behavior(id_bhvBubba, false, bhv_bubba_render96_init, bhv_bubba_render96_loop)
