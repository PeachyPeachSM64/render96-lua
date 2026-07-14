local r96lib = require("/lib/r96lib")
require("constants")

------------------------
-- Behavior functions --
------------------------

local COLORS_KINGBOBOMB = {
    {r = 4, g = 4, b = 4},
    {r = 150, g = 0,  b = 0},
}

---@param o Object
local function bhv_king_bobomb_render96_init(o)
    o.oColorR = 4
    o.oColorG = 4
    o.oColorB = 4
end

---@param o Object
local function bhv_king_bobomb_render96_loop(o)
    if o.oHealth == 3 then
        o.oColorR = 4
        o.oColorG = 4
        o.oColorB = 4
    end
    if o.oHealth == 2 then r96lib.pulse_rapid(o, COLORS_KINGBOBOMB, o.oTimer, 0.1) end
    if o.oHealth == 1 then r96lib.pulse_rapid(o, COLORS_KINGBOBOMB, o.oTimer, 0.3) end
end

id_bhvRender96KingBobomb = hook_render96_behavior(id_bhvKingBobomb, false, bhv_king_bobomb_render96_init, bhv_king_bobomb_render96_loop, OBJ_LIST_GENACTOR)

-------------------
-- Geo functions --
-------------------

function geo_function_kingbob_pulse(node, matStackIndex)
   local o = geo_get_current_object()
   if o == nil then return end
    r96lib.gfx_color_patch_by_name(node, {
        origDl = "king_bobomb_004_offset_mesh_layer_1"
    })
end
