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

--- Show the character selection NUI and give it focus (mouse + keyboard).
---@param characters table The formatted character data to display.
local function openCharacterSelect(characters)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        characters = characters,
    })
end

--- Hide the character selection NUI and release focus.
local function closeCharacterSelect()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close',
    })
end

--- Prepare the player for the character selection screen.
--- Fades out, sets up the hidden scene (model, position, camera), then fades
--- back in with the interface already visible for a seamless transition.
local function prepareCharacterSelection()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(50)
    end

    local modelHash <const> = GetHashKey('mp_m_freemode_01')

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(50)
    end

    SetPlayerModel(PlayerId(), modelHash)
    SetModelAsNoLongerNeeded(modelHash)

    local playerPed <const> = PlayerPedId()
    local spawnCoords <const> = SpawnConfig.selectionSpawn

    setDefaultClothes(playerPed)

    SetEntityCoords(playerPed, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, true)
    SetEntityHeading(playerPed, spawnCoords.w)
    FreezeEntityPosition(playerPed, true)
    SetPlayerControl(PlayerId(), false, 0)

    ResetEntityAlpha(playerPed)
    SetEntityVisible(playerPed, true, false)
    SetPedAoBlobRendering(playerPed, true)
    SetEntityCollision(playerPed, true, true)

    CreateSelectionCamera(playerPed, vector3(0.0, 1.5, 0.4), 0)

    while not NetworkIsSessionStarted() do
        Wait(50)
    end

    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()

    Wait(500)

    local characters <const> = Gaia.TriggerServerCallback('gaia_multicharacter:callback:getCharacters')

    openCharacterSelect(characters or {})

    Wait(200)

    DoScreenFadeIn(800)
end

RegisterNetEvent('gaia_multicharacter:client:prepareCharacterSelect', function()
    prepareCharacterSelection()
end)

RegisterNUICallback('gaia_multicharacter:nui:close', function(_, cb)
    closeCharacterSelect()
    cb({ ok = true })
end)

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    TriggerServerEvent('gaia_multicharacter:server:checkPlayerData')
end)
