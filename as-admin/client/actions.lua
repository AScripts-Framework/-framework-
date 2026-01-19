-- Teleport
RegisterNetEvent('as-admin:teleportTo')
AddEventHandler('as-admin:teleportTo', function(coords)
    local ped = PlayerPedId()
    
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
    
    lib.notify({
        title = 'Admin',
        description = 'Teleported',
        type = 'success'
    })
end)

-- Noclip
RegisterNetEvent('as-admin:toggleNoclip')
AddEventHandler('as-admin:toggleNoclip', function()
    ToggleNoclip()
end)

function ToggleNoclip()
    noclip = not noclip
    local ped = PlayerPedId()
    
    if noclip then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true, false)
    end
    
    lib.notify({
        title = 'Admin',
        description = noclip and 'Noclip enabled' or 'Noclip disabled',
        type = 'success'
    })
end

-- Noclip thread
CreateThread(function()
    while true do
        Wait(0)
        
        if noclip then
            local ped = PlayerPedId()
            local x, y, z = table.unpack(GetEntityCoords(ped))
            local dx, dy, dz = GetCamDirection()
            local speed = 1.0
            
            -- Speed modifiers
            if IsControlPressed(0, 21) then -- Shift
                speed = 5.0
            end
            if IsControlPressed(0, 19) then -- Alt
                speed = 0.2
            end
            
            -- Movement
            if IsControlPressed(0, 32) then -- W
                x = x + dx * speed
                y = y + dy * speed
                z = z + dz * speed
            end
            if IsControlPressed(0, 33) then -- S
                x = x - dx * speed
                y = y - dy * speed
                z = z - dz * speed
            end
            if IsControlPressed(0, 34) then -- A
                x = x + (-dy) * speed
                y = y + dx * speed
            end
            if IsControlPressed(0, 35) then -- D
                x = x + dy * speed
                y = y + (-dx) * speed
            end
            
            SetEntityCoords(ped, x, y, z, false, false, false, false)
        else
            Wait(500)
        end
    end
end)

function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end

-- Godmode
RegisterNetEvent('as-admin:toggleGod')
AddEventHandler('as-admin:toggleGod', function()
    ToggleGod()
end)

function ToggleGod()
    god = not god
    local ped = PlayerPedId()
    
    SetEntityInvincible(ped, god)
    
    lib.notify({
        title = 'Admin',
        description = god and 'Godmode enabled' or 'Godmode disabled',
        type = 'success'
    })
end

-- Invisible
RegisterNetEvent('as-admin:toggleInvisible')
AddEventHandler('as-admin:toggleInvisible', function()
    ToggleInvisible()
end)

function ToggleInvisible()
    invisible = not invisible
    local ped = PlayerPedId()
    
    SetEntityVisible(ped, not invisible, false)
    
    lib.notify({
        title = 'Admin',
        description = invisible and 'Invisible enabled' or 'Invisible disabled',
        type = 'success'
    })
end

-- Spectate
RegisterNetEvent('as-admin:spectatePlayer')
AddEventHandler('as-admin:spectatePlayer', function(targetId)
    SpectatePlayer(targetId)
end)

function SpectatePlayer(targetId)
    local ped = PlayerPedId()
    
    if not spectating then
        oldCoords = GetEntityCoords(ped)
        spectating = true
        
        local targetPed = GetPlayerPed(GetPlayerFromServerId(targetId))
        NetworkSetInSpectatorMode(true, targetPed)
        
        lib.notify({
            title = 'Admin',
            description = 'Spectating player',
            type = 'info'
        })
    else
        spectating = false
        NetworkSetInSpectatorMode(false, PlayerPedId())
        
        if oldCoords then
            SetEntityCoords(ped, oldCoords.x, oldCoords.y, oldCoords.z, false, false, false, false)
        end
        
        lib.notify({
            title = 'Admin',
            description = 'Stopped spectating',
            type = 'info'
        })
    end
end

-- Vehicle spawn
RegisterNetEvent('as-admin:spawnVeh')
AddEventHandler('as-admin:spawnVeh', function(model)
    local hash = GetHashKey(model)
    
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    SetPedIntoVehicle(ped, vehicle, -1)
    SetEntityAsNoLongerNeeded(vehicle)
    SetModelAsNoLongerNeeded(hash)
    
    lib.notify({
        title = 'Admin',
        description = 'Vehicle spawned',
        type = 'success'
    })
end)

-- Delete vehicle
RegisterNetEvent('as-admin:deleteVeh')
AddEventHandler('as-admin:deleteVeh', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 71)
    end
    
    if vehicle ~= 0 then
        DeleteEntity(vehicle)
        lib.notify({
            title = 'Admin',
            description = 'Vehicle deleted',
            type = 'success'
        })
    end
end)

-- Repair vehicle
RegisterNetEvent('as-admin:repairVeh')
AddEventHandler('as-admin:repairVeh', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)
        
        lib.notify({
            title = 'Admin',
            description = 'Vehicle repaired',
            type = 'success'
        })
    end
end)

-- Warning
RegisterNetEvent('as-admin:receiveWarning')
AddEventHandler('as-admin:receiveWarning', function(message)
    lib.notify({
        title = 'Admin Warning',
        description = message,
        type = 'warning',
        duration = 10000
    })
end)

-- Freeze
RegisterNetEvent('as-admin:setFrozen')
AddEventHandler('as-admin:setFrozen', function(freeze)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, freeze)
    
    lib.notify({
        title = 'Admin',
        description = freeze and 'You have been frozen' or 'You have been unfrozen',
        type = 'info'
    })
end)

-- Weather sync
RegisterNetEvent('as-admin:syncWeather')
AddEventHandler('as-admin:syncWeather', function(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeOverTime(weather, 15.0)
end)

-- Time sync
RegisterNetEvent('as-admin:syncTime')
AddEventHandler('as-admin:syncTime', function(hour, minute)
    NetworkOverrideClockTime(hour, minute, 0)
end)

-- Announcement
RegisterNetEvent('as-admin:showAnnouncement')
AddEventHandler('as-admin:showAnnouncement', function(message)
    lib.notify({
        title = '📢 Server Announcement',
        description = message,
        type = 'inform',
        duration = 15000
    })
end)

-- Revive
RegisterNetEvent('as-admin:revive')
AddEventHandler('as-admin:revive', function()
    local ped = PlayerPedId()
    
    -- Reset health and armor
    SetEntityHealth(ped, 200)
    SetPlayerMaxArmour(PlayerId(), 100)
    SetPedArmour(ped, 100)
    
    -- Clear ragdoll
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedLastWeaponDamage(ped)
    
    lib.notify({
        title = 'Admin',
        description = 'You have been revived',
        type = 'success'
    })
end)

-- Heal
RegisterNetEvent('as-admin:heal')
AddEventHandler('as-admin:heal', function()
    local ped = PlayerPedId()
    
    SetEntityHealth(ped, 200)
    SetPlayerMaxArmour(PlayerId(), 100)
    SetPedArmour(ped, 100)
    
    lib.notify({
        title = 'Admin',
        description = 'You have been healed',
        type = 'success'
    })
end)

print('^2[AS-Admin]^7 Client actions loaded')
