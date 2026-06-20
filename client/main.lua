--- Once the player is active in the session, ask the server to resolve the
--- player's account and route to selection (existing) or creation (new).
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    TriggerServerEvent('gaia_multicharacter:server:checkPlayerData')
end)
