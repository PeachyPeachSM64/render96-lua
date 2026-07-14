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
local function bhv_piranha_plant_render96_init(o)
    o.oSwitchState2 = 10
end

---@param o Object
local function bhv_piranha_plant_render96_loop(o)
    local sBiteFrames = { 12, 28, 50, 64 }
    local frame = o.header.gfx.animInfo.animFrame
    if o.oAction == PIRANHA_PLANT_ACT_BITING then
        local faceState = 0
        for _, biteFrame in ipairs(sBiteFrames) do
            local delta = frame - biteFrame
            if delta >= -9 and delta <= 9 then
                if delta < 0 then
                    faceState = 10 + delta
                elseif delta == 0 then
                    faceState = 10
                else
                    faceState = 10 - delta
                end
                break
            end
        end
        o.oSwitchState2 = faceState
    end

    if o.oAction == PIRANHA_PLANT_ACT_STOPPED_BITING and frame >= 0 and frame <= 10 then
        o.oSwitchState2 = _min(frame, 10)
    end
    if o.oAction == PIRANHA_PLANT_ACT_SLEEPING then
        o.oSwitchState2 = 10
    end
end

id_bhvRender96PiranhaPlant = hook_render96_behavior(id_bhvPiranhaPlant, false, bhv_piranha_plant_render96_init, bhv_piranha_plant_render96_loop)

---@param o Object
local function bhv_fire_piranha_plant_render96_loop(o)
    local frame = o.header.gfx.animInfo.animFrame
    if o.oAction == FIRE_PIRANHA_PLANT_ACT_GROW then
        if frame < 46 then
            o.oSwitchState2 = 10
        elseif frame >= 46 and frame <= 66 then
            o.oSwitchState2 = frame - 56
        else
            o.oSwitchState2 = 10
        end
    end

    if o.oAction == FIRE_PIRANHA_PLANT_ACT_HIDE then
        if frame < 10 then
            o.oSwitchState2 = 10
        elseif frame >= 10 and frame <= 30 then
            o.oSwitchState2 = frame - 20
        else
            o.oSwitchState2 = 10
        end
    end
end

id_bhvRender96FirePiranhaPlant = hook_render96_behavior(id_bhvFirePiranhaPlant, false, bhv_piranha_plant_render96_init, bhv_fire_piranha_plant_render96_loop)
