local r96lib = require("/lib/r96lib")
require("constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_six_golden_coin_init(o)
    o.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oWallHitboxRadius = 30
    o.oGravity = -400
    o.oBounciness = -70
    o.oDragStrength = 1000
    o.oFriction = 1000
    o.oBuoyancy = 200
    o.hitboxHeight = 64
    o.hitboxRadius = 32
    o.oHomeY = o.oPosY
end

---@param o Object
local function bhv_six_golden_coin_loop(o)
    o.oFaceAngleYaw = o.oFaceAngleYaw + 0x700
    o.oPosY = o.oHomeY + sins(o.oTimer * 0x600) * 8
    if dist_between_objects(o, m.marioObj) <= 150 then
        r96lib.save_render96_data("wario_coin", o.oBehParams2ndByte)
        gNumWarioCoins = select(2, r96lib.load_render96_data("wario_coin"):gsub("1", ""))
        spawn_non_sync_object(id_bhvCoinSparkles, E_MODEL_SPARKLES, o.oPosX, o.oPosY, o.oPosZ, nil)
        audio_stream_play(COLLECTABLE, false, 1)
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
    if r96lib.check_render96_data("wario_coin", o.oBehParams2ndByte) == true then
        cur_obj_disable_rendering_and_become_intangible(o)
        obj_mark_for_deletion(o)
    end
end

id_bhvSixGoldenCoin = hook_render96_behavior(nil, false, bhv_six_golden_coin_init, bhv_six_golden_coin_loop, OBJ_LIST_LEVEL, "SixGoldenCoin")
