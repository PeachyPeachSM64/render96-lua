require("constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_1up_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

---@param o Object
local function bhv_1up_render96_loop(o)
    o.oFaceAngleYaw = o.oMoveAngleYaw
end

id_bhvRender961Up = hook_render96_behavior(id_bhv1Up, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upWalking = hook_render96_behavior(id_bhv1upWalking, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upRunningAway = hook_render96_behavior(id_bhv1upRunningAway, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender961upSliding = hook_render96_behavior(id_bhv1upSliding, false, bhv_1up_render96_init, bhv_1up_render96_loop) -- MOVE MESH TO HITBOX
id_bhvRender961upJumpOnApproach = hook_render96_behavior(id_bhv1upJumpOnApproach, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender96Hidden1up = hook_render96_behavior(id_bhvHidden1up, false, bhv_1up_render96_init, bhv_1up_render96_loop)
id_bhvRender96Hidden1upInPole = hook_render96_behavior(id_bhvHidden1upInPole, false, bhv_1up_render96_init, bhv_1up_render96_loop)
