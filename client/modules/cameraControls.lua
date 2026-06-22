local PAN_SENSITIVITY <const> = 0.0015
local ROTATE_SENSITIVITY <const> = 0.4
local ZOOM_STEP <const> = 0.15
local MIN_ZOOM <const> = 0.7
local MAX_ZOOM <const> = 3.6

--- Orbit the selection camera (left drag): the camera keeps aiming at the ped,
--- so horizontal/vertical movement shifts the viewing angle around it.
---@param dx number Horizontal mouse delta.
---@param dy number Vertical mouse delta.
local function panCamera(dx, dy)
    local cam <const> = GetSelectionCamera()
    if not cam then return end

    local pos <const> = GetCamCoord(cam)
    local rot <const> = GetCamRot(cam, 2)

    local heading <const> = math.rad(rot.z)
    local rightX <const> = math.cos(heading)
    local rightY <const> = math.sin(heading)

    SetCamCoord(
        cam,
        pos.x - rightX * dx * PAN_SENSITIVITY,
        pos.y - rightY * dx * PAN_SENSITIVITY,
        pos.z + dy * PAN_SENSITIVITY
    )
end

--- Rotate the ped on itself (right drag).
---@param dx number Horizontal mouse delta.
local function rotatePed(dx)
    local ped <const> = PlayerPedId()
    SetEntityHeading(ped, GetEntityHeading(ped) - dx * ROTATE_SENSITIVITY)
end

--- Zoom the camera toward / away from the ped, clamped to a sane distance.
---@param direction number 1 to zoom in, -1 to zoom out.
local function zoomCamera(direction)
    local cam <const> = GetSelectionCamera()
    if not cam then return end

    local pos <const> = GetCamCoord(cam)
    local rot <const> = GetCamRot(cam, 2)

    local pitch <const> = math.rad(rot.x)
    local yaw <const> = math.rad(rot.z)

    local forwardX <const> = -math.sin(yaw) * math.cos(pitch)
    local forwardY <const> = math.cos(yaw) * math.cos(pitch)
    local forwardZ <const> = math.sin(pitch)

    local step <const> = direction * ZOOM_STEP
    local target <const> = vector3(pos.x + forwardX * step, pos.y + forwardY * step, pos.z + forwardZ * step)

    local distance <const> = #(target - GetEntityCoords(PlayerPedId()))
    if distance < MIN_ZOOM or distance > MAX_ZOOM then return end

    SetCamCoord(cam, target.x, target.y, target.z)
end

RegisterNUICallback('gaia_multicharacter:nui:camera', function(data, cb)
    if data then
        if data.type == 'pan' then
            panCamera(data.dx or 0, data.dy or 0)
        elseif data.type == 'rotate' then
            rotatePed(data.dx or 0)
        elseif data.type == 'zoom' then
            zoomCamera(data.dir or 0)
        end
    end

    cb({ ok = true })
end)
