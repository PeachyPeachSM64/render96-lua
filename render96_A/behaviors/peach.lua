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

-------------------
-- Geo functions --
-------------------

function geo_switch_peach_left_hand(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end

    local m = gMarioStates[0]
    if m.actionArg == 3 or m.actionArg == 4 or m.actionArg == 5 then -- END_PEACH_CUTSCENE_SPAWN_PEACH END_PEACH_CUTSCENE_DESCEND_PEACH END_PEACH_CUTSCENE_RUN_TO_PEACH
        cast_graph_node(node).selectedCase = 1
    end
    if m.actionArg == 6 then -- END_PEACH_CUTSCENE_DIALOG_1
        if m.actionTimer == 120 then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 320 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 7 then -- END_PEACH_CUTSCENE_DIALOG_2
        if m.actionTimer == 0  then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 42 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 8 then -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        if m.actionTimer == 0   then cast_graph_node(node).selectedCase = 1 end
        if m.actionTimer == 35  then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 130 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 10 then -- END_PEACH_CUTSCENE_DIALOG_3
        if m.actionTimer == 0  then cast_graph_node(node).selectedCase = 1 end
        if m.actionTimer == 22 then cast_graph_node(node).selectedCase = 0 end
    end
end

function geo_switch_peach_lip(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end

    local m = gMarioStates[0]
    if m.actionArg == 6 then -- END_PEACH_CUTSCENE_DIALOG_1
        local lip_sync = gPeachCutsceneDialog1[m.actionTimer]
        if lip_sync then cast_graph_node(node).selectedCase = lip_sync end
    end
    if m.actionArg == 7 then -- END_PEACH_CUTSCENE_DIALOG_2
        local lip_sync = gPeachCutsceneDialog2[m.actionTimer]
        if lip_sync then cast_graph_node(node).selectedCase = lip_sync end
    end
    if m.actionArg == 10 then -- END_PEACH_CUTSCENE_DIALOG_3
        local lip_sync = gPeachCutsceneDialog3[m.actionTimer]
        if lip_sync then cast_graph_node(node).selectedCase = lip_sync end
    end
end

function geo_switch_peach_right_hand(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end

    local m = gMarioStates[0]
    if m.actionArg == 3 or m.actionArg == 4 or m.actionArg == 5 then -- END_PEACH_CUTSCENE_SPAWN_PEACH END_PEACH_CUTSCENE_DESCEND_PEACH END_PEACH_CUTSCENE_RUN_TO_PEACH
        cast_graph_node(node).selectedCase = 1
    end
    if m.actionArg == 6 then -- END_PEACH_CUTSCENE_DIALOG_1
        if m.actionTimer == 120 then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 320 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 7 then -- END_PEACH_CUTSCENE_DIALOG_2
        if m.actionTimer == 0  then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 42 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 8 then -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        if m.actionTimer == 0   then cast_graph_node(node).selectedCase = 1 end
        if m.actionTimer == 35  then cast_graph_node(node).selectedCase = 0 end
        if m.actionTimer == 130 then cast_graph_node(node).selectedCase = 1 end
    end
    if m.actionArg == 10 then -- END_PEACH_CUTSCENE_DIALOG_3
        if m.actionTimer == 0  then cast_graph_node(node).selectedCase = 1 end
        if m.actionTimer == 22 then cast_graph_node(node).selectedCase = 0 end
    end
end
