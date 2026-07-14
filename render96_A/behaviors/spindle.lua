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

function geo_switch_spindle(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local switchCase = 0
    if (_abs(o.oMoveAnglePitch & 0x7fff) < 8000.0 and o.oAngleVelPitch ~= 0) then
        switchCase = 0
    else
        switchCase = 1
    end
    cast_graph_node(node).selectedCase = switchCase
end
