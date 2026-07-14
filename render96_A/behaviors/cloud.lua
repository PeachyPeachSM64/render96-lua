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
local function bhv_cloud_render96_init(o)
    if (o.oBehParams2ndByte ~= CLOUD_BP_FWOOSH) then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96Cloud = hook_render96_behavior(id_bhvCloud, false, bhv_cloud_render96_init, nil, OBJ_LIST_DEFAULT)

---@param o Object
local function bhv_cloudpart_render96_init(o)
    if obj_has_model_extended(o, E_MODEL_MIST) ~= 0 then
        obj_mark_for_deletion(o)
    end
end

id_bhvRender96CloudPart = hook_render96_behavior(id_bhvCloudPart, false, bhv_cloudpart_render96_init, nil, OBJ_LIST_DEFAULT)
