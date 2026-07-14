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
local function bhv_boo_render96_init(o)
    o.oOpacity = 255
    o.oSwitchState2 = 0
    o.oSwitchTimer2 = 1
end

---@param o Object
local function bhv_boo_render96_loop(o)

    obj_squish_on_action_enter(o, 2, 0.15, 0.15, -0.3)

    local sBooScared = { 0, 1, 2, 3, 4, 4, 4}
    local sBooHunt = { 4, 4, 4, 3, 2, 1, 0}
    if o.oOpacity < 255 and o.oSwitchTimer2 < 7 then
        o.oOpacity = 254 - (o.oSwitchTimer2 * 15) 
        o.oSwitchState2 = sBooScared[o.oSwitchTimer2]
        o.oSwitchTimer2 = o.oSwitchTimer2 + 1
    elseif o.oOpacity >= 150 and o.oSwitchTimer2 >= 7 and o.oSwitchTimer2 < 14 then
        o.oSwitchState2 = sBooHunt[o.oSwitchTimer2 - 6]
        o.oSwitchTimer2 = o.oSwitchTimer2 + 1
    elseif o.oOpacity == 255 and o.oSwitchTimer2 == 14 then
        o.oSwitchState2 = 0
        o.oSwitchTimer2 = 1
    elseif o.oOpacity == 40 and o.oSwitchTimer2 == 14 then
        o.oSwitchState2 = 4
        o.oSwitchTimer2 = 7
    elseif o.oOpacity == 40 and o.oSwitchTimer2 == 7 then
        o.oSwitchState2 = 4
    end
end

id_bhvRender96GhostHuntBoo = hook_render96_behavior(id_bhvGhostHuntBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96GhostHuntBigBoo = hook_render96_behavior(id_bhvGhostHuntBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96BooWithCage = hook_render96_behavior(id_bhvBooWithCage, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96BalconyBigBoo = hook_render96_behavior(id_bhvBalconyBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
id_bhvRender96MerryGoRoundBigBoo = hook_render96_behavior(id_bhvMerryGoRoundBigBoo, false, bhv_boo_render96_init, bhv_boo_render96_loop)
