require("/constants")

local _abs = math.abs

------------------------
-- Behavior functions --
------------------------

---@param o Object
local function bhv_blargg_friendly_render96_init(o)
    local blarggFriendlyHitbox = get_temp_object_hitbox()
    blarggFriendlyHitbox.interactType = INTERACT_KOOPA_SHELL
    blarggFriendlyHitbox.downOffset = 0
    blarggFriendlyHitbox.damageOrCoinValue = 4
    blarggFriendlyHitbox.health = 1
    blarggFriendlyHitbox.numLootCoins = 1
    blarggFriendlyHitbox.radius = 100
    blarggFriendlyHitbox.height = 100
    blarggFriendlyHitbox.hurtboxRadius = 50
    blarggFriendlyHitbox.hurtboxHeight = 50

    obj_set_hitbox(o, blarggFriendlyHitbox)
    o.oAnimations = gObjectAnimations.blargg_seg5_anims_0500616C
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
    o.oAction = 0
    o.oHomeX = o.oPosX
    o.oHomeY = o.oPosY
    o.oHomeZ = o.oPosZ
    o.activeFlags = ACTIVE_FLAG_ACTIVE
    o.oFlags = o.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    cur_obj_scale(1)
end

---@param o Object
local function bhv_blargg_friendly_render96_explode(o)
    m.action = ACT_WALKING
    mario_stop_riding_object(m)
    obj_mark_for_deletion(o)
    local explosion = spawn_non_sync_object(id_bhvExplosion, E_MODEL_EXPLOSION, o.oPosX, o.oPosY, o.oPosZ, nil)
    explosion.oGraphYOffset = explosion.oGraphYOffset + 100.0
end

---@param o Object
local function bhv_blargg_friendly_render96_loop(o)
    cur_obj_init_animation(BLARGG_ANIM_SWIM)
    if o.oAction == 0 then
        cur_obj_update_floor_and_walls()
        cur_obj_if_hit_wall_bounce_away()

        if (o.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
            o.oAction = 1
            if m ~= nil then o.heldByPlayerIndex = m.playerIndex end
        end
        cur_obj_move_standard(-20)

    elseif o.oAction == 1 then
        o.activeFlags = ACTIVE_FLAG_ACTIVE
        cur_obj_enable_rendering()
        obj_copy_pos(o, m.marioObj)
        o.oFaceAngleYaw = m.marioObj.oMoveAngleYaw
        local floor = cur_obj_update_floor_height_and_get_floor()
        if _abs(o.oPosY - o.oFloorHeight) < 5.0 then
            if floor ~= nil and floor.type == SURFACE_BURNING then
                 spawn_non_sync_object(id_bhvKoopaShellFlame, E_MODEL_RED_FLAME, o.oPosX, o.oPosY, o.oPosZ, nil)
                 o.oTimer = 0
                 o.oMrISize = 1
                 cur_obj_scale(o.oMrISize)
            else
                if o.oTimer % 10 == 0 then
                    o.oMrISize = o.oMrISize - .1
                    cur_obj_scale(o.oMrISize)
                    if o.oMrISize <= 0.4 then
                        bhv_blargg_friendly_render96_explode(o)
                    end
                end
            end
        end
        if (o.oInteractStatus & INT_STATUS_STOP_RIDING) ~= 0 then
            bhv_blargg_friendly_render96_explode(o)
        end
    end
    o.oInteractStatus = 0
end

id_bhvRender96BlarggFriendly = hook_render96_behavior(nil, false, bhv_blargg_friendly_render96_init, bhv_blargg_friendly_render96_loop, OBJ_LIST_LEVEL, "BlarggFriendly")
