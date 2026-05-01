
bloWarps = {}

local npl = gNetworkPlayers -- ain't no one got time to write all that

define_custom_obj_fields({
    oCustomWarpNode = "u32",
})

local sWarpTable = {}
local sActiveWarp = nil

local WARP_DURATION = 25

local sWarpInteractions = {
    [INTERACT_WARP] = ACT_DISAPPEARED,
}

function bloWarps.newWarpNode(level, area, node, targetLevel, targetArea, targetNode, entryFunc, exitFunc, overrideVanilla)
    sWarpTable[level] = sWarpTable[level] or {}
    sWarpTable[level][area] = sWarpTable[level][area] or {}
    sWarpTable[level][area][node] = sWarpTable[level][area][node] or {}

    local warp = sWarpTable[level][area][node]

    warp.level = level
    warp.area = area
    warp.node = node

    warp.targetLevel = targetLevel
    warp.targetArea = targetArea
    warp.targetNode = targetNode
    warp.overrideVanilla = overrideVanilla
    warp.entryFunc = entryFunc
    warp.exitFunc = exitFunc

    return warp
end

local sWarpObjs = {}

local function get_lvl_warp_objs(level, area)
    return sWarpObjs[level] and sWarpObjs[level][area]
end

local function get_exit_warp_obj(targetNode)
    for objList = 0, NUM_OBJ_LISTS - 1 do
        local o = obj_get_first(objList)
        while o ~= nil do
            local warpnodeID = (o.oBehParams >> 16) & 0xFF
            if warpnodeID == targetNode and sWarpInteractions[o.oInteractType] then
                return o
            end
            o = obj_get_next(o)
        end
    end
end

local function set_behavior_param(o, index, value)
    local shift = (4 - index) * 8
    local mask = ~(0xFF << shift)
    o.oBehParams = (o.oBehParams & mask) | ((value & 0xFF) << shift)
end

function bloWarps.createWarpObj(bhv, model, node, spawnFunc, level, area, pos, angle)
    sWarpObjs[level] = sWarpObjs[level] or {}
    sWarpObjs[level][area] = sWarpObjs[level][area] or {}

    sWarpObjs[level][area][node] = sWarpObjs[level][area][node] or {}

    local warpObj = sWarpObjs[level][area][node]

    angle = angle or {}
    angle[1] = angle[1] or 0
    angle[2] = angle[2] or 0
    angle[3] = angle[3] or 0

    warpObj.bhv = bhv
    warpObj.model = model
    warpObj.spawnFunc = spawnFunc
    warpObj.pos = pos
    warpObj.angle = angle
    warpObj.node = node
    warpObj.index = node
    return warpObj
end

function bloWarps.deleteWarpObj(level, area, node)
    local warps = get_lvl_warp_objs(level, area)
    if warps then
        local warpObj = warps[node]
        if warpObj then
            local exitObj = get_exit_warp_obj(node)
            if exitObj then
                obj_mark_for_deletion(exitObj)
            end
            warps[node] = nil
            return true
        end
    end
    return false
end

function bloWarps.getWarp(level, area, warpnodeID)
    return sWarpTable[level] and sWarpTable[level][area] and sWarpTable[level][area][warpnodeID]
end

local function allow_interact(m, o, int)
    if m.playerIndex ~= 0 then return end
    if not sWarpInteractions[int] then return end
    local level = npl[0].currLevelNum
    local area = npl[0].currAreaIndex
    local warpnodeID = (o.oBehParams >> 16) & 0xFF
    local customNode = bloWarps.getWarp(level, area, warpnodeID)

    if not customNode then return end

    local vanillaNode = area_get_warp_node_from_params(o) and area_get_warp_node_from_params(o).node
    
    if vanillaNode and not customNode.overrideVanilla then
        return true
    else
        if customNode.entryFunc then
            customNode.entryFunc(m, o)
        end
        local targetAction = sWarpInteractions[int]
        if m.action ~= targetAction then
            m.interactObj = o
            play_transition(WARP_TRANSITION_FADE_INTO_CIRCLE, WARP_DURATION, 0, 0, 0)
            set_mario_action(m, targetAction, 0)
            customNode.timer = WARP_DURATION
            customNode.entryObj = o
            sActiveWarp = customNode
        end
        return false
    end
end

local function update()
    local level = npl[0].currLevelNum
    local area = npl[0].currAreaIndex
    local m = gMarioStates[0]

    local warps = get_lvl_warp_objs(level, area)
    if warps and m.marioObj then
        for _, obj in pairs(warps) do

            local warpObj = get_exit_warp_obj(obj.node)

            if not warpObj then
                spawn_non_sync_object(obj.bhv, obj.model, obj.pos[1], obj.pos[2], obj.pos[3], function (o)

                    set_behavior_param(o, 2, obj.node)
                    obj_set_angle(o, obj.angle[1], obj.angle[2], obj.angle[3])
                    if obj.spawnFunc then
                        obj.spawnFunc(o)
                    end
                end)
            end
        end
    end

    if not sActiveWarp then return end
    set_mario_action(m, ACT_UNINITIALIZED, 0)
    local newLevel = sActiveWarp.targetLevel
    local newArea = sActiveWarp.targetArea

    sActiveWarp.timer = sActiveWarp.timer - 1

    if sActiveWarp.timer > 0 then return end

    if newLevel ~= level then
        if not warp_to_level(newLevel, newArea, npl[0].currActNum) then
            warp_to_level(newLevel, 1, npl[0].currActNum) --* code below is gonna warp to the correct area anyway
        end
    elseif newArea ~= area then
        smlua_level_util_change_area(newArea)
    end

    local exitObj = get_exit_warp_obj(sActiveWarp.targetNode)

    if (sActiveWarp.timer + 5) > 0 or not exitObj then return end

    if not exitObj then djui_chat_message_create("uh oh! no exit pipe found, defaulting to marioObj") exitObj = m.marioObj end

    reset_camera(m.area.camera)

    m.pos.x = exitObj.oPosX
    m.pos.y = exitObj.oPosY
    m.pos.z = exitObj.oPosZ

    m.faceAngle.y = exitObj.oFaceAngleYaw

    local exitWarp = bloWarps.getWarp(newLevel, newArea, sActiveWarp.targetNode)
    if exitWarp.exitFunc then
        exitWarp.exitFunc(m, exitObj)
    end

    play_transition(WARP_TRANSITION_FADE_FROM_CIRCLE, 15, 0, 0, 0)
    sActiveWarp = nil
end

local function on_hud_render()
    if not sActiveWarp or sActiveWarp.timer > 0 then return end
    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_color(0, 0, 0, 255)
    djui_hud_render_rect(0, 0, djui_hud_get_screen_width() + 1, djui_hud_get_screen_height())
end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_ALLOW_INTERACT, allow_interact)
hook_event(HOOK_UPDATE, update)

return bloWarps