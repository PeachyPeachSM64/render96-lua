require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_wiggler_head_render96_loop(o)
    if o.oHealth == 4 then o.oSwitchState1 = 0 end
    if m.pos.y >= 1650 and o.oHealth == 4 then o.oSwitchState1 = 1 end
    if o.oHealth == 4 and o.oAction == WIGGLER_ACT_JUMPED_ON then o.oSwitchState1 = 2 end
    if o.oHealth == 3 and o.oAction == WIGGLER_ACT_JUMPED_ON then o.oSwitchState1 = 3 end
    if o.oHealth == 2 and o.oAction == WIGGLER_ACT_JUMPED_ON then o.oSwitchState1 = 4 end
    if o.oHealth == 1 then o.oSwitchState1 = 4 end
end

id_bhvRender96WigglerHead = hook_render96_behavior(id_bhvWigglerHead, false, nil, bhv_wiggler_head_render96_loop)

-------------------
-- Geo functions --
-------------------

function geo_function_wiggler_rotate(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end
    local id = o._pointer
    cast_graph_node(node.next).rotation.x = (((id >> 11) % 4) + 1) * 0x1500
    cast_graph_node(node.next).rotation.y = (((id >> 11) % 4) + 1) * 0x1500
    cast_graph_node(node.next).rotation.z = (((id >> 11) % 4) + 1) * 0x1500
end

-- WTF IS THIS
-- switch param 0 seems to be wiggler head, while param 1 seems to be body
-- nah, get current object and check behavior
-- body parts should have the head as parent
function geo_switch_wiggler_color(node, matStackIndex)
    local o = obj_get_nearest_object_with_behavior_id(gMarioStates[0].marioObj, id_bhvWigglerHead)
    if o == nil then return end
    local switch = cast_graph_node(node)
    if o.oHealth == 4 then switch.selectedCase = 0 end
    if o.oHealth == 4 and o.oAction == WIGGLER_ACT_JUMPED_ON then switch.selectedCase = 1 end
    if o.oHealth == 3 and o.oAction == WIGGLER_ACT_JUMPED_ON then switch.selectedCase = 1 end
    if o.oHealth == 2 and o.oAction == WIGGLER_ACT_JUMPED_ON then switch.selectedCase = 0 end
    if o.oHealth == 1 then switch.selectedCase = 0 end
end

---------------
-- UV scroll --
---------------

--UvScroll.hook_scrolling_function('wiggler_head_switch_opt1_000_displaylist5_mesh_layer_1_tri_3', uv_scroll_spin)
