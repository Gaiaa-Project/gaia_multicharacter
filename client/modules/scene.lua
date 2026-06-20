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

--- Build the hidden scene (model, position, camera) behind a fade, then fade
--- back in. Shared by both the selection and creation entry points.
function SetupCharacterScene()
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(100)
    end

    local modelHash <const> = GetHashKey('mp_m_freemode_01')

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(100)
    end

    SetPlayerModel(PlayerId(), modelHash)
    SetModelAsNoLongerNeeded(modelHash)

    local playerPed <const> = PlayerPedId()
    local spawnCoords <const> = SpawnConfig.selectionSpawn

    setDefaultClothes(playerPed)
    Wait(100)

    ResetEntityAlpha(playerPed)
    SetEntityVisible(playerPed, true, false)
    SetPedAoBlobRendering(playerPed, true)
    SetEntityCollision(playerPed, true, true)

    SetEntityCoords(playerPed, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, true)
    SetEntityHeading(playerPed, spawnCoords.w)
    FreezeEntityPosition(playerPed, true)
    SetPlayerControl(PlayerId(), false, 0)

    Wait(500)

    CreateSelectionCamera(playerPed, vector3(0.0, 1.5, 0.4), 1000)

    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()

    DoScreenFadeIn(500)
    while not IsScreenFadedIn() do
        Wait(100)
    end
end
