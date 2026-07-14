require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_snowball_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

id_bhvRender96MrBlizzardSnowball = hook_render96_behavior(id_bhvMrBlizzardSnowball, false, bhv_snowball_render96_init, nil)
