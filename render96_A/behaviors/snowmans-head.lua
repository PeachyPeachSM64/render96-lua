require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_snowmans_head_render96_loop(o)
    local model = obj_get_model_id_extended(o)
    if o.oTimer < 2 then
        if model == E_MODEL_SNOWMAN_HEAD then
            o.oFaceAngleYaw = 0x1000
            --o.oMoveAngleYaw = 0x4000
            --o.oFaceAnglePitch = 0x1000
            o.oFaceAngleRoll = 0x4000
        end
    end
end

id_bhvRender96SnowmansHead = hook_render96_behavior(id_bhvSnowmansHead, false, nil, bhv_snowmans_head_render96_loop)
