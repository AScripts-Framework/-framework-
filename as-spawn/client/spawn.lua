local AS = exports['as-core']:GetCoreObject()
local currentCamera = nil
local inSpawnSelection = false

-- Spawn player at selected location
function SpawnPlayer(spawnData)
    if not spawnData or not spawnData.coords then
        spawnData = Config.Spawn.DefaultSpawn
    end
    
    local coords = spawnData.coords
    local ped = PlayerPedId()
    
    -- Freeze player
    FreezeEntityPosition(ped, true)
    
    -- Fade out
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    
    -- Set coords
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(ped, coords.w or coords.heading or 0.0)
    
    -- Wait a moment
    Wait(500)
    
    -- Fade in
    DoScreenFadeIn(Config.Spawn.FadeInTime)
    
    -- Unfreeze after delay
    CreateThread(function()
        Wait(Config.Spawn.FreezeOnSpawn)
        FreezeEntityPosition(ped, false)
    end)
    
    -- Destroy camera if exists
    if currentCamera then
        DestroyCam(currentCamera, false)
        RenderScriptCams(false, false, 0, true, true)
        currentCamera = nil
    end
    
    inSpawnSelection = false
    
    -- Trigger event
    TriggerEvent('as-spawn:client:playerSpawned', spawnData)
end

-- Show spawn selection menu
function ShowSpawnSelection(lastLocation)
    local spawnOptions = {}
    local AS = exports['as-core']:GetCoreObject()
    local playerData = AS.Client.GetPlayerData()
    
    -- Add public spawn locations
    for _, location in ipairs(Config.Spawn.Locations) do
        if location.public then
            local coords = location.coords
            
            -- Handle last location
            if location.isLastLocation then
                if lastLocation then
                    coords = vector4(lastLocation.x, lastLocation.y, lastLocation.z, lastLocation.heading)
                else
                    goto continue
                end
            end
            
            table.insert(spawnOptions, {
                title = location.label,
                description = 'Spawn at ' .. location.label,
                icon = location.icon,
                onSelect = function()
                    SpawnPlayer({
                        coords = coords,
                        label = location.label
                    })
                end
            })
            
            ::continue::
        end
    end
    
    -- Add job-specific spawn locations
    if playerData and playerData.job then
        local jobLocations = Config.Spawn.JobLocations[playerData.job]
        
        if jobLocations then
            local jobGrade = playerData.job_grade or 0
            
            for _, location in ipairs(jobLocations) do
                if jobGrade >= location.minGrade then
                    table.insert(spawnOptions, {
                        title = location.label,
                        description = 'Spawn at your job location',
                        icon = location.icon,
                        onSelect = function()
                            SpawnPlayer({
                                coords = location.coords,
                                label = location.label
                            })
                        end
                    })
                end
            end
        end
    end
    
    -- Register and show context menu
    exports['as-core']:ShowContext({
        id = 'spawn_selection',
        title = 'Select Spawn Location',
        options = spawnOptions
    })
end

-- Initialize spawn selection
function InitializeSpawnSelection()
    inSpawnSelection = true
    local ped = PlayerPedId()
    
    -- Freeze player
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, false)
    SetEntityInvincible(ped, true)
    
    -- Fade out
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    
    -- Set player to safe location (high in sky)
    SetEntityCoords(ped, Config.Spawn.Camera.coords.x, Config.Spawn.Camera.coords.y, Config.Spawn.Camera.coords.z, false, false, false, false)
    
    -- Create camera
    currentCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(currentCamera, Config.Spawn.Camera.coords.x, Config.Spawn.Camera.coords.y, Config.Spawn.Camera.coords.z)
    SetCamRot(currentCamera, Config.Spawn.Camera.rotation.x, Config.Spawn.Camera.rotation.y, Config.Spawn.Camera.rotation.z, 2)
    SetCamFov(currentCamera, Config.Spawn.Camera.fov)
    SetCamActive(currentCamera, true)
    RenderScriptCams(true, false, 0, true, true)
    
    -- Fade in
    Wait(500)
    DoScreenFadeIn(1000)
    
    -- Get last location
    local lastLocation = AS.Client.TriggerCallback('as-spawn:server:getSpawnLocation')
    
    -- Show spawn selection
    Wait(500)
    ShowSpawnSelection(lastLocation)
end

-- Export
exports('InitializeSpawnSelection', InitializeSpawnSelection)
exports('SpawnPlayer', SpawnPlayer)

print('^2[AS-SPAWN]^7 Client spawn module loaded')
