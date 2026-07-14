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

local COLORS_KINGBOBOMB = {
    {r = 4, g = 4, b = 4},
    {r = 150, g = 0,  b = 0},
}

---@param o Object
local function bhv_king_bobomb_render96_init(o)
    o.oColorR = 4
    o.oColorG = 4
    o.oColorB = 4
end

---@param o Object
local function bhv_king_bobomb_render96_loop(o)
    if o.oHealth == 3 then   
        o.oColorR = 4
        o.oColorG = 4
        o.oColorB = 4
    end
    if o.oHealth == 2 then r96lib.pulse_rapid(o, COLORS_KINGBOBOMB, o.oTimer, 0.1) end
    if o.oHealth == 1 then r96lib.pulse_rapid(o, COLORS_KINGBOBOMB, o.oTimer, 0.3) end
end

id_bhvRender96KingBobomb = hook_render96_behavior(id_bhvKingBobomb, false, bhv_king_bobomb_render96_init, bhv_king_bobomb_render96_loop, OBJ_LIST_GENACTOR)

-------------------
-- Geo functions --
-------------------

function geo_function_kingbob_pulse(node, matStackIndex)
   local o = geo_get_current_object()
   if o == nil then return end
    r96lib.gfx_color_patch_by_name(node, {
        origDl = "king_bobomb_004_offset_mesh_layer_1"
    })
end
