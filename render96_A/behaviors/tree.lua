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
local function bhv_tree_render96_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.hitboxHeight = 500
    o.hitboxRadius = 80
    o.oInteractType = INTERACT_POLE
    o.oIntangibleTimer = 0
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_CYLBOARD
end

---@param o Object
local function bhv_tree_render96_loop(o)
    bhv_pole_base_loop()
    if o.oTimer < 2 then
        local model = obj_get_model_id_extended(o)
        if model ~= E_MODEL_COURTYARD_SPIKY_TREE or model ~= E_MODEL_PALM_TREE then
            o.oFaceAngleYaw = _random(0, 10) * 0x10000/10
        end
    end
end

id_bhvRender96Tree = hook_render96_behavior(id_bhvTree, true, bhv_tree_render96_init, bhv_tree_render96_loop, OBJ_LIST_POLELIKE)
