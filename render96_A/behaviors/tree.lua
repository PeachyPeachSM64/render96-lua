require("constants")

local _random = math.random

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
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~(GRAPH_RENDER_BILLBOARD | GRAPH_RENDER_CYLBOARD)
end

---@param o Object
local function bhv_tree_render96_loop(o)
    bhv_pole_base_loop()
    if o.oTimer < 2 then
        local model = obj_get_model_id_extended(o)
        if model ~= E_MODEL_COURTYARD_SPIKY_TREE and model ~= E_MODEL_PALM_TREE then
            o.oFaceAngleYaw = _random(0, 10) * 0x10000/10
        end
    end
end

id_bhvRender96Tree = hook_render96_behavior(id_bhvTree, true, bhv_tree_render96_init, bhv_tree_render96_loop)
