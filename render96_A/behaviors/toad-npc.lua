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

-- hat, vest
local toadOutfits = {
    [133] = { 0, 0 }, -- castle inside first toad
    [135] = { 0, 3 }, -- WF room
    [134] = { 3, 2 }, -- JRB room
    [137] = { 1, 0 }, -- castle inside second floor next to bobomb painting
    [83]  = { 4, 4 }, -- castle inside third floor star
    [76]  = { 4, 4 }, -- castle inside second floor star
    [136] = { 2, 1 }, -- basement green wall toad
    [82]  = { 4, 4 }, -- basement star
}
---@param o Object
local function bhv_toad_render96_loop(o)
    local dialogId = (o.oBehParams >> 24) & 0xFF

    local outfit = toadOutfits[dialogId]
    if outfit then
        o.oSwitchState1 = outfit[1]
        o.oSwitchState2 = outfit[2]
    end
end

id_bhvRender96ToadMessage = hook_render96_behavior(id_bhvToadMessage, false, nil, bhv_toad_render96_loop)
