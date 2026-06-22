local ZONE_CONFIG <const> = {
    head = 'ZONE_HEAD',
    neck = 'ZONE_HEAD',
    torso = 'ZONE_TORSO',
    back = 'ZONE_TORSO',
    leftArm = 'ZONE_LEFT_ARM',
    rightArm = 'ZONE_RIGHT_ARM',
    leftLeg = 'ZONE_LEFT_LEG',
    rightLeg = 'ZONE_RIGHT_LEG',
}

local activeTattoos = {}

--- Resolve the tattoo list for a NUI zone key, or nil.
---@param zone string The NUI zone key.
---@return table|nil list The tattoo list from the config.
local function zoneList(zone)
    local configKey <const> = ZONE_CONFIG[zone]
    return configKey and TattooConfig[configKey] or nil
end

--- Clear and re-add every active tattoo, preserving the torso/arms components
--- (AddPedDecoration can reset them).
---@param ped number The ped handle.
local function reapplyAll(ped)
    local torso <const> = GetPedDrawableVariation(ped, 3)
    local torsoTex <const> = GetPedTextureVariation(ped, 3)
    local arms <const> = GetPedDrawableVariation(ped, 11)
    local armsTex <const> = GetPedTextureVariation(ped, 11)

    ClearPedDecorations(ped)

    for _, tattoo in pairs(activeTattoos) do
        AddPedDecorationFromHashes(ped, tattoo.collectionHash, tattoo.hash)
    end

    SetPedComponentVariation(ped, 3, torso, torsoTex, 0)
    SetPedComponentVariation(ped, 11, arms, armsTex, 0)
end

--- Forget every applied tattoo (used when the ped model changes).
function ResetTattooState()
    activeTattoos = {}
end

RegisterNUICallback('gaia_multicharacter:nui:getTattoos', function(_, cb)
    local zones <const> = {}

    for zone, configKey in pairs(ZONE_CONFIG) do
        local list <const> = TattooConfig[configKey]
        if list then
            local labels <const> = {}
            for i = 1, #list do
                labels[i] = list[i].label
            end
            zones[#zones + 1] = { key = zone, count = #list, labels = labels }
        end
    end

    cb({ zones = zones })
end)

RegisterNUICallback('gaia_multicharacter:nui:applyTattoo', function(data, cb)
    if not data or not data.zone then
        cb({ ok = false })
        return
    end

    local ped <const> = PlayerPedId()
    local list <const> = zoneList(data.zone)
    local index <const> = data.index or 0

    if list and index > 0 and index <= #list then
        local tattoo <const> = list[index]
        local hashName <const> = IsPedMale(ped) and tattoo.hashMale or tattoo.hashFemale

        activeTattoos[data.zone] = {
            collectionHash = GetHashKey(tattoo.collection),
            hash = GetHashKey(hashName),
        }
    else
        activeTattoos[data.zone] = nil
    end

    reapplyAll(ped)

    cb({ ok = true })
end)
