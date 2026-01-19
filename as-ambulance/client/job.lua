local AS = exports['as-core']:GetCoreObject()
local isOnDuty = false
local currentJob = nil

-- Helper function to get closest player
function GetClosestPlayer(coords)
    local players = GetActivePlayers()
    local closestDistance = Config.ReviveDistance
    local closestPlayer = nil
    
    for _, player in ipairs(players) do
        if player ~= PlayerId() then
            local targetPed = GetPlayerPed(player)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = GetPlayerServerId(player)
            end
        end
    end
    
    return closestPlayer, closestDistance
end

-- Check if player is EMS
CreateThread(function()
    while true do
        Wait(1000)
        local player = AS.Client.GetPlayerData()
        if player and player.job then
            currentJob = player.job.name
            -- Auto on-duty check could be added here
        end
    end
end)

-- Toggle duty
function ToggleDuty()
    isOnDuty = not isOnDuty
    
    if isOnDuty then
        exports['as-core']:ShowNotification({
            title = 'On Duty',
            description = 'You are now on duty as EMS',
            type = 'success'
        })
    else
        exports['as-core']:ShowNotification({
            title = 'Off Duty',
            description = 'You are now off duty',
            type = 'info'
        })
    end
    
    TriggerServerEvent('as-ambulance:server:toggleDuty', isOnDuty)
end

-- Revive nearby player
function ReviveNearbyPlayer()
    if not isOnDuty then
        exports['as-core']:ShowNotification({
            title = 'Not On Duty',
            description = 'You must be on duty to revive players',
            type = 'error'
        })
        return
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local closestPlayer, closestDistance = lib.getClosestPlayer(coords, Config.ReviveDistance, false)
    
    if not closestPlayer then
        exports['as-core']:ShowNotification({
            title = 'No Player',
            description = 'No injured player nearby',
            type = 'error'
        })
        return
    end
    
    local targetPed = GetPlayerPed(GetPlayerFromServerId(closestPlayer))
    local targetCoords = GetEntityCoords(targetPed)
    
    -- Face the target
    TaskTurnPedToFaceCoord(ped, targetCoords.x, targetCoords.y, targetCoords.z, 1000)
    Wait(1000)
    
    -- Play animation
    if exports['as-core']:ShowProgressCircle({
        duration = Config.ReviveAnimation.duration,
        position = 'bottom',
        label = 'Reviving player...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = Config.ReviveAnimation.dict,
            clip = Config.ReviveAnimation.anim,
        },
    }) then
        -- Success
        TriggerServerEvent('as-ambulance:server:revivePlayer', closestPlayer)
    else
        -- Cancelled
        exports['as-core']:ShowNotification({
            title = 'Cancelled',
            description = 'Revive cancelled',
            type = 'error'
        })
    end
end

-- Heal nearby player
function HealNearbyPlayer()
    if not isOnDuty then
        exports['as-core']:ShowNotification({
            title = 'Not On Duty',
            description = 'You must be on duty to heal players',
            type = 'error'
        })
        return
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local closestPlayer, closestDistance = GetClosestPlayer(coords)
    
    if not closestPlayer then
        exports['as-core']:ShowNotification({
            title = 'No Player',
            description = 'No player nearby',
            type = 'error'
        })
        return
    end
    
    -- Play heal animation
    if exports['as-core']:ShowProgressCircle({
        duration = 3000,
        position = 'bottom',
        label = 'Treating patient...',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
        anim = {
            dict = 'amb@medic@standing@tendtodead@base',
            clip = 'base',
        },
    }) then
        TriggerServerEvent('as-ambulance:server:healPlayer', closestPlayer)
    else
        exports['as-core']:ShowNotification({
            title = 'Cancelled',
            description = 'Treatment cancelled',
            type = 'error'
        })
    end
end

-- Check vitals
function CheckVitals()
    if not isOnDuty then
        exports['as-core']:ShowNotification({
            title = 'Not On Duty',
            description = 'You must be on duty to check vitals',
            type = 'error'
        })
        return
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local closestPlayer, closestDistance = GetClosestPlayer(coords)
    
    if not closestPlayer then
        exports['as-core']:ShowNotification({
            title = 'No Player',
            description = 'No player nearby',
            type = 'error'
        })
        return
    end
    
    TriggerServerEvent('as-ambulance:server:checkVitals', closestPlayer)
end

-- Exports
exports('IsOnDuty', function()
    return isOnDuty
end)

exports('ReviveNearby', function()
    ReviveNearbyPlayer()
end)

exports('HealNearby', function()
    HealNearbyPlayer()
end)

-- Events
RegisterNetEvent('as-ambulance:client:setWaypoint', function(coords)
    SetNewWaypoint(coords.x, coords.y)
    exports['as-core']:ShowNotification({
        title = 'Emergency Call',
        description = 'Waypoint set to emergency location',
        type = 'inform'
    })
end)

RegisterNetEvent('as-ambulance:client:showVitals', function(data)
    exports['as-core']:ShowNotification({
        title = 'Patient Vitals',
        description = string.format('Health: %d%%\nArmor: %d%%', data.health, data.armor),
        type = 'info',
        duration = 5000
    })
end)
