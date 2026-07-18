require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_wooden_post_render96_loop(o)
    if obj_ground_pounded_by_wario(o) then
        o.oWoodenPostSpeedY = -210
        network_send_object(o, true)
    end
end

id_bhvRender96WoodenPost = hook_render96_behavior(id_bhvWoodenPost, false, nil, bhv_wooden_post_render96_loop)
