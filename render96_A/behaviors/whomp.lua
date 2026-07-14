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
local function bhv_whomp_render96_loop(o)
    obj_squish_on_action_enter(o, 5, 0.10, 0.10, -0.2)
    if obj_hit_by_wario_charge(o, 200) then
        cur_obj_play_sound_2(SOUND_OBJ_THWOMP)
        o.oNumLootCoins = 5
        obj_spawn_loot_yellow_coins(o, 5, 20.0)
        create_sound_spawner(SOUND_OBJ_STOMPED)
        obj_kill_common(o)
    end
end

---@param o Object
local function bhv_whomp_render96_init(o)
    o.oThwompPrevAction = o.oAction or 0
    o.oThwompSquishTimer = 0
    o.oThwompSquishDur = 0
    o.oThwompBaseScale = o.header.gfx.scale.x
end

---@param o Object
local function bhv_whomp_king_render96_loop(o)
    obj_squish_on_action_enter(o, 5, 0.15, 0.15, -0.3)  -- bugfix: now correctly resets on re-entry

    if o.oHealth == 3 then o.oSwitchState1 = 0 end
    if o.oHealth == 2 then o.oSwitchState1 = 1 end
    if o.oHealth == 1 then o.oSwitchState1 = 2 end
    o.oThwompPrevAction = o.oAction
end

id_bhvRender96SmallWhomp = hook_render96_behavior(id_bhvSmallWhomp, false, bhv_whomp_render96_init, bhv_whomp_render96_loop)
id_bhvRender96WhompKingBoss = hook_render96_behavior(id_bhvWhompKingBoss, false, bhv_whomp_render96_init, bhv_whomp_king_render96_loop)
