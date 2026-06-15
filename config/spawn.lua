SpawnConfig = {
    --- Character selection spawn position.
    ---
    --- Where the ped is placed during the character selection screen.
    --- This is purely visual — the player sees their characters here
    --- while browsing through them in the selection UI.
    ---
    --- vector4(x, y, z, heading)
    selectionSpawn = vector4(925.45, 11.70, 112.55, 301.35),

    --- Instance mode.
    ---
    --- Places each player in their own routing bucket during character
    --- selection so they cannot see or interact with other players.
    ---
    --- • true (default): Each player gets their own instance
    --- • false: All players share the same world during selection
    ---
    --- Default: true
    useInstance = true,

    --- Default spawn position.
    ---
    --- Where the player spawns after selecting or creating a character.
    --- Used for first-time spawns and as a fallback when a character
    --- has no saved position (e.g. freshly created).
    ---
    --- vector4(x, y, z, heading)
    defaultSpawn = vector4(-3043.11, 26.9011, 10.1047, 325.984),
}
