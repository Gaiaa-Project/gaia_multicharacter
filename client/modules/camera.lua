local activeCam = nil

--- Create and activate a camera facing a ped from a relative offset.
--- Uses the ped's position and heading to calculate the camera placement.
---@param ped number The ped to face.
---@param offset vector3 The relative offset from the ped (x = right, y = forward, z = up).
---@param transitionTime number The transition duration in milliseconds.
---@return number cam The created camera handle.
function CreateSelectionCamera(ped, offset, transitionTime)
    if activeCam then
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(activeCam, false)
        activeCam = nil
    end

    local pedCoords <const> = GetEntityCoords(ped)
    local pedHeading <const> = GetEntityHeading(ped)

    local camPos <const> = Gaia.math.getRelativeCoords(pedCoords, pedHeading, offset)

    local cam <const> = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

    SetCamCoord(cam, camPos.x, camPos.y, camPos.z)
    PointCamAtEntity(cam, ped, 0.0, 0.0, 0.0, true)

    SetCamActive(cam, true)
    RenderScriptCams(true, true, transitionTime, true, false)

    activeCam = cam

    return cam
end

--- Destroy the active selection camera and return to gameplay camera.
---@param transitionTime? number The transition duration in milliseconds. Default: 0.
function DestroySelectionCamera(transitionTime)
    if not activeCam then return end

    RenderScriptCams(false, true, transitionTime or 0, true, false)
    DestroyCam(activeCam, false)
    activeCam = nil
end

--- Get the active selection camera handle.
---@return number|nil cam The active camera handle or nil.
function GetSelectionCamera()
    return activeCam
end

--- Check if a selection camera is currently active.
---@return boolean active Whether a selection camera is active.
function IsSelectionCameraActive()
    return activeCam ~= nil
end
