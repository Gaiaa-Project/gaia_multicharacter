local CREATOR_CAMERA_OFFSET <const> = vector3(0.0, 1.5, 0.4)

local FACE_FEATURES <const> = {
    [0] = 'nose_1', [1] = 'nose_2', [2] = 'nose_3', [3] = 'nose_4',
    [4] = 'nose_5', [5] = 'nose_6', [6] = 'eyebrows_5', [7] = 'eyebrows_6',
    [8] = 'cheeks_1', [9] = 'cheeks_2', [10] = 'cheeks_3', [11] = 'eye_squint',
    [12] = 'lip_thickness', [13] = 'jaw_1', [14] = 'jaw_2', [15] = 'chin_1',
    [16] = 'chin_2', [17] = 'chin_3', [18] = 'chin_4', [19] = 'neck_thickness',
}

local COMPONENTS <const> = {
    { component = 1, drawable = 'mask_1', texture = 'mask_2' },
    { component = 2, drawable = 'hair_1', texture = 'hair_2' },
    { component = 3, drawable = 'torso_1', texture = 'torso_2' },
    { component = 4, drawable = 'pants_1', texture = 'pants_2' },
    { component = 5, drawable = 'bags_1', texture = 'bags_2' },
    { component = 6, drawable = 'shoes_1', texture = 'shoes_2' },
    { component = 7, drawable = 'chain_1', texture = 'chain_2' },
    { component = 8, drawable = 'tshirt_1', texture = 'tshirt_2' },
    { component = 9, drawable = 'bproof_1', texture = 'bproof_2' },
    { component = 10, drawable = 'decals_1', texture = 'decals_2' },
    { component = 11, drawable = 'arms', texture = 'arms_2' },
}

local PROPS <const> = {
    { prop = 0, drawable = 'helmet_1', texture = 'helmet_2' },
    { prop = 1, drawable = 'glasses_1', texture = 'glasses_2' },
    { prop = 2, drawable = 'ears_1', texture = 'ears_2' },
    { prop = 6, drawable = 'watches_1', texture = 'watches_2' },
    { prop = 7, drawable = 'bracelets_1', texture = 'bracelets_2' },
}

local OVERLAYS <const> = {
    { id = 0, style = 'blemishes_1', opacity = 'blemishes_2' },
    { id = 1, style = 'beard_1', opacity = 'beard_2', colorType = 1, color = 'beard_3', highlight = 'beard_4' },
    { id = 2, style = 'eyebrows_1', opacity = 'eyebrows_2', colorType = 1, color = 'eyebrows_3', highlight = 'eyebrows_4' },
    { id = 3, style = 'age_1', opacity = 'age_2' },
    { id = 4, style = 'makeup_1', opacity = 'makeup_2', colorType = 2, color = 'makeup_3', highlight = 'makeup_4' },
    { id = 5, style = 'blush_1', opacity = 'blush_2', colorType = 2, color = 'blush_3' },
    { id = 6, style = 'complexion_1', opacity = 'complexion_2' },
    { id = 7, style = 'sun_1', opacity = 'sun_2' },
    { id = 8, style = 'lipstick_1', opacity = 'lipstick_2', colorType = 2, color = 'lipstick_3', highlight = 'lipstick_4' },
    { id = 9, style = 'moles_1', opacity = 'moles_2' },
    { id = 10, style = 'chest_1', opacity = 'chest_2', colorType = 1, color = 'chest_3' },
}

--- Read a numeric field from an appearance table, defaulting to 0.
---@param data table The appearance data.
---@param key string The field name.
---@return number value The field value or 0.
local function value(data, key)
    return data[key] or 0
end

--- Apply a full default appearance (esx-skin format) to a freemode ped:
--- head blend, face features, components, props, eye color and overlays.
---@param ped number The ped handle.
---@param gender string 'm' for male, 'f' for female.
function ApplyDefaultAppearance(ped, gender)
    local data <const> = DefaultCharacterConfig[gender]
    if not data then return end

    SetPedHeadBlendData(ped, data.mom, data.dad, 0, data.mom, data.dad, 0,
        value(data, 'face_md_weight') / 100.0, value(data, 'skin_md_weight') / 100.0, 0.0, false)

    for index, key in pairs(FACE_FEATURES) do
        SetPedFaceFeature(ped, index, value(data, key) / 10.0)
    end

    for i = 1, #COMPONENTS do
        local entry <const> = COMPONENTS[i]
        SetPedComponentVariation(ped, entry.component, value(data, entry.drawable), value(data, entry.texture), 0)
    end

    SetPedHairTint(ped, value(data, 'hair_color_1'), value(data, 'hair_color_2'))

    for i = 0, 7 do
        ClearPedProp(ped, i)
    end

    for i = 1, #PROPS do
        local entry <const> = PROPS[i]
        local drawable <const> = data[entry.drawable] or -1
        if drawable ~= -1 then
            SetPedPropIndex(ped, entry.prop, drawable, value(data, entry.texture), true)
        end
    end

    SetPedEyeColor(ped, value(data, 'eye_color'))

    for i = 1, #OVERLAYS do
        local entry <const> = OVERLAYS[i]
        SetPedHeadOverlay(ped, entry.id, value(data, entry.style), value(data, entry.opacity) / 10.0)
        if entry.colorType then
            SetPedHeadOverlayColor(ped, entry.id, entry.colorType, value(data, entry.color),
                entry.highlight and value(data, entry.highlight) or 0)
        end
    end

    if (data.bodyb_1 or -1) ~= -1 then
        SetPedHeadOverlay(ped, 11, data.bodyb_1, value(data, 'bodyb_2') / 10.0)
    end

    if (data.bodyb_3 or -1) ~= -1 then
        SetPedHeadOverlay(ped, 12, data.bodyb_3, value(data, 'bodyb_4') / 10.0)
    end
end

--- Resolve the freemode gender for a model, or nil for non-freemode peds.
---@param model string The ped model name.
---@return string|nil gender 'm', 'f', or nil.
local function freemodeGender(model)
    if model == 'mp_m_freemode_01' then return 'm' end
    if model == 'mp_f_freemode_01' then return 'f' end
    return nil
end

--- Swap the creator ped to a new model live, re-place it on the selection mark,
--- apply the default appearance for freemode peds, and re-frame the camera.
---@param model string The ped model name.
function ApplyCreatorPed(model)
    local modelHash <const> = GetHashKey(model)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end

    SetPlayerModel(PlayerId(), modelHash)
    SetModelAsNoLongerNeeded(modelHash)

    local ped <const> = PlayerPedId()
    local spawnCoords <const> = SpawnConfig.selectionSpawn

    SetEntityCoords(ped, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false, true)
    SetEntityHeading(ped, spawnCoords.w)
    FreezeEntityPosition(ped, true)

    local gender <const> = freemodeGender(model)
    if gender then
        ApplyDefaultAppearance(ped, gender)
    end

    CreateSelectionCamera(ped, CREATOR_CAMERA_OFFSET, 800)
end

RegisterNUICallback('gaia_multicharacter:nui:setPedModel', function(data, cb)
    if data and data.model then
        ApplyCreatorPed(data.model)
    end

    cb({ ok = true })
end)
