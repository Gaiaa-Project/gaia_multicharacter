--- Show the character creation NUI directly, skipping selection, and give it focus.
local function openCharacterCreation()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openCreation',
    })
end

--- Prepare and open the character creation screen directly for a brand new
--- player, skipping the (empty) selection screen.
local function prepareCharacterCreation()
    SetupCharacterScene()

    openCharacterCreation()
end

RegisterNetEvent('gaia_multicharacter:client:prepareCharacterCreation', function()
    prepareCharacterCreation()
end)
