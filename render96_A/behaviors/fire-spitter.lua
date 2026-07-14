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
local function bhv_fire_spitter_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
    o.header.gfx.scale.x = 0.2
    o.oThwompBaseScale = o.header.gfx.scale.x
end

---@param o Object
local function bhv_fire_spitter_render96_loop(o)
    local player = nearest_player_to_object(o)
    local angleToPlayer = obj_angle_to_object(o, player)
    o.oFaceAngleYaw = angleToPlayer
    if o.oAction == FIRE_SPITTER_ACT_IDLE then
        if o.oTimer < 20 then o.oSwitchState1 = 2 o.header.gfx.scale.x = 0.15 end
        if o.oTimer > 20 and o.oTimer < 50 then
            o.oSwitchState1 = 3
            if o.oTimer % 5 == 0 then
                o.oThwompSquishTimer = 0
                o.oThwompSquishDur = 5
                o.header.gfx.scale.x = 0.10
            else
                o.header.gfx.scale.x = 0.2
            end
            if (o.oThwompSquishDur or 0) > 0 and (o.oThwompSquishTimer or 0) <= o.oThwompSquishDur then
                r96lib.squish_apply(o, o.oThwompSquishTimer, o.oThwompSquishDur, 0.15, -0.3, -0.3, o.oThwompBaseScale, nil)
                o.oThwompSquishTimer = o.oThwompSquishTimer + 1
            end
        elseif o.oTimer == 51 then
            o.oSwitchState1 = 0
        end
    end
    if o.oAction == FIRE_SPITTER_ACT_SPIT_FIRE then
        if o.oTimer < 10 then
            o.oSwitchState1 = 1
        elseif o.oTimer == 10 then
            o.oSwitchState1 = 2
        end
    end
end

id_bhvRender96FireSpitter = hook_render96_behavior(id_bhvFireSpitter, false, bhv_fire_spitter_render96_init, bhv_fire_spitter_render96_loop, OBJ_LIST_GENACTOR)
