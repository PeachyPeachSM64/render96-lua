require("/constants")

-- Config Character Select to add Vanilla models
--local E_MODEL_R96_MARIO = smlua_model_util_get_id("r96_mario_geo")
--_G.charSelect.character_add_costume(CT_MARIO, "Vanilla Mario", nil, nil, nil, E_MODEL_MARIO)
--_G.charSelect.character_edit(CT_MARIO, nil, nil, "Render96", nil, E_MODEL_R96_MARIO)

-----------
-- Hooks --
-----------

local function open_hands_during_jumbo_star_flying(m)
    if m.action == ACT_JUMBO_STAR_CUTSCENE and m.actionArg == 2 then -- JUMBO_STAR_CUTSCENE_FLYING
        m.marioBodyState.handState = MARIO_HAND_OPEN
    end
end

local function restore_vanilla_gameover()
    if gNetworkPlayers[0].currActNum == 99 then -- in credits
        gLevelValues.entryLevel = SPECIAL_WARP_TITLE
    elseif gNetworkPlayers[0].currLevelNum == LEVEL_CASTLE_GROUNDS then
        gLevelValues.entryLevel = SPECIAL_WARP_GODDARD_GAMEOVER
    end
end

hook_event(HOOK_MARIO_UPDATE, open_hands_during_jumbo_star_flying)
hook_event(HOOK_UPDATE, restore_vanilla_gameover)
