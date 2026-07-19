require("/constants")

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_big_bully_render96_init(o)
    cur_obj_scale(2)
end

---@param o Object
local function bhv_bully_render96_loop(o)
    obj_update_eye_blink(o, 4, 10, 30, 100)
end

id_bhvRender96Bully = hook_render96_behavior(id_bhvSmallBully, false, nil, bhv_bully_render96_loop)
id_bhvRender96SmallChillBully = hook_render96_behavior(id_bhvSmallChillBully, false, nil, bhv_bully_render96_loop)

---@param o Object
local function bhv_big_chill_bully_with_minions_render96_init(o)
    o.oFlags = OBJ_FLAG_SET_FACE_YAW_TO_MOVE_YAW | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    o.oAnimations = gObjectAnimations.bully_seg5_anims_0500470C
    o.oFloorHeight = find_floor_height(o.oPosX, o.oPosY + 200, o.oPosZ)
    o.oPosY = o.oFloorHeight + 1000
    obj_set_home(o, o.oPosX, o.oFloorHeight, o.oPosZ)

    bhv_big_bully_init()
    bhv_big_bully_render96_init(o)
    cur_obj_hide()
    cur_obj_become_intangible()
    o.oAction = BULLY_ACT_INACTIVE
    o.oSubAction = 0
    o.oBullySubtype = BULLY_STYPE_CHILL
end

---@param o Object
local function bhv_big_chill_bully_with_minions_render96_loop(o)
    if o.oAction == BULLY_ACT_INACTIVE then
        bhv_big_bully_with_minions_loop()

        -- spawn minions
        -- sync objects can't be spawned during init (not sync valid)
        if should_spawn_sync_objects() then
            if o.oSubAction == 0 then
                for _, pos in ipairs({
                    {x = 125, y = 1331, z = -4100},
                    {x = 600, y = 1331, z = -4485},
                    {x = 200, y = 1331, z = -4900},
                }) do
                    local bully = spawn_sync_object(id_bhvSmallBully, E_MODEL_CHILL_BULLY, pos.x, pos.y, pos.z)
                    if not bully then return end
                    obj_set_home(bully, bully.oPosX, bully.oPosY, bully.oPosZ)
                    bully.oGravity = 8
                    bully.parentObj = o
                    bully.oBullySubtype = BULLY_STYPE_MINION
                    bully.oBehParams2ndByte = BULLY_BP_SIZE_SMALL
                end
                o.oSubAction = 1
            end
        else
            o.oSubAction = 1
        end

    elseif o.oAction == BULLY_ACT_ACTIVATE_AND_FALL then
        bhv_big_bully_with_minions_loop()

    else
        o.oIntangibleTimer = 0
        bhv_bully_loop()

        -- delete all minions
        -- if the boss is here, they're supposed to be dead
        local bully = obj_get_first_with_behavior_id(id_bhvSmallBully)
        while bully do
            if bully.parentObj == o then
                obj_mark_for_deletion(bully)
            end
            bully = obj_get_next_with_same_behavior_id(bully)
        end

        -- sync death (the game just seems to forget sometimes)
        if o.oAction == BULLY_ACT_LAVA_DEATH then
            network_send_object(o, true)
        end
    end
    bhv_bully_render96_loop(o)
end

id_bhvRender96BigBully = hook_render96_behavior(id_bhvBigBully, false, bhv_big_bully_render96_init, bhv_bully_render96_loop)
id_bhvRender96BigBullyWithMinions = hook_render96_behavior(id_bhvBigBullyWithMinions, false, bhv_big_bully_render96_init, bhv_bully_render96_loop)
id_bhvRender96BigChillBully = hook_render96_behavior(id_bhvBigChillBully, true, bhv_big_chill_bully_with_minions_render96_init, bhv_big_chill_bully_with_minions_render96_loop)
