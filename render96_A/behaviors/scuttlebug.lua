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

local COLORS_SCUTTLE = {
    {r = 0x40, g = 0x21, b = 0x3B},
    {r = 0x44, g = 0x35, b = 0x00},
    {r = 0x00, g = 0x00, b = 0x00},
}

---@param o Object
local function bhv_scuttlebug_render96_loop(o)
    r96lib.pulse_cycle(o, COLORS_SCUTTLE, 50)
end

id_bhvRender96Scuttlebug = hook_render96_behavior(id_bhvScuttlebug, false, nil, bhv_scuttlebug_render96_loop, OBJ_LIST_SURFACE)

-------------------
-- Geo functions --
-------------------

function geo_function_scuttle_body(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local rot = (o.oTimer * 0x200) & 0xFFFF
    rotN.rotation.x = rot
    rotN.rotation.y = rot
    rotN.rotation.z = rot
end

function geo_function_scuttle_body_color(node, matStackIndex)
    r96lib.gfx_color_patch(node, {
        prefix    = "scuttle",
        origDl    = "scuttlebug_scuttle_body_dl_mesh_layer_1",
        origMat   = "mat_scuttlebug_scuttlebug_body",
        primIndex = 7,
    })
end
