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
local function bhv_pokey_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

---@param o Object
local function bhv_pokey_render96_loop(o)
    local player = nearest_player_to_object(o)
    local angleToPlayer = obj_angle_to_object(o, player)
    o.oFaceAngleYaw =  angleToPlayer
    if o.oBehParams2ndByte == 0 and o.oPosX < -2000 then obj_set_model_extended(o, E_MODEL_POKEY_HEAD_BOXART) end
    if o.oBehParams2ndByte ~= 0 and o.oPosX < -2000 then obj_set_model_extended(o, E_MODEL_POKEY_BODY_PART_BOXART) end
end

id_bhvRender96PokeyBodyPart = hook_render96_behavior(id_bhvPokeyBodyPart, false, bhv_pokey_render96_init, bhv_pokey_render96_loop, OBJ_LIST_SURFACE)
