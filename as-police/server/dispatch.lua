-- Send dispatch alert
RegisterNetEvent('as-police:server:sendAlert', function(alertType, coords, message, data)
    local src = source
    
    if not Config.Dispatch.alerts[alertType] then return end
    
    local alert = Config.Dispatch.alerts[alertType]
    local alertData = {
        type = alertType,
        code = alert.code,
        label = alert.label,
        coords = coords,
        message = message or alert.label,
        data = data or {},
        time = os.date('%H:%M:%S'),
        sprite = alert.sprite,
        color = alert.color,
        blipTime = alert.blipTime
    }
    
    -- Send to all on-duty police
    local players = GetPlayers()
    for _, playerId in ipairs(players) do
        local id = tonumber(playerId)
        if exports['as-police']:IsOnDuty(id) then
            TriggerClientEvent('as-police:client:dispatchAlert', id, alertData)
        end
    end
end)

-- Player shot detection
RegisterNetEvent('as-police:server:shotsFired', function(coords, weapon)
    TriggerEvent('as-police:server:sendAlert', 'shooting', coords, 'Shots fired in the area', {weapon = weapon})
end)

-- Speeding detection
RegisterNetEvent('as-police:server:speedingVehicle', function(coords, speed, plate)
    if speed > Config.Radar.speedLimit then
        TriggerEvent('as-police:server:sendAlert', 'speeding', coords, 'Speeding vehicle detected', {speed = speed, plate = plate})
    end
end)
