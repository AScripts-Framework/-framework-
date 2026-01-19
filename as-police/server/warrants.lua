-- Create warrant
RegisterNetEvent('as-police:server:createWarrant', function(targetIdentifier, reason, expiresIn)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    local expiresAt = os.time() + (expiresIn * 3600) -- Convert hours to seconds
    
    MySQL.insert('INSERT INTO warrants (identifier, issued_by, reason, expires_at, created_at) VALUES (?, ?, ?, FROM_UNIXTIME(?), NOW())', {
        targetIdentifier,
        Player.identifier,
        reason,
        expiresAt
    }, function(id)
        TriggerClientEvent('as-core:Notify', src, 'Warrant created', 'success')
        
        -- Log to Discord
        if Config.Logging.discord.enabled then
            local log = {
                title = 'Warrant Issued',
                description = string.format('**Officer:** %s\n**Suspect:** %s\n**Reason:** %s\n**Expires:** %d hours', 
                    Player.name, targetIdentifier, reason, expiresIn),
                color = 16776960
            }
            -- Send webhook (implement your webhook function)
        end
    end)
end)

-- Get active warrants
RegisterNetEvent('as-police:server:getWarrants', function()
    local src = source
    
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    MySQL.query('SELECT * FROM warrants WHERE active = 1 AND expires_at > NOW() ORDER BY created_at DESC', {}, function(result)
        TriggerClientEvent('as-police:client:loadWarrants', src, result)
    end)
end)

-- Check if player has warrant
function HasWarrant(identifier)
    local result = MySQL.query.await('SELECT * FROM warrants WHERE identifier = ? AND active = 1 AND expires_at > NOW() LIMIT 1', {identifier})
    return result[1] ~= nil
end

-- Execute warrant (arrest)
RegisterNetEvent('as-police:server:executeWarrant', function(warrantId)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    MySQL.update('UPDATE warrants SET active = 0, executed_by = ?, executed_at = NOW() WHERE id = ?', {
        Player.identifier,
        warrantId
    }, function(affectedRows)
        if affectedRows > 0 then
            TriggerClientEvent('as-core:Notify', src, 'Warrant executed', 'success')
        end
    end)
end)

exports('HasWarrant', HasWarrant)
