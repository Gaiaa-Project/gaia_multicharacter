local CLOTHING_COMPONENTS <const> = { 1, 3, 4, 5, 6, 8, 9, 10, 11 }

--- Read the live clothing state for every managed component: current drawable
--- and texture, plus how many drawables exist and how many textures the current
--- drawable has (counts depend on the ped model, so they are queried live).
---@return table list An array of component states.
local function readClothing()
    local ped <const> = PlayerPedId()
    local list <const> = {}

    for i = 1, #CLOTHING_COMPONENTS do
        local component <const> = CLOTHING_COMPONENTS[i]
        local drawable <const> = GetPedDrawableVariation(ped, component)

        list[#list + 1] = {
            component = component,
            drawable = drawable,
            texture = GetPedTextureVariation(ped, component),
            maxDrawable = GetNumberOfPedDrawableVariations(ped, component) - 1,
            maxTexture = GetNumberOfPedTextureVariations(ped, component, drawable) - 1,
        }
    end

    return list
end

RegisterNUICallback('gaia_multicharacter:nui:getClothing', function(_, cb)
    cb({ list = readClothing() })
end)

RegisterNUICallback('gaia_multicharacter:nui:setClothing', function(data, cb)
    if not data or not data.component then
        cb({ ok = false })
        return
    end

    local ped <const> = PlayerPedId()
    local drawable <const> = data.drawable or 0

    SetPedComponentVariation(ped, data.component, drawable, data.texture or 0, 0)

    cb({
        maxTexture = GetNumberOfPedTextureVariations(ped, data.component, drawable) - 1,
    })
end)
