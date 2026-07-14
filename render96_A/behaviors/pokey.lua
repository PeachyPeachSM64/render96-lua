require("constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_pokey_render96_init(o)
    o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_BILLBOARD
end

---@param o Object
local function bhv_pokey_render96_loop(o)
    local player = nearest_player_to_object(o)
    local angleToPlayer = obj_angle_to_object(o, player)
    o.oFaceAngleYaw =  angleToPlayer
    if o.oPosX < -2000 then -- TODO: WTF? Only some pokeys get the boxart model?
        if o.oBehParams2ndByte == 0 then
            obj_set_model_extended(o, E_MODEL_POKEY_HEAD_BOXART)
        else
            obj_set_model_extended(o, E_MODEL_POKEY_BODY_PART_BOXART)
        end
    end
end

id_bhvRender96PokeyBodyPart = hook_render96_behavior(id_bhvPokeyBodyPart, false, bhv_pokey_render96_init, bhv_pokey_render96_loop)
