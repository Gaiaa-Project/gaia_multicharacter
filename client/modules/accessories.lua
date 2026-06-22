local ACCESSORY_PROPS <const> = { 0, 1, 2, 6, 7 }

--- Read the live prop state for every managed accessory slot: current drawable
--- (-1 = none) and texture, plus how many drawables exist and how many textures
--- the current drawable has (counts depend on the ped model, queried live).
---@return table list An array of prop states.
local function readAccessories()
    local ped <const> = PlayerPedId()
    local list <const> = {}

    for i = 1, #ACCESSORY_PROPS do
        local prop <const> = ACCESSORY_PROPS[i]
        local drawable <const> = GetPedPropIndex(ped, prop)

        list[#list + 1] = {
            prop = prop,
            drawable = drawable,
            texture = math.max(GetPedPropTextureVariation(ped, prop), 0),
            maxDrawable = GetNumberOfPedPropDrawableVariations(ped, prop) - 1,
            maxTexture = drawable >= 0 and (GetNumberOfPedPropTextureVariations(ped, prop, drawable) - 1) or 0,
        }
    end

    return list
end

RegisterNUICallback('gaia_multicharacter:nui:getAccessories', function(_, cb)
    cb({ list = readAccessories() })
end)

RegisterNUICallback('gaia_multicharacter:nui:setAccessory', function(data, cb)
    if not data or data.prop == nil then
        cb({ ok = false })
        return
    end

    local ped <const> = PlayerPedId()
    local drawable <const> = data.drawable or -1

    if drawable < 0 then
        ClearPedProp(ped, data.prop)
        cb({ maxTexture = 0 })
        return
    end

    SetPedPropIndex(ped, data.prop, drawable, data.texture or 0, true)

    cb({
        maxTexture = GetNumberOfPedPropTextureVariations(ped, data.prop, drawable) - 1,
    })
end)
