require("/constants")

local _max = math.max
local _min = math.min

-------------------
-- Geo functions --
-------------------

---@param node GraphNode
---@param matStackIndex integer
function geo_function_eyerok(node, matStackIndex)
    local o = geo_get_current_object()
    if o == nil then return end

    local model = obj_get_model_id_extended(o)

    local player = nearest_player_to_object(o)
    if player == nil then return end

    local rotN = cast_graph_node(node.next) ---@type GraphNodeRotation

    local angleToPlayerYaw   = obj_angle_to_object(o, player)
    local angleToPlayerPitch = obj_pitch_to_object(o, player)

    local limitYaw   = 0x2000 -- 45 degrees
    local limitPitch = 0x2000 -- ~22 degrees

    local yaw = angleToPlayerYaw - o.oFaceAngleYaw
    if yaw >  32767 then yaw = yaw - 65536 end
    if yaw < -32768 then yaw = yaw + 65536 end

    local pitch = angleToPlayerPitch
    if pitch >  32767 then pitch = pitch - 65536 end
    if pitch < -32768 then pitch = pitch + 65536 end

    yaw = _max(-limitYaw, _min(limitYaw, yaw))
    pitch = _max(-limitPitch, _min(limitPitch, pitch))

    if model == E_MODEL_EYEROK_LEFT_HAND then
        yaw = -yaw
    end

    rotN.rotation.x = yaw   & 0xFFFF
    rotN.rotation.y = 0
    rotN.rotation.z = pitch & 0xFFFF
end
