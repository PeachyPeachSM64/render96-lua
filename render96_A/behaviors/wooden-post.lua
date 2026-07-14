require("constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_wooden_post_render96_loop(o)
    if get_character(m).type == CT_WARIO then
        o.oWoodenPostSpeedY = -210
    end
end

id_bhvRender96WoodenPost = hook_render96_behavior(id_bhvWoodenPost, false, nil, bhv_wooden_post_render96_loop)
