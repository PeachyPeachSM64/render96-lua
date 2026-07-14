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

-------------------
-- Geo functions --
-------------------

local function wing_rotate(o) return (coss((o.oTimer & 0xF) << 12) + 1.0) * 4096.0 end

function geo_function_wing1_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    rotN.rotation.x = wing_rotate(o)
end

function geo_function_wing2_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    rotN.rotation.x = -wing_rotate(o)
end
