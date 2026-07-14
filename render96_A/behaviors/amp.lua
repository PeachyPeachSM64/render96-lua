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
local function bhv_amp_render96_loop(o)
    if o.oAction == AMP_ACT_ATTACK_COOLDOWN and o.oTimer < 31 then
        if o.oTimer % 2 == 0 then
            o.oSwitchState2 = _random(1, 2)
            if o.oSwitchState2 == 2 then o.oSwitchState1 = 0 else o.oSwitchState1 = 0 end
        end
    elseif o.oAction == AMP_ACT_ATTACK_COOLDOWN and o.oTimer < 90 then
        o.oSwitchState2 = 1
        o.oSwitchState1 = 1
    else
        o.oSwitchState1 = 0
        o.oSwitchState2 = 0
    end
end

id_bhvRender96CirclingAmp = hook_render96_behavior(id_bhvCirclingAmp, false, nil, bhv_amp_render96_loop)
id_bhvRender96HomingAmp = hook_render96_behavior(id_bhvHomingAmp, false, nil, bhv_amp_render96_loop)
