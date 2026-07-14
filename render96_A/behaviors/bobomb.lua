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

local COLORS_BOBOMB = {
    {r = 4, g = 4, b = 4},
    {r = 200, g = 0, b = 0},
}

---@param o Object
local function bhv_bobomb_render96_init(o)
    o.oColorR = 4
    o.oColorG = 4
    o.oColorB = 4
end

---@param o Object
local function bhv_bobomb_render96_loop(o)
    if o.oBobombFuseTimer == 0 then 
        o.oSwitchState1 = 0
    else 
        o.oSwitchState1 = 1
        r96lib.pulse_ramp(o, COLORS_BOBOMB, o.oBobombFuseTimer, 150)
    end
    if m.action == ACT_WARIO_CHARGE and dist_between_objects(o, m.marioObj) <= 200 then
		set_camera_shake_from_point(SHAKE_POS_MEDIUM, m.pos.x, m.pos.y, m.pos.z)
        o.oBobombFuseTimer = 152
    end
end

id_bhvRender96Bobomb = hook_render96_behavior(id_bhvBobomb, false, bhv_bobomb_render96_init, bhv_bobomb_render96_loop, OBJ_LIST_DESTRUCTIVE)

-------------------
-- Geo functions --
-------------------

function geo_function_bobomb_angry(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    r96lib.gfx_color_patch(node, {
        prefix    = "bobomb_angry",
        origDl    = "black_bobomb_body_mesh_layer_1_mat_override_bobomb_blue2_0",
        origMat   = "mat_black_bobomb_bobomb_blue2",
        primIndex = 8,
    })
end
