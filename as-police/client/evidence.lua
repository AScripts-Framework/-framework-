local activeEvidence = {}

-- Create evidence locations
CreateThread(function()
    for stationId, station in pairs(Config.Stations) do
        exports['as-target']:AddBoxZone('police_evidence_' .. stationId, station.evidence.coords, 2.0, 1.5, {
            name = 'police_evidence_' .. stationId,
            heading = station.evidence.heading,
            debugPoly = false,
            minZ = station.evidence.coords.z - 1.0,
            maxZ = station.evidence.coords.z + 1.0
        }, {
            options = {
                {
                    type = 'client',
                    event = 'as-police:client:evidenceLocker',
                    icon = 'fas fa-archive',
                    label = 'Evidence Locker',
                    canInteract = function()
                        return exports['as-police']:IsOnDuty()
                    end
                }
            },
            distance = 2.0
        })
    end
end)

-- Evidence menu
RegisterNetEvent('as-police:client:evidenceMenu', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local nearbyEvidence = {}
    
    for id, evidence in pairs(activeEvidence) do
        if #(coords - evidence.coords) < 50.0 then
            table.insert(nearbyEvidence, {id = id, evidence = evidence})
        end
    end
    
    if #nearbyEvidence == 0 then
        exports['as-core']:ShowNotification('No evidence nearby', 'error')
        return
    end
    
    local menuItems = {
        {header = 'Nearby Evidence', isMenuHeader = true},
    }
    
    for _, data in ipairs(nearbyEvidence) do
        local distance = math.floor(#(coords - data.evidence.coords))
        table.insert(menuItems, {
            header = data.evidence.type,
            txt = distance .. 'm away',
            params = {
                event = 'as-police:client:collectEvidence',
                args = {id = data.id}
            }
        })
    end
    
    exports['as-core']:ShowContext(menuItems)
end)

-- Collect evidence
RegisterNetEvent('as-police:client:collectEvidence', function(data)
    local ped = PlayerPedId()
    
    exports['as-core']:ShowProgressCircle({
        duration = 5000,
        label = 'Collecting evidence...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'amb@medic@standing@kneel@base',
            clip = 'base',
            flag = 1
        }
    }, function(cancelled)
        if not cancelled then
            TriggerServerEvent('as-police:server:collectEvidence', data.id)
        end
        ClearPedTasks(ped)
    end)
end)

-- Sync evidence
RegisterNetEvent('as-police:client:syncEvidence', function(id, evidence)
    activeEvidence[id] = evidence
    
    -- Create marker/blip for evidence (optional)
    if exports['as-police']:IsOnDuty() then
        local blip = AddBlipForCoord(evidence.coords.x, evidence.coords.y, evidence.coords.z)
        SetBlipSprite(blip, 1)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 5)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Evidence: ' .. evidence.type)
        EndTextCommandSetBlipName(blip)
        
        evidence.blip = blip
    end
end)

-- Remove evidence
RegisterNetEvent('as-police:client:removeEvidence', function(id)
    if activeEvidence[id] then
        if activeEvidence[id].blip then
            RemoveBlip(activeEvidence[id].blip)
        end
        activeEvidence[id] = nil
    end
end)

-- Load all evidence
RegisterNetEvent('as-police:client:loadEvidence', function(evidenceData)
    activeEvidence = evidenceData
end)

-- Evidence locker
RegisterNetEvent('as-police:client:evidenceLocker', function()
    exports['as-core']:ShowNotification('Evidence locker coming soon', 'info')
end)

-- Blood trail when shot
AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' then
        local victim = data[1]
        local attacker = data[2]
        local weapon = data[7]
        
        if IsEntityAPed(victim) and IsPedAPlayer(victim) then
            local victimCoords = GetEntityCoords(victim)
            
            -- Create blood trail
            if Config.Evidence.enableBloodTrails then
                TriggerServerEvent('as-police:server:createBloodTrail', victimCoords)
            end
        end
    end
end)

-- Bullet casings when shooting
CreateThread(function()
    while true do
        Wait(0)
        
        local ped = PlayerPedId()
        if IsPedShooting(ped) and Config.Evidence.enableBulletCasings then
            local weapon = GetSelectedPedWeapon(ped)
            local coords = GetEntityCoords(ped)
            
            TriggerServerEvent('as-police:server:createBulletCasing', coords, weapon)
        end
    end
end)
