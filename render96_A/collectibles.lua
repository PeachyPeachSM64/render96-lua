local r96lib = require("/lib/r96lib")

-- Luigi keys and Wario coins are shared between all players
-- But only the host actually saves them to their save file

local function get_collectible(name)
    return gGlobalSyncTable[name]
end

local function check_collectible(name, index)
    return r96lib.check_data(gGlobalSyncTable[name], index)
end

local function count_collectible(name)
    return r96lib.count_data(gGlobalSyncTable[name])
end

local function load_collectible(name)
    if network_is_server() or gServerSettings.maxPlayers == 1 then
        gGlobalSyncTable[name] = r96lib.load_data(name)
    end
end

local function update_collectible(name, index, value)
    gGlobalSyncTable[name] = r96lib.update_data(gGlobalSyncTable[name], index, value)
    if network_is_server() or gServerSettings.maxPlayers == 1 then
        r96lib.save_data(name, gGlobalSyncTable[name])
    end
end

local function create_collectible_entry(name)
    load_collectible(name)

    -- Server refreshes the collectible value on sync valid
    hook_event(HOOK_ON_SYNC_VALID, function ()
        load_collectible(name)
    end)

    -- Make sure for the server to save the collectible on sync table change
    hook_on_sync_table_change(gGlobalSyncTable, name, nil, function (_, oldVal, newVal)
        if oldVal ~= newVal and (network_is_server() or gServerSettings.maxPlayers == 1) then
            r96lib.save_data(name, newVal)
        end
    end)
end

----------------
-- Luigi keys --
----------------

create_collectible_entry("luigi_key")

collect_luigi_key      = function (index) return update_collectible("luigi_key", index, '1') end
is_luigi_key_collected = function (index) return check_collectible("luigi_key", index) end
count_luigi_keys       = function ()      return count_collectible("luigi_key") end
is_luigi_unlocked      = function ()      return count_luigi_keys() >= 8 end

-----------------
-- Wario coins --
-----------------

create_collectible_entry("wario_coin")

collect_wario_coin      = function (index) return update_collectible("wario_coin", index, '1') end
is_wario_coin_collected = function (index) return check_collectible("wario_coin", index) end
count_wario_coins       = function ()      return count_collectible("wario_coin") end
is_wario_unlocked       = function ()      return count_wario_coins() >= 6 end
