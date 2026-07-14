-- You want fun? Wario show you fun!

local function wario_head_spawner()
    local levelNum = gNetworkPlayers[0].currLevelNum
    local areaNum = gNetworkPlayers[0].currAreaIndex
    local actNum = gNetworkPlayers[0].currActNum
    local m = gMarioStates[0]
    --5235, -1074,  1995
    --604, -1074, 1995
    --if levelNum == LEVEL_CASTLE and m.pos.y == -1074 then
    --r96lib.spawn_object(E_MODEL_WARIO_HEAD, id_bhvWarioHead, 5935, -1074,  2084, 0, 0, 0, nil)
    ----print("spawned head")
    --end
    --print(levelNum)
end

hook_event(HOOK_ON_WARP, wario_head_spawner)
