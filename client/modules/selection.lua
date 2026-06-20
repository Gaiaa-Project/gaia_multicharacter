--- Show the character selection NUI and give it focus (mouse + keyboard).
---@param characters table The formatted character data to display.
local function openCharacterSelect(characters)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        characters = characters,
    })
end

--- Hide the NUI and release focus.
local function closeCharacterSelect()
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'close',
    })
end

--- Prepare and open the character selection screen for an existing player.
local function prepareCharacterSelection()
    SetupCharacterScene()

    local characters <const> = Gaia.TriggerServerCallback('gaia_multicharacter:callback:getCharacters')

    openCharacterSelect(characters or {})
end

RegisterNetEvent('gaia_multicharacter:client:prepareCharacterSelect', function()
    prepareCharacterSelection()
end)

RegisterNUICallback('gaia_multicharacter:nui:close', function(_, cb)
    closeCharacterSelect()
    cb({ ok = true })
end)
