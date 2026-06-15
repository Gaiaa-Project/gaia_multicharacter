--- Reset all ped clothing components and props to defaults.
---@param ped number The ped handle.
local function setDefaultClothes(ped)
    for i = 0, 11 do
        SetPedComponentVariation(ped, i, 0, 0, 4)
    end

    for i = 0, 7 do
        ClearPedProp(ped, i)
    end
end

--- Prepare the player for the character selection screen.
--- Spawns an invisible ped at the selection coords, sets up the camera,
--- and opens the NUI interface.
local function prepareCharacterSelection()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(100)
    end

    local spawnCoords <const> = SpawnConfig.selectionSpawn
    local modelHash <const> = GetHashKey('mp_m_freemode_01')

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end

    SetPlayerModel(PlayerId(), modelHash)
    SetModelAsNoLongerNeeded(modelHash)

    local playerPed <const> = PlayerPedId()

    setDefaultClothes(playerPed)

    SetEntityCoords(playerPed, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, true)
    SetEntityHeading(playerPed, spawnCoords.w)
    FreezeEntityPosition(playerPed, true)
    SetPlayerControl(PlayerId(), false, 0)

    ResetEntityAlpha(playerPed)
    SetEntityVisible(playerPed, true, false)
    SetPedAoBlobRendering(playerPed, true)
    SetEntityCollision(playerPed, true, true)

    CreateSelectionCamera(playerPed, vector3(0.0, 1.5, 0.4), 1000)

    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()

    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do
        Wait(100)
    end

    local characters <const> = Gaia.TriggerServerCallback('gaia_multicharacter:callback:getCharacters')

    OpenInterface({
        characters = characters or {}
    })
end

RegisterNetEvent('gaia_multicharacter:client:prepareCharacterSelect', function()
    prepareCharacterSelection()
end)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    TriggerServerEvent('gaia_multicharacter:server:checkPlayerData')
end)
