local isOnDuty = false

-- Create duty points
CreateThread(function()
    for stationId, station in pairs(Config.Stations) do
        exports['as-target']:AddBoxZone('police_duty_' .. stationId, station.duty.coords, 1.5, 1.5, {
            name = 'police_duty_' .. stationId,
            heading = station.duty.heading,
            debugPoly = false,
            minZ = station.duty.coords.z - 1.0,
            maxZ = station.duty.coords.z + 1.0
        }, {
            options = {
                {
                    type = 'client',
                    event = 'as-police:client:toggleDuty',
                    icon = 'fas fa-sign-in-alt',
                    label = 'Toggle Duty',
                }
            },
            distance = 2.0
        })
    end
end)

-- Toggle duty
RegisterNetEvent('as-police:client:toggleDuty', function()
    TriggerServerEvent('as-police:server:toggleDuty')
end)

-- Set duty status
RegisterNetEvent('as-police:client:setDuty', function(status)
    isOnDuty = status
    
    -- Set ped as police
    local ped = PlayerPedId()
    if status then
        SetPedRelationshipGroupHash(ped, GetHashKey('COP'))
        SetPoliceIgnorePlayer(ped, true)
    else
        SetPedRelationshipGroupHash(ped, GetHashKey('PLAYER'))
        SetPoliceIgnorePlayer(ped, false)
    end
end)
