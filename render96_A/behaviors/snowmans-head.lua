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

id_bhvRender96SnowmansHead = hook_render96_behavior(id_bhvSnowmansHead, false, nil, bhv_snowmans_head_render96_loop, OBJ_LIST_DEFAULT)
