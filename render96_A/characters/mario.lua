require("/constants")

-- Config Character Select to add Vanilla models
--local E_MODEL_R96_MARIO = smlua_model_util_get_id("r96_mario_geo")
--_G.charSelect.character_add_costume(CT_MARIO, "Vanilla Mario", nil, nil, nil, E_MODEL_MARIO)
--_G.charSelect.character_edit(CT_MARIO, nil, nil, "Render96", nil, E_MODEL_R96_MARIO)

-------------
-- Actions --
-------------

local function act_jump_no_control_height(m)
    if check_kick_or_dive_in_air(m) == 1 then
        return 1
    end

    if m.input & INPUT_Z_PRESSED ~= 0 then
        return set_mario_action(m, ACT_GROUND_POUND, 0)
    end

    play_mario_sound(m, SOUND_ACTION_TERRAIN_JUMP, 0)
    common_air_action_step(m, ACT_JUMP_LAND, CHAR_ANIM_SINGLE_JUMP, AIR_STEP_CHECK_LEDGE_GRAB | AIR_STEP_CHECK_HANG)
    return 0
end

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

hook_mario_action(ACT_JUMP_NO_CONTROL_HEIGHT, act_jump_no_control_height)

-------------------
-- Geo functions --
-------------------

local R96_EYES_OPEN = 0
local R96_EYES_HALF_CLOSED = 1
local R96_EYES_CLOSED = 2
local R96_EYES_HALF_OPEN = 3
local R96_EYES_ANGRY = 4
local R96_EYES_HAPPY = 5
local R96_EYES_EXHAUSTED = 6
local R96_EYES_DEAD = 7
local R96_EYES_HURT = 8

local R96_FACE_DEFAULT = 0
local R96_FACE_HAPPY = 3
local R96_FACE_ANGRY = 4
local R96_FACE_OPEN = 5

local sMarioBlinkAnimation = { 0, 1, 2, 1, 0, 1, 2, 1, 0 }

-- blink twice then have half-shut eyes (see end_peach_cutscene_kiss_from_peach)
local sMarioBlinkEnding = {
    [90]  = R96_EYES_HALF_CLOSED,
    [92]  = R96_EYES_CLOSED,
    [94]  = R96_EYES_HALF_CLOSED,
    [96]  = R96_EYES_OPEN,
    [98]  = R96_EYES_HALF_CLOSED,
    [100] = R96_EYES_CLOSED,
    [102] = R96_EYES_HALF_CLOSED,
    [104] = R96_EYES_OPEN,
    [106] = R96_EYES_HALF_CLOSED,
    [108] = R96_EYES_CLOSED,
}

function geo_switch_mario_eye_custom(node, matStackIndex)
    local switchCase = cast_graph_node(node) ---@type GraphNodeSwitchCase
    local m = geo_get_mario_state()
    local marioAction = m.action
    local marioHurtCounter = m.hurtCounter
    local marioHealth = m.health

    if m.actionArg == 8 then -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        local eye_sync = sMarioBlinkEnding[m.actionTimer]
        if eye_sync then switchCase.selectedCase = eye_sync end
        if m.actionTimer == 75  then switchCase.selectedCase = R96_EYES_HALF_CLOSED end
        if m.actionTimer == 76  then switchCase.selectedCase = R96_EYES_CLOSED end
        if m.actionTimer == 110 then switchCase.selectedCase = R96_EYES_HALF_CLOSED end
    end
    if m.actionArg == 9 then
        if m.actionTimer == 0  then switchCase.selectedCase = R96_EYES_HALF_CLOSED end
        if m.actionTimer == 58 then switchCase.selectedCase = R96_EYES_OPEN end
    end
    if m.actionArg ~= 8 and m.actionArg ~= 9 then
        m.marioObj.oMarioBlinkTimer = m.marioObj.oMarioBlinkTimer + 1

        if m.marioObj.oMarioBlinkFrame == 4 then
            if m.marioObj.oMarioBlinkTimer % 20 == 0 then
                m.marioObj.oMarioBlinkFrame = m.marioObj.oMarioBlinkFrame + 1
                m.marioObj.oMarioBlinkTimer = 0
            end
        elseif m.marioObj.oMarioBlinkFrame == 8 then
            if m.marioObj.oMarioBlinkTimer % 50 == 0 then
                m.marioObj.oMarioBlinkFrame = 1
                m.marioObj.oMarioBlinkTimer = 0
            end
        elseif (m.marioObj.oMarioBlinkFrame < 4 and m.marioObj.oMarioBlinkFrame >= 0) or (m.marioObj.oMarioBlinkFrame < 8 and m.marioObj.oMarioBlinkFrame > 4) then
            if m.marioObj.oMarioBlinkTimer % 2 == 0 then
                m.marioObj.oMarioBlinkFrame = m.marioObj.oMarioBlinkFrame + 1
            end
        end

        if gMarioEyeBlinkable[marioAction] then
            switchCase.selectedCase = sMarioBlinkAnimation[m.marioObj.oMarioBlinkFrame + 1]
        else
            m.marioObj.oMarioBlinkFrame = 1
            m.marioObj.oMarioBlinkTimer = 0
            switchCase.selectedCase = R96_EYES_OPEN
        end

        if (marioAction & ACT_FLAG_ATTACKING) ~= 0 or
           (marioAction & ACT_FLAG_SWIMMING)  ~= 0 then
            switchCase.selectedCase = R96_EYES_ANGRY
        end

        if gMarioEyeOpenWalking[marioAction] then
            switchCase.selectedCase = R96_EYES_OPEN
        end

        if marioAction == ACT_START_SLEEPING then
            switchCase.selectedCase = R96_EYES_HALF_CLOSED
        end

        if marioAction == ACT_SLEEPING then
            switchCase.selectedCase = R96_EYES_CLOSED
        end

        if marioAction == ACT_CRAWLING then
            switchCase.selectedCase = R96_EYES_HALF_OPEN
        end

        if gMarioEyeHappy[marioAction] then
            switchCase.selectedCase = R96_EYES_HAPPY
        end

        if gMarioEyeDead[marioAction] then
            switchCase.selectedCase = R96_EYES_DEAD
        end

        if marioHurtCounter ~= nil and marioHurtCounter > 0 then
            switchCase.selectedCase = R96_EYES_HURT
        end

        if marioHealth ~= nil and marioHealth <= 0xFF then
            switchCase.selectedCase = R96_EYES_HURT
        end

        if marioAction == ACT_PANTING then
            switchCase.selectedCase = R96_EYES_EXHAUSTED
        end
    end
end

function geo_switch_mario_face(node, matStackIndex)
    local switchCase = cast_graph_node(node) ---@type GraphNodeSwitchCase
    local m = geo_get_mario_state()
    local marioAction = m.action
    local marioHurtCounter = m.hurtCounter
    local marioHealth = m.health

    if m.actionArg == 8 then -- END_PEACH_CUTSCENE_KISS_FROM_PEACH
        local lip_sync = gMarioLipSwitchEndingKiss[m.actionTimer]
        if lip_sync then switchCase.selectedCase = lip_sync end
    end
    if m.actionArg == 9 then
        local lip_sync = gMarioLipSwitchEndingHereWeGo[m.actionTimer]
        if lip_sync then switchCase.selectedCase = lip_sync end
    end
    if m.actionArg ~= 8 and m.actionArg ~= 9 then
        switchCase.selectedCase = R96_FACE_DEFAULT
        if gMarioFaceDefaultIdle[marioAction] then
            m.marioObj.oMarioLongJumpTimer = 0
            switchCase.selectedCase = R96_FACE_DEFAULT
        end

        if (marioAction & ACT_FLAG_ATTACKING) ~= 0 then
            switchCase.selectedCase = R96_FACE_ANGRY
        end

        if (marioAction & ACT_FLAG_SWIMMING) ~= 0 then
            switchCase.selectedCase = R96_FACE_DEFAULT
        end

        if marioAction == ACT_LONG_JUMP then
            m.marioObj.oMarioLongJumpTimer = m.marioObj.oMarioLongJumpTimer + 1
            switchCase.selectedCase = (m.marioObj.oMarioLongJumpTimer < 15)
                and R96_FACE_HAPPY
                or R96_FACE_OPEN
        end

        if gMarioFaceDefaultOther[marioAction] then
            switchCase.selectedCase = R96_FACE_DEFAULT
        end

        if gMarioFaceHappy[marioAction] then
            switchCase.selectedCase = R96_FACE_HAPPY
        end

        if gMarioFaceOpen[marioAction] then
            switchCase.selectedCase = R96_FACE_OPEN
        end

        if marioAction == ACT_SLEEPING then
            switchCase.selectedCase = (m.marioObj.oMarioSleepTimer % 3 == 0)
                and R96_FACE_OPEN
                or R96_FACE_DEFAULT
        end

        if marioAction ~= ACT_SLEEPING then
            m.marioObj.oMarioSleepTimer = 0
        end

        if marioHurtCounter ~= nil and marioHurtCounter > 0 then
            switchCase.selectedCase = R96_FACE_ANGRY
        end

        if marioHealth ~= nil and marioHealth <= 0xFF then
            switchCase.selectedCase = R96_FACE_ANGRY
        end

        if marioAction == ACT_PANTING then
            switchCase.selectedCase = R96_FACE_OPEN
        end
    end
end
