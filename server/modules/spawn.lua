--- Create a new user in the database and prepare for character selection.
---@param sessionId number The player's server ID.
---@param identifiers PlayerIdentifiers The player's identifiers.
local function createUser(sessionId, identifiers)
    local license <const> = identifiers.license
    local discordId <const> = identifiers.discord
    local ip <const> = identifiers.ip

    if not license or not ip then
        DropPlayer(tostring(sessionId), 'Failed to retrieve your identifiers, please restart FiveM.')
        return
    end

    if not discordId then
        DropPlayer(tostring(sessionId), 'Discord must be running on your PC to connect. Please open Discord and try again.')
        return
    end

    local insertId <const> = MySQL.insert.await('INSERT INTO users (license, discord_id, ip) VALUES (?, ?, ?)', { license, discordId, ip })

    if not insertId then
        DropPlayer(tostring(sessionId), 'Failed to create your account, please try again later.')
        return
    end

    local userData <const> = {
        id = insertId,
        license = license,
        discord_id = discordId,
    }

    TriggerEvent('gaia_core:server:createUserInstance', sessionId, userData)
    TriggerClientEvent('gaia_multicharacter:client:prepareCharacterSelect', sessionId)
end

--- Check if a player already exists in the database and route to creation or retrieval.
---@param sessionId number The player's server ID.
local function checkPlayerData(sessionId)
    local identifiers <const> = Gaia.GetIdentifiers(sessionId)
    local license <const> = identifiers.license

    if not license then
        DropPlayer(tostring(sessionId), 'Failed to get your FiveM license, please contact an administrator.')
        return
    end

    local existingUserId <const> = MySQL.scalar.await('SELECT id FROM users WHERE license = ?', { license })

    if existingUserId then
        RetrieveUser(sessionId, existingUserId, identifiers)
    else
        createUser(sessionId, identifiers)
    end
end

RegisterNetEvent('gaia_multicharacter:server:checkPlayerData', function()
    local sessionId <const> = source
    checkPlayerData(sessionId)
end)