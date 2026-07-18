local version = require("version")

local _floor  = math.floor
local _max    = math.max
local _sqrt   = math.sqrt
local _sin    = math.sin
local _lerp   = math.lerp
local _clamp  = math.clamp
local _pi     = math.pi

r96lib = {}

r96lib.customObjectFields = {
    oColorR        = 's32',
    oColorG        = 's32',
    oColorB        = 's32',
    oShakeBasePosX = 'f32',
    oShakeBasePosY = 'f32',
    oShakeBasePosZ = 'f32',
}

define_custom_obj_fields(r96lib.customObjectFields)

--- For VSCode autocompletion
--- @class Object
--- @field oColorR integer
--- @field oColorG integer
--- @field oColorB integer
--- @field oShakeBasePosX number
--- @field oShakeBasePosY number
--- @field oShakeBasePosZ number

-----------
-- Audio --
-----------

local objSoundData = {}

-- Emulates a ModAudio Stream being attached to an object, including doppler effects for non-music
---@param o Object The object the audio is from
---@param audioStream ModAudio An ModAudio Stream
---@param rangeMin number? The range in units at which audio is loudest (1)
---@param rangeMax number? The range in units at which audio is quietest (0)
---@param isMusic boolean? Wheather the audio is forced looped and the Doppler Effect is deactivated
function r96lib.audio_fade(o, audioStream, rangeMin, rangeMax, isMusic, loopingStart, loopingEnd)
    if o == nil or audioStream == nil then return end
    if version.MOD_AUDIO_OVERHAUL then
        if (audioStream.flags & 0x3) ~= MA_TYPE_STREAM then return end
    else
        if not audioStream.isStream then return end
    end

    local m = gMarioStates[0]
    local wallInterupt = collision_find_surface_on_ray(m.pos.x, m.pos.y + 70, m.pos.z, o.oPosX - m.pos.x, (o.oPosY + o.hitboxHeight*0.5) - (m.pos.y + 70), o.oPosZ - m.pos.z, 128).surface ~= nil
    local objDist = _sqrt((o.oPosX - m.pos.x)^2 + (o.oPosY - m.pos.y)^2 + (o.oPosZ - m.pos.z)^2) * (wallInterupt and 2 or 1)

    if not objSoundData[audioStream._pointer] then
        objSoundData[audioStream._pointer] = {
            audioStream = audioStream,
            volume = 0,
            nearestObj = nil,
            nearestDist = 0,
            prevDist = 0,
            nearestMin = 0,
            nearestMax = 0,
            isMusic = isMusic,
            loopStart = loopingStart,
            loopEnd = loopingEnd,
        }
    end

    local hitbox = _max(_sqrt(o.hitboxRadius^2 + o.hitboxHeight^2), _sqrt(o.hurtboxRadius^2 + o.hurtboxHeight^2))
    rangeMin = rangeMin or hitbox*5
    rangeMax = rangeMax or hitbox*25

    local audioData = objSoundData[audioStream._pointer]
    if audioData.nearestObj == nil or (objDist < audioData.nearestDist) then
        audioData.nearestObj = o
        audioData.nearestDist = objDist
        audioData.nearestMin = rangeMin
        audioData.nearestMax = rangeMax
    end
end

local function update_obj_audio()
    for _, audioData in pairs(objSoundData) do
        if audioData.isMusic then
            if not audio_stream_get_looping(audioData.audioStream) then
                audio_stream_set_looping(audioData.audioStream, true)
                if audioData.loopStart and audioData.loopEnd then
                    audio_stream_set_loop_points(audioData.audioStream, audioData.loopStart, audioData.loopEnd)
                end
            end
        else
            -- Update Doppler effect
            if not audioData.isMusic then
                audio_stream_set_frequency(audioData.audioStream, 1 - (audioData.nearestDist - audioData.prevDist)/_lerp(audioData.nearestMin, audioData.nearestMax, 0.1))
                audioData.prevDist = audioData.nearestDist
            end
        end

        local volume = 1 - _clamp((audioData.nearestDist - audioData.nearestMin)/(audioData.nearestMax), 0, 1)
        if not audioData.nearestObj then
            volume = 0
        elseif volume > 0 then
            audio_stream_play(audioData.audioStream, false, 0)
        end
        audioData.volume = _lerp(audioData.volume, volume, 0.2)
        audio_stream_set_volume(audioData.audioStream, audioData.volume)

        audioData.nearestObj = nil
        audioData.nearestDist = 0
        audioData.nearestMin = 0
        audioData.nearestMax = 0
    end
end

hook_event(HOOK_UPDATE, update_obj_audio)

-------------
-- Objects --
-------------

function r96lib.spawn_object(modelId, bhvId, x, y, z, rx, ry, rz, func)
    local childObj = spawn_non_sync_object(bhvId, modelId, 0, 0, 0, func)
    if childObj == nil then return nil end
    obj_set_pos(childObj, x, y, z)
    obj_set_angle(childObj, rx, ry, rz)
    return childObj
end

function r96lib.spawn_object_param(cond, modelId, bhvId, bhvParam, x, y, z, rx, ry, rz, func)
    if cond == true then
    local childObj = spawn_non_sync_object(bhvId, modelId, 0, 0, 0, func)
        if childObj == nil then return nil end
        obj_set_pos(childObj, x, y, z)
        obj_set_angle(childObj, rx, ry, rz)
        childObj.oBehParams2ndByte = bhvParam
        return childObj
    end
end

function r96lib.squish_apply(o, timer, duration, intensityX, intensityY, intensityZ, baseScale, sound)
    if o == nil then return 0 end
    if duration == nil or duration <= 0 then
        return 0
    end

    timer = timer or 0
    baseScale = baseScale or 1

    intensityX = intensityX or 0
    intensityY = intensityY or 0
    intensityZ = intensityZ or 0

    -- Normalize time into [0, 1]
    local t = timer / duration
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end

    -- Smooth peak-at-middle curve:
    -- I googled this and it works xD
    local peak = _sin(_pi * t)

    -- Play the sound once at the peak frame.
    if sound ~= nil then
        local mid = _floor(duration * 0.5)
        if timer == mid then
            local audioStream = audio_stream_load(sound)
            if audioStream ~= nil then
                audio_stream_play(audioStream, false, 1)
            end
        end
    end

    -- Apply the scale intensity
    local sx = baseScale * (1.0 + (intensityX * peak))
    local sy = baseScale * (1.0 + (intensityY * peak))
    local sz = baseScale * (1.0 + (intensityZ * peak))

    vec3f_set(o.header.gfx.scale, sx, sy, sz)

    return peak
end

function r96lib.shake_apply(o, timer, duration, intensityX, intensityY, intensityZ)
    if o == nil then return 0 end
    if duration == nil or duration <= 0 then return 0 end

    timer = timer or 0

    intensityX = intensityX or 0
    intensityY = intensityY or 0
    intensityZ = intensityZ or 0

    -- Store base position on first call of shake sequence
    if timer == 0 then
        o.oShakeBasePosX = o.oPosX
        o.oShakeBasePosY = o.oPosY
        o.oShakeBasePosZ = o.oPosZ
    end

    local basePosX = o.oShakeBasePosX or o.oPosX
    local basePosY = o.oShakeBasePosY or o.oPosY
    local basePosZ = o.oShakeBasePosZ or o.oPosZ

    -- Normalize the time so that it outputs correctly
    local t = timer / duration
    if t < 0 then t = 0 end
    if t > 1 then t = 1 end

    local peak = _sin(_pi * t)

    local ox = (_sin(timer * 6.9) + _sin(timer * 15.3)) * 0.5 * intensityX * peak
    local oy = (_sin(timer * 7.2) + _sin(timer * 13.7)) * 0.5 * intensityY * peak
    local oz = (_sin(timer * 8.1) + _sin(timer * 14.1)) * 0.5 * intensityZ * peak

    o.oPosX = basePosX + ox
    o.oPosY = basePosY + oy
    o.oPosZ = basePosZ + oz

    return peak
end

----------
-- Data --
----------

local DATA_NUM_BITS = 8

local sDataCache = {}

r96lib.DATA_DEFAULT = string.rep("0", DATA_NUM_BITS) -- "00000000"

function r96lib.save_data(name, data)
    if data then
        mod_storage_save(name, data)
        sDataCache[name] = data
        return true
    end
    return false
end

function r96lib.load_data(name)
    local data = sDataCache[name]
    if data ~= nil then
        return data
    end

    -- Load if it exists, or save default value
    if mod_storage_exists(name) then
        data = mod_storage_load(name)
    else
        data = r96lib.DATA_DEFAULT
        mod_storage_save(name, data)
    end

    sDataCache[name] = data
    return data
end

function r96lib.check_data(data, index)
    return data and (data:sub(DATA_NUM_BITS - index, DATA_NUM_BITS - index) == "1")
end

function r96lib.count_data(data)
    -- 'select(2, ...)' returns the 2nd return value of 'data:gsub("1", "")',
    -- which is the number of occurrences of "1" in data
    return data and select(2, data:gsub("1", "")) or 0
end

function r96lib.update_data(data, index, value)
    -- Set value at the index position to '1'
    return data and (data:sub(1, DATA_NUM_BITS - 1 - index) .. tostring(value) .. data:sub(DATA_NUM_BITS + 1 - index)) or nil
end

-----------
-- Level --
-----------

local sSpawnTable = {}
local sSpawnedObjects = {}

-- Acts bitmask helpers
local ACT_ALL = 0x3F -- acts 1-6
local function act_bit(n) return 1 << (n - 1) end
local function act_matches(actMask, actNum)
    if actMask == nil or actMask == ACT_ALL then return true end
    return (actMask & act_bit(actNum)) ~= 0
end

-- Register a spawn entry for a level/area
-- acts can be nil (all acts), a single number, or a table like {1, 2, 5}
-- spawnFunc is optional: called with the object after spawn
function r96lib.add_spawn(level, area, model, bhv, x, y, z, rx, ry, rz, isSync, acts, spawnFunc)
    sSpawnTable[level] = sSpawnTable[level] or {}
    sSpawnTable[level][area] = sSpawnTable[level][area] or {}

    local actMask = ACT_ALL
    if type(acts) == "number" then
        actMask = act_bit(acts)
    elseif type(acts) == "table" then
        actMask = 0
        for _, a in ipairs(acts) do
            actMask = actMask | act_bit(a)
        end
    end

    table.insert(sSpawnTable[level][area], {
        bhv       = bhv,
        model     = model,
        x = x, y = y, z = z,
        rx = rx or 0, ry = ry or 0, rz = rz or 0,
        isSync = isSync,
        actMask   = actMask,
        spawnFunc = spawnFunc,
    })
end

-- Remove all registered spawns for a level/area
function r96lib.clear_spawns(level, area)
    if sSpawnTable[level] then
        sSpawnTable[level][area] = nil
    end
end

local function make_key(level, area, actNum, index)
    return level .. "_" .. area .. "_" .. actNum .. "_" .. index
end

local function spawn_objects()
    local level  = gNetworkPlayers[0].currLevelNum
    local area   = gNetworkPlayers[0].currAreaIndex
    local actNum = gNetworkPlayers[0].currActNum
    local entries = sSpawnTable[level] and sSpawnTable[level][area]
    if not entries then return end
    for i, entry in ipairs(entries) do
        if act_matches(entry.actMask, actNum) then
            local key = make_key(level, area, actNum, i)
            if not sSpawnedObjects[key] then
                sSpawnedObjects[key] = true
                local spawnFn
                if not entry.isSync then
                    spawnFn = spawn_non_sync_object
                elseif is_other_player_in_local_area() == 0 then -- do not spawn a sync object again in an already loaded level
                    spawnFn = spawn_sync_object
                end
                if spawnFn then
                    spawnFn(entry.bhv, entry.model,
                        entry.x, entry.y, entry.z,
                        function(o)
                            obj_set_angle(o, entry.rx, entry.ry, entry.rz)
                            if entry.spawnFunc then entry.spawnFunc(o) end
                        end)
                end
            end
        end
    end
end

local function clear_spawned_objects_and_gfx_data()
    sSpawnedObjects = {}
    gfx_delete_all()
end

hook_event(HOOK_ON_SYNC_VALID, spawn_objects)
hook_event(HOOK_ON_LEVEL_INIT, clear_spawned_objects_and_gfx_data)

------------
-- Models --
------------

local sModelOverrides = {}
local sOverridesByBhv = nil

function r96lib.add_model_override(bhv, model)
    table.insert(sModelOverrides, {
        bhv   = bhv,
        model = model,
    })
    sOverridesByBhv = nil
end

function r96lib.add_model_override_param(bhv, param, model)
    table.insert(sModelOverrides, {
        bhv   = bhv,
        model = model,
        param = param,
    })
    sOverridesByBhv = nil
end

function r96lib.add_model_override_level(bhv, model, model2, level, area, acts)
    local actMask = ACT_ALL
    if type(acts) == "number" then
        actMask = act_bit(acts)
    elseif type(acts) == "table" then
        actMask = 0
        for _, a in ipairs(acts) do
            actMask = actMask | act_bit(a)
        end
    end

    table.insert(sModelOverrides, {
        bhv     = bhv,
        model   = model,
        model2  = model2,
        level   = level,
        area    = area,
        actMask = actMask,
    })
    sOverridesByBhv = nil
end

local function rebuild_model_override_index()
    sOverridesByBhv = {}
    for _, entry in ipairs(sModelOverrides) do
        local list = sOverridesByBhv[entry.bhv]
        if not list then
            list = {}
            sOverridesByBhv[entry.bhv] = list
        end
        table.insert(list, entry)
    end
end

local function apply_entries_to_objects(o, entries, level, area, actNum)
    local curModel = obj_get_model_id_extended(o)

    for i = 1, #entries do
        local entry = entries[i]

        if entry.level then
            -- add_model_override_level
            if entry.level == level and entry.area == area
            and act_matches(entry.actMask, actNum)
            and curModel == entry.model2 then
                obj_set_model_extended(o, entry.model)
                return
            end
        elseif entry.param then
            -- add_model_override_param
            if entry.param == o.oBehParams and curModel ~= entry.model then
                obj_set_model_extended(o, entry.model)
                return
            end
        else
            -- add_model_override
            if curModel ~= entry.model then
                obj_set_model_extended(o, entry.model)
                return
            end
        end
    end
end

local function update_objects_model()
    if not sOverridesByBhv then
        rebuild_model_override_index()
    end

    local level  = gNetworkPlayers[0].currLevelNum
    local area   = gNetworkPlayers[0].currAreaIndex
    local actNum = gNetworkPlayers[0].currActNum

    for bhv, entries in pairs(sOverridesByBhv) do
        local o = obj_get_first_with_behavior_id(bhv)
        while o ~= nil do
            apply_entries_to_objects(o, entries, level, area, actNum)
            o = obj_get_next_with_same_behavior_id(o)
        end
    end
end

hook_event(HOOK_UPDATE, update_objects_model)

-----------------
-- Gfx effects --
-----------------

---@param o Object
---@param colors table
---@param framesPerColor number?
function r96lib.pulse_cycle(o, colors, framesPerColor)
    local frame = o.oTimer % (#colors * framesPerColor)
    local i = _floor(frame / framesPerColor) + 1
    local c1, c2 = colors[i], colors[(i % #colors) + 1]
    local t = (frame % framesPerColor) / framesPerColor
    o.oColorR = _lerp(c1.r, c2.r, t)
    o.oColorG = _lerp(c1.g, c2.g, t)
    o.oColorB = _lerp(c1.b, c2.b, t)
end

---@param o Object
---@param colors table
---@param t number
---@param timeMax number?
function r96lib.pulse_ramp(o, colors, t, timeMax)
    local freq = 0.02 + (t / timeMax) * 0.3
    local s = _sin((t * freq) - _pi * 0.5) * 0.5 + 0.5
    local c1, c2 = colors[1], colors[2]
    o.oColorR = _lerp(c1.r, c2.r, s)
    o.oColorG = _lerp(c1.g, c2.g, s)
    o.oColorB = _lerp(c1.b, c2.b, s)
    if t >= timeMax then
        o.oColorR = c1.r
        o.oColorG = c1.g
        o.oColorB = c1.b
    end
end

---@param o Object
---@param colors table
---@param t number
---@param speed number?
function r96lib.pulse_rapid(o, colors, t, speed)
    local s = _sin(t * speed) * 0.5 + 0.5
    local c1, c2 = colors[1], colors[2]
    o.oColorR = _lerp(c1.r, c2.r, s)
    o.oColorG = _lerp(c1.g, c2.g, s)
    o.oColorB = _lerp(c1.b, c2.b, s)
end

local sGfxColorPatches = {}

---@param node GraphNode
---@param opts table
function r96lib.gfx_color_patch(node, opts)
    local o = geo_get_current_object()
    if o == nil then return end
    local prefix    = opts.prefix
    local origMat   = opts.origMat
    local primIndex = opts.primIndex
    sGfxColorPatches[prefix] = true
    local id       = tostring(o._pointer)
    local mat_name = prefix .. "_mat_" .. id
    local gfx_mat = gfx_get_from_name(mat_name)
    if gfx_mat == nil then
        local orig = gfx_get_from_name(origMat)
        if orig == nil then return end
        local len = gfx_get_length(orig)
        gfx_mat = gfx_create(mat_name, len)
        gfx_copy(gfx_mat, orig, len)
        --print("original: " .. origMat)
        --for i = 0, len - 1 do
        --    local cmd = gfx_get_command(orig, i)
        --    print(i, "op:", gfx_get_op(cmd), string.format("w0:0x%08X w1:0x%08X", cmd.w0, cmd.w1))
        --end
        --print("clone: " .. mat_name)
        --for i = 0, len - 1 do
        --    local cmd = gfx_get_command(gfx_mat, i)
        --    print(i, "op:", gfx_get_op(cmd), string.format("w0:0x%08X w1:0x%08X", cmd.w0, cmd.w1))
        --end
    end
    local cmd_prim = gfx_get_command(gfx_mat, primIndex)
    gfx_set_command(cmd_prim, "gsDPSetPrimColor(0, 0, %i, %i, %i, 255)", o.oColorR, o.oColorG, o.oColorB)
    local matdisplayList = cast_graph_node(node.next) ---@type GraphNodeDisplayList
    if matdisplayList == nil or matdisplayList.displayList == nil then return end
    local cmd_display_list = gfx_get_command(matdisplayList.displayList, 0)
    gfx_set_command(cmd_display_list, "gsSPDisplayList(%g)", gfx_mat)
end

local sGfxColorPatchesCache = {}

---@param node GraphNode
---@param opts table
function r96lib.gfx_color_patch_by_name(node, opts)
    local o = geo_get_current_object()
    if o == nil then return end
    local r, g, b = o.oColorR, o.oColorG, o.oColorB
    local origDl = opts.origDl
    local cache = sGfxColorPatchesCache[origDl]
    if cache == nil then
        local gfx = gfx_get_from_name(origDl)
        if gfx == nil then return end
        local cmds = {}
        local function parse_dl(cmd, op)
            if op == G_SETPRIMCOLOR then
                cmds[#cmds + 1] = cmd
            end
        end
        gfx_parse(gfx, parse_dl)
        for i = 1, #cmds do
            gfx_set_command(cmds[i], "gsDPSetPrimColor(0, 0, %i, %i, %i, 255)", r, g, b)
        end
        sGfxColorPatchesCache[origDl] = { cmds = cmds, r = r, g = g, b = b }
        return
    end
    if cache.r == r and cache.g == g and cache.b == b then return end
    local cmds = cache.cmds
    for i = 1, #cmds do
        gfx_set_command(cmds[i], "gsDPSetPrimColor(0, 0, %i, %i, %i, 255)", r, g, b)
    end
    cache.r, cache.g, cache.b = r, g, b
end

---@param o Object
local function delete_object_gfx_data(o)
    local id = tostring(o._pointer)
    for prefix, _ in pairs(sGfxColorPatches) do
        local mat = gfx_get_from_name(prefix .. "_mat_" .. id)
        if mat then gfx_delete(mat) end
    end
end

hook_event(HOOK_ON_OBJECT_UNLOAD, delete_object_gfx_data)

-----------------
-- Held object --
-----------------

---@param o Object
---@param opts table
local function obj_thrown_death(o, opts)
    spawn_mist_particles()
    obj_spawn_yellow_coins(o, o.oNumLootCoins)
    create_sound_spawner(SOUND_OBJ_STOMPED)
    if opts.audio then
        audio_stream_stop(opts.audio)
    end
    obj_mark_for_deletion(o)
end

---@param o Object
---@param opts table
local function obj_thrown_update(o, opts)
    cur_obj_update_floor_and_walls()
    cur_obj_move_standard(-78)

    local interactions = opts.interactions or nil
    if interactions ~= nil then
        interactions:process_interactions(o)
    end

    local enemy = opts.enemy or false
    if enemy == true then
        o.oGravity    = opts.gravity    or -2.5
        o.oFriction   = opts.friction   or 0.99
        o.oBuoyancy   = opts.buoyancy   or 1.4
        o.oForwardVel = opts.forwardVel or 40.0

        if (o.oMoveFlags & OBJ_MOVE_LANDED)        ~= 0
        or (o.oMoveFlags & OBJ_MOVE_HIT_WALL)      ~= 0
        or (o.oMoveFlags & OBJ_MOVE_MASK_IN_WATER) ~= 0 then
            obj_thrown_death(o, opts)
            return
        end

        if (o.oMoveFlags & OBJ_MOVE_ABOVE_LAVA) ~= 0 then
            obj_mark_for_deletion(o)
            return
        end
        if opts.audio then
            r96lib.audio_fade(o, opts.audio, nil, nil, false)
        end
    end

    if enemy == false then
        spawn_non_sync_object(id_bhvSparkleSpawn, E_MODEL_NONE, o.oPosX, o.oPosY, o.oPosZ, nil)
        o.oFaceAngleYaw = o.oFaceAngleYaw + 0x1000
        o.oGravity = -2.5
        o.oFriction = 0.99
        o.oBuoyancy = 1.4

        if o.oTimer < 150 then o.oForwardVel = 50.0
        elseif o.oTimer < 300 and o.oTimer > 150 then o.oForwardVel = 35.0
        elseif o.oTimer < 450 and o.oTimer > 300 then o.oForwardVel = 20.0
        elseif o.oTimer >= 550 then o.oForwardVel = 0.0 end

        if (o.oMoveFlags & OBJ_MOVE_HIT_EDGE) ~= 0 or o.oMoveFlags & OBJ_MOVE_HIT_WALL ~= 0 then
            o.oMoveAngleYaw = obj_angle_to_object(o, nearest_player_to_object(o))
            return
        end

        if opts.audio and o.oForwardVel > 5 then
            r96lib.audio_fade(o, opts.audio, nil, nil, false)
        end
    end
end

---@param o Object
local function obj_update_held_state(o)
    if o.oHeldState == HELD_HELD then
        o.header.gfx.node.flags = o.header.gfx.node.flags | GRAPH_RENDER_INVISIBLE
        cur_obj_become_intangible()
    elseif o.oHeldState == HELD_THROWN then
        cur_obj_become_tangible()
        o.header.gfx.node.flags = o.header.gfx.node.flags & ~GRAPH_RENDER_INVISIBLE
        o.oVelY = 20.0
        o.oHeldState = HELD_FREE
    end
end

---@param m MarioState
---@param o Object
---@param opts table
function r96lib.update_held_object(m, o, opts)
    obj_update_held_state(o)

    if m.heldObj == o then
        o.oHeldState = HELD_HELD
        o.oAction = 50
    end

    if m.heldObj ~= o and o.oAction == 50 and o.oHeldState == HELD_HELD then
        o.oHeldState = HELD_THROWN
        o.oTimer = 0
    end

    if m.heldObj ~= o and o.oAction == 50 and o.oHeldState == HELD_FREE then
        obj_thrown_update(o, opts)
        return
    end

    if (m.action == ACT_HOLD_WATER_IDLE or m.action == ACT_HOLD_WATER_ACTION_END)
    and m.heldObj == o then
        mario_drop_held_object(m)
    end
end

return r96lib