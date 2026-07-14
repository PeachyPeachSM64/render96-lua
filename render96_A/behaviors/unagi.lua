require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_unagi_render96_init(o)
    o.header.gfx.skipInViewCheck = true
end

id_bhvRender96Unagi = hook_render96_behavior(id_bhvUnagi, false, bhv_unagi_render96_init, nil)
