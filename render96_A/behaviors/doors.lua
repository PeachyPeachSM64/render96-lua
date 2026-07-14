--
-- TODO
-- probably more will end up here
--


local function update_outside_doors_model()
    if gNetworkPlayers[0].currLevelNum ~= LEVEL_CASTLE then
        local door = obj_get_first_with_behavior_id(id_bhvDoor)
        while door ~= nil and door.oSwitchState1 ~= 1 and obj_has_model_extended(door, E_MODEL_HMC_WOODEN_DOOR) ~= 0 do
            door.oSwitchState1 = 1
            door = obj_get_next_with_same_behavior_id(door)
        end
    end

end

hook_event(HOOK_ON_WARP, update_outside_doors_model)

