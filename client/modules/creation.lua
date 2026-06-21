--- Show the character creation NUI directly, skipping selection, and give it
--- focus. Sends the ped catalog so the NUI knows which models are selectable.
local function openCharacterCreation()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openCreation',
        pedConfig = {
            authorizeAll = PedsConfig.authorizePedwhileInCreator,
            basics = PedsConfig.pedList.basics,
            peds = PedsConfig.pedList.peds,
        },
    })
end

--- Prepare and open the character creation screen directly for a brand new
--- player, skipping the (empty) selection screen. Starts on the default male
--- freemode ped with the default appearance applied.
local function prepareCharacterCreation()
    SetupCharacterScene()

    ApplyDefaultAppearance(PlayerPedId(), 'm')

    openCharacterCreation()

    RevealCharacterScene()
end

RegisterNetEvent('gaia_multicharacter:client:prepareCharacterCreation', function()
    prepareCharacterCreation()
end)
