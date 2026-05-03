r96lib = {}

-- Acts
ACT_MILK_GROW = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)
ACT_MILK_SHRINK = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_IDLE | ACT_FLAG_ALLOW_FIRST_PERSON | ACT_FLAG_PAUSE_EXIT)
ACT_LUIGI_SCUTTLE_RUN = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_GROUP_AIRBORNE)
ACT_LUIGI_SCUTTLE_RUN_HOLD = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_GROUP_AIRBORNE)
ACT_LUIGI_BACKFLIP = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_LUIGI_TWIRLING = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_SWIMMING_OR_FLYING)
ACT_WARIO_CHARGE = allocate_mario_action(ACT_FLAG_MOVING | ACT_FLAG_ATTACKING)
ACT_WARIO_TRIPLE_JUMP = allocate_mario_action(ACT_GROUP_AIRBORNE | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_IDLE = allocate_mario_action(0x007 | ACT_FLAG_STATIONARY | ACT_FLAG_PAUSE_EXIT)
ACT_WARIO_HOLD_HEAVY_IDLE = allocate_mario_action(0x008 | ACT_FLAG_STATIONARY | ACT_FLAG_PAUSE_EXIT)
ACT_WARIO_HOLD_WALKING = allocate_mario_action(0x042 | ACT_FLAG_MOVING)
ACT_WARIO_HOLD_HEAVY_WALKING = allocate_mario_action(0x047 | ACT_FLAG_MOVING)
ACT_WARIO_HOLD_JUMP = allocate_mario_action(0x0A0 | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_HEAVY_JUMP = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION | ACT_FLAG_CONTROL_JUMP_HEIGHT)
ACT_WARIO_HOLD_FREEFALL = allocate_mario_action(0x0A1 | ACT_FLAG_AIR | ACT_FLAG_ALLOW_VERTICAL_WIND_ACTION)
ACT_WARIO_PILE_DRIVER = allocate_mario_action(ACT_FLAG_AIR | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_PILE_DRIVER_LAND = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_START = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_HELD = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)
ACT_WARIO_SWING_FLING_THROW = allocate_mario_action(ACT_FLAG_STATIONARY | ACT_FLAG_ATTACKING | ACT_FLAG_INVULNERABLE)

-- Models
E_MODEL_STAR_PARTICLE = smlua_model_util_get_id("star_particle_geo")
E_MODEL_STAR_TRANSPARENT_PARTICLE = smlua_model_util_get_id("star_particle_transparent_geo")
E_MODEL_BOO_KING = smlua_model_util_get_id("boo_king_geo")
E_MODEL_BOO_BIG = smlua_model_util_get_id("boo_big_geo")
E_MODEL_BULLY_BIG = smlua_model_util_get_id("bully_big_geo")
E_MODEL_BLARGG_FRIENDLY = smlua_model_util_get_id("blargg_friendly_geo")
E_MODEL_SPINDLE = smlua_model_util_get_id("spindle_geo")
E_MODEL_GRINDLE = smlua_model_util_get_id("grindle_geo")
--E_MODEL_TOXBOX = smlua_model_util_get_id("toxbox_geo")
E_MODEL_WARP_PIPE_BOO_BLUE = smlua_model_util_get_id("warp_pipe_boo_geo")
E_MODEL_WARP_PIPE_BOO_RED = smlua_model_util_get_id("warp_pipe_boo_red_geo")
E_MODEL_WARP_PIPE_BOO_GREEN_LOCKED = smlua_model_util_get_id("warp_pipe_boo_green_locked_geo")
E_MODEL_WARP_PIPE_BOO_GREEN_UNLOCKED = smlua_model_util_get_id("warp_pipe_boo_green_unlocked_geo")
E_MODEL_WARP_PIPE_BOO_YELLOW_LOCKED = smlua_model_util_get_id("warp_pipe_boo_yellow_locked_geo")
E_MODEL_WARP_PIPE_BOO_YELLOW_UNLOCKED = smlua_model_util_get_id("warp_pipe_boo_yellow_unlocked_geo")
E_MODEL_LUIGI_KEY = smlua_model_util_get_id("boo_key_geo")
E_MODEL_WARIO_PUMPKIN_COIN = smlua_model_util_get_id("wario_coin_pumpkin_geo")
E_MODEL_WARIO_HOUSE_COIN = smlua_model_util_get_id("wario_coin_house_geo")
E_MODEL_WARIO_TREE_COIN = smlua_model_util_get_id("wario_coin_tree_geo")
E_MODEL_WARIO_KOOPA_COIN = smlua_model_util_get_id("wario_coin_koopa_geo")
E_MODEL_WARIO_LUNAR_COIN = smlua_model_util_get_id("wario_coin_lunar_geo")
E_MODEL_WARIO_MARIO_COIN = smlua_model_util_get_id("wario_coin_mario_geo")
E_MODEL_WARIO_HEAD = smlua_model_util_get_id("wario_head_geo")

-- Levels
LEVEL_FOURTH_FLOOR = level_register("level_fourth_floor_entry", COURSE_NONE, "Fourth Floor", "fourth_floor", 28000, 0x28, 0x28, 0x28)

-- Anims
CHAR_ANIM_MILK_RUNNING = 'mario_milk_run'

-- Music
FADE_OUT = 0
FADE_IN = 1

GOT_MILK_POWERUP = "event_got_milk_powerup.mp3"
GOT_MILK_SONG = "event_got_milk.mp3"
BOO_PIPE_RED = 'event_mario_musicbox.mp3'
BOO_PIPE_GREEN = 'event_luigi_musicbox.mp3'
BOO_PIPE_YELLOW = 'event_wario_musicbox.mp3'
GOOMBA_SCREAM = "event_goomba_scream.mp3"

-- oAction states
GOOMBA_ACT_STUN = 3
GOOMBA_ACT_GRAB = 4
BLARGG_MODE_SWIM = 0
BLARGG_MODE_CHASE = 1
BLARGG_MODE_KNOCKBACK = 2
BLARGG_MODE_BACKUP = 3
KOOPA_SHELL_ACT_GRAB = 3
MR_I_IDLE = 0
MR_I_ATTACK = 1
MR_I_DIZZY = 2
MR_I_DEAD = 3

-- Eye states
GOOMBA_EYE_OPEN = 0
GOOMBA_EYE_CLOSE = 1
GOOMBA_EYE_DAZED = 2
MR_I_OPEN = 0
MR_I_ALMOST_OPEN = 1
MR_I_HALF_OPEN = 2
MR_I_ALMOST_CLOSED = 3
MR_I_CLOSED = 4

-- Face states
GOOMBA_FACE_CLOSE = 0
GOOMBA_FACE_OPEN = 1
TWHOMP_FACE_BASE = 0
TWHOMP_FACE_ANGRY = 1
TWHOMP_FACE_URGH = 2

-- Anim states
BLARGG_ANIM_SWIM = 0
BLARGG_ANIM_ATK = 1

function r96lib.spawn_object(modelId, bhvId, x, y, z, rx, ry, rz, func)
    local childObj = spawn_non_sync_object(bhvId, modelId, 0, 0, 0, func)
    if childObj == nil then return nil end
    obj_set_pos(childObj, x, y, z)
    obj_set_angle(childObj, rx, ry, rz)
    return childObj
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
    local peak = math.sin(math.pi * t)

    -- Play the sound once at the peak frame.
    if sound ~= nil then
        local mid = math.floor(duration * 0.5)
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

function r96lib.audio_fade(o, audioStream)
    local volume = audio_stream_get_volume(audioStream)
    if o ~= nil then
        if o.oMusicFade == FADE_IN then volume = math.min(volume + 0.02, 1) end
        if o.oMusicFade == FADE_OUT then volume = math.max(volume - 0.02, 0) end
        audio_stream_set_volume(audioStream, volume)
        if o.oMusicFade == FADE_OUT and volume == 0 then
            audio_stream_set_looping(audioStream, false)
            audio_stream_stop(audioStream)
        end
    end
    if o == nil then
        audio_stream_set_looping(audioStream, false)
        audio_stream_stop(audioStream)
    end
end

function r96lib.save_render96_data(name, index)
    local bits = r96lib.load_render96_data(name)
    -- Set the character at the index position to '1'
    bits = bits:sub(1, 7 - index) .. "1" .. bits:sub(9 - index)
    mod_storage_save(name, bits)
end

function r96lib.check_render96_data(name, index)
    local bits = r96lib.load_render96_data(name)
    return bits:sub(8 - index, 8 - index) == "1"
end

function r96lib.load_render96_data(name)
    local bits = mod_storage_load(name)
    if bits == nil then
        bits = "00000000"
        mod_storage_save(name, bits)
    end
    return bits
end

gNumLuigiKeys = select(2, r96lib.load_render96_data("luigi_key"):gsub("1", ""))
gNumWarioCoins = select(2, r96lib.load_render96_data("wario_coin"):gsub("1", ""))

--gGlobalSyncTable
--gGlobalSyncTable.luigiKey1 = true WILL SYNC TO ALL CLIENTS
--gPlayerSyncTable[index]

local networkPlayers = gNetworkPlayers

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
function r96lib.addSpawn(level, area, model, bhv, x, y, z, rx, ry, rz, acts, spawnFunc)
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
        model     = model,
        bhv       = bhv,
        x = x, y = y, z = z,
        rx = rx or 0, ry = ry or 0, rz = rz or 0,
        actMask   = actMask,
        spawnFunc = spawnFunc,
    })
end

-- Remove all registered spawns for a level/area
function r96lib.clearSpawns(level, area)
    if sSpawnTable[level] then
        sSpawnTable[level][area] = nil
    end
end

local function make_key(level, area, actNum, index)
    return level .. "_" .. area .. "_" .. actNum .. "_" .. index
end

local function on_level_init()
    -- Clear spawn tracking on every level load so objects respawn fresh
    sSpawnedObjects = {}
    
end

local sModelOverrides = {}

function r96lib.addModelOverride(bhv, model)
    table.insert(sModelOverrides, {
        bhv   = bhv,
        model = model,
    })
end

local function update()
    local level  = networkPlayers[0].currLevelNum
    local area   = networkPlayers[0].currAreaIndex
    local actNum = networkPlayers[0].currActNum

    for _, entry in ipairs(sModelOverrides) do
        local o = obj_get_first_with_behavior_id(entry.bhv)
        if o then
            while o ~= nil do
            obj_set_model_extended(o, entry.model)
            o = obj_get_next_with_same_behavior_id(o)
            end
        end
    end

    local entries = sSpawnTable[level] and sSpawnTable[level][area]
    if not entries then return end

    for i, entry in ipairs(entries) do
        if act_matches(entry.actMask, actNum) then
            local key = make_key(level, area, actNum, i)
            if not sSpawnedObjects[key] then
                sSpawnedObjects[key] = true
                spawn_non_sync_object(entry.bhv, entry.model,
                    entry.x, entry.y, entry.z,
                    function(o)
                        obj_set_angle(o, entry.rx, entry.ry, entry.rz)
                        if entry.spawnFunc then entry.spawnFunc(o) end
                    end)
            end
        end
    end

end



hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
hook_event(HOOK_UPDATE, update)

return r96lib