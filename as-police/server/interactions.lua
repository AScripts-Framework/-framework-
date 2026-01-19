-- Handle cuffing
RegisterNetEvent('as-police:server:cuffPlayer', function(targetId)
    local src = source
    
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    TriggerClientEvent('as-police:client:getCuffed', targetId)
    TriggerClientEvent('as-core:Notify', src, 'Player handcuffed/uncuffed', 'success')
end)

-- Handle dragging
RegisterNetEvent('as-police:server:dragPlayer', function(targetId)
    local src = source
    
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    TriggerClientEvent('as-police:client:getDragged', targetId, src)
end)

-- Put in vehicle
RegisterNetEvent('as-police:server:putInVehicle', function(targetId)
    local src = source
    
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    TriggerClientEvent('as-police:client:getPutInVehicle', targetId)
end)

-- Remove from vehicle
RegisterNetEvent('as-police:server:removeFromVehicle', function(targetId)
    local src = source
    
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    TriggerClientEvent('as-police:client:getOutOfVehicle', targetId)
end)

-- Fine player
RegisterNetEvent('as-police:server:finePlayer', function(targetId, amount, reason)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    local Target = exports['as-core']:GetPlayer(targetId)
    
    if not Player or not Target then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    -- Remove money from target
    if Target.removeMoney then
        Target.removeMoney('bank', amount, reason)
    end
    
    TriggerClientEvent('as-core:Notify', src, 'Fine issued: $' .. amount, 'success')
    TriggerClientEvent('as-core:Notify', targetId, 'You were fined $' .. amount .. ' for: ' .. reason, 'error')
    
    -- Log to database
    MySQL.insert('INSERT INTO police_fines (officer_identifier, citizen_identifier, amount, reason, issued_at) VALUES (?, ?, ?, ?, NOW())', {
        Player.identifier,
        Target.identifier,
        amount,
        reason
    })
end)
