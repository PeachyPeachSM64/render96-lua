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
function bhv_chuckya_heaveho_render96_loop(o)
    if obj_hit_by_wario_charge(o, 200) then
        spawn_sync_object(id_bhvBlueCoinJumping, E_MODEL_BLUE_COIN, o.oPosX, o.oPosY, o.oPosZ, nil)
        create_sound_spawner(SOUND_OBJ_CHUCKYA_DEATH)
        obj_kill_common(o)
    end
end

id_bhvRender96Chuckya = hook_render96_behavior(id_bhvChuckya, false, nil, bhv_chuckya_heaveho_render96_loop, OBJ_LIST_GENACTOR)

-------------------
-- Geo functions --
-------------------

function geo_function_chuckya_spin(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation
    local rot = (o.oTimer * 0x2000) & 0xFFFF
    rotN.rotation.x = rot
end
