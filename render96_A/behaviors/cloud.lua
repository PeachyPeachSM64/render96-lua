require("constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_cloud_render96_init(o)
    if (o.oBehParams2ndByte ~= CLOUD_BP_FWOOSH) then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96Cloud = hook_render96_behavior(id_bhvCloud, false, bhv_cloud_render96_init, nil)

---@param o Object
local function bhv_cloudpart_render96_init(o)
    if obj_has_model_extended(o, E_MODEL_MIST) ~= 0 then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96CloudPart = hook_render96_behavior(id_bhvCloudPart, false, bhv_cloudpart_render96_init, nil)
