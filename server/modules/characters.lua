--- Retrieve an existing user from the database, cache the user instance,
--- and prepare for character selection.
---@param sessionId number The player's server ID.
---@param userId number The user's database ID.
---@param identifiers PlayerIdentifiers The player's identifiers.
function RetrieveUser(sessionId, userId, identifiers)
    local userData <const> = MySQL.single.await('SELECT * FROM users WHERE id = ?', { userId })

    if not userData then
        Gaia.print.error(('Failed to retrieve user data for userId %d (session: %d)'):format(userId, sessionId))
        DropPlayer(tostring(sessionId), 'Failed to retrieve your account data. Please reconnect.')
        return
    end

    TriggerEvent('gaia_core:server:createUserInstance', sessionId, {
        id = userData.id,
        license = userData.license,
        discord_id = userData.discord_id,
    })

    TriggerClientEvent('gaia_multicharacter:client:prepareCharacterSelect', sessionId)
end

--- Format a character database row into a clean data table for the client.
---@param row table The raw character row from the database.
---@return table characterData The formatted character data.
local function formatCharacterData(row)
    local appearanceData = nil

    if row.appearance and row.appearance ~= '' then
        local ok <const>, decoded = pcall(json.decode, row.appearance)
        if ok then
            appearanceData = decoded
        end
    end

    return {
        id = row.id,
        firstname = row.firstname,
        lastname = row.lastname,
        dateOfBirth = row.date_of_birth,
        sex = row.sex,
        nationality = row.nationality,
        height = row.height,
        appearance = appearanceData,
        pedModel = row.ped_model,
        position = {
            x = row.x,
            y = row.y,
            z = row.z,
            heading = row.heading,
        },
        isDead = row.is_dead == 1 or row.is_dead == true,
        playtime = row.playtime or 0,
        lastPlayed = row.last_played,
        createdAt = row.created_at,
    }
end

Gaia.RegisterServerCallback('gaia_multicharacter:callback:getCharacters', function(sessionId)
    if SpawnConfig.useInstance then
        Gaia.bucket.createPlayerInstance(sessionId)
    end

    local user <const> = Gaia.cache.getPlayer(sessionId)

    if not user then
        Gaia.print.error(('No cached user for session %d during character fetch'):format(sessionId))
        return {}
    end

    local rows <const> = MySQL.query.await('SELECT * FROM characters WHERE user_id = ? ORDER BY created_at ASC',
        { user.id })

    if not rows or #rows == 0 then
        Gaia.print.info(('No characters found for user %d (session: %d)'):format(user.id, sessionId))
        return {}
    end

    TriggerEvent('gaia_core:server:loadCharacters', sessionId, rows)

    local characterData <const> = {}

    for i = 1, #rows do
        characterData[#characterData + 1] = formatCharacterData(rows[i])
    end

    Gaia.print.info(('Returning %d characters for user %d (session: %d)'):format(#characterData, user.id, sessionId))

    return characterData
end)
