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

local sChainChompBiteFrames = { 0, 1, 2, 4, 6, 8, 6, 4, 2, 0, 2, 4, 6, 8, 6, 4, 2, 1, 0 }

---@param o Object
local function bhv_chain_chomp_render96_loop(o)
    local frame = o.header.gfx.animInfo.animFrame
    o.oSwitchState2 = sChainChompBiteFrames[frame] or 0
end

id_bhvRender96ChainChomp = hook_render96_behavior(id_bhvChainChomp, false, nil, bhv_chain_chomp_render96_loop)
