local isOnDuty = false
local onDutyCount = 0

CreateThread(function()
    Wait(1000)
    
    -- Create station blips
    for stationId, station in pairs(Config.Stations) do
        local blip = AddBlipForCoord(station.blip.coords.x, station.blip.coords.y, station.blip.coords.z)
        SetBlipSprite(blip, station.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, station.blip.scale)
        SetBlipColour(blip, station.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName(station.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Register key mapping
RegisterCommand('police_menu', function()
    if isOnDuty then
        exports['as-core']:ShowContext({
            {header = 'Police Menu', isMenuHeader = true},
            {header = 'MDT', txt = 'Open Mobile Data Terminal', params = {event = 'as-police:client:openMDT'}},
            {header = 'Interactions', txt = 'Player interactions menu', params = {event = 'as-police:client:openInteractMenu'}},
            {header = 'Evidence', txt = 'View nearby evidence', params = {event = 'as-police:client:evidenceMenu'}},
        })
    else
        exports['as-core']:ShowNotification('You are not on duty', 'error')
    end
end, false)

RegisterKeyMapping('police_menu', 'Police Menu', 'keyboard', 'F6')

-- Update duty count
RegisterNetEvent('as-police:client:updateDutyCount', function(count)
    onDutyCount = count
end)

-- Export functions
exports('IsOnDuty', function()
    return isOnDuty
end)

exports('GetOnDutyCount', function()
    return onDutyCount
end)
