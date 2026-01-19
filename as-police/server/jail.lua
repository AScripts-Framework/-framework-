-- Send player to jail
RegisterNetEvent('as-police:server:jailPlayer', function(targetId, time, reason)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    local Target = exports['as-core']:GetPlayer(targetId)
    
    if not Player or not Target then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    -- Validate time
    if time > Config.Jail.maxTime then
        time = Config.Jail.maxTime
    end
    
    -- Insert into database
    MySQL.insert('INSERT INTO jail_records (identifier, officer_identifier, time, reason, jailed_at) VALUES (?, ?, ?, ?, NOW())', {
        Target.identifier,
        Player.identifier,
        time,
        reason
    }, function(id)
        -- Send to jail
        TriggerClientEvent('as-police:client:sendToJail', targetId, time, reason)
        TriggerClientEvent('as-core:Notify', src, 'Player sent to jail for ' .. time .. ' months', 'success')
        TriggerClientEvent('as-core:Notify', targetId, 'You have been jailed for ' .. time .. ' months', 'error')
        
        -- Log to Discord
        if Config.Logging.discord.enabled then
            local log = {
                title = 'Player Jailed',
                description = string.format('**Officer:** %s\n**Suspect:** %s\n**Time:** %d months\n**Reason:** %s', 
                    Player.name, Target.name, time, reason),
                color = 16711680
            }
            -- Send webhook (implement your webhook function)
        end
    end)
end)

-- Release player from jail
RegisterNetEvent('as-police:server:releasePlayer', function(targetId)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    local Target = exports['as-core']:GetPlayer(targetId)
    
    if not Player or not Target then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    TriggerClientEvent('as-police:client:releaseFromJail', targetId)
    TriggerClientEvent('as-core:Notify', src, 'Player released from jail', 'success')
    TriggerClientEvent('as-core:Notify', targetId, 'You have been released from jail', 'success')
end)

-- Check jail time on join
AddEventHandler('playerJoining', function()
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if Player then
        MySQL.query('SELECT * FROM jail_records WHERE identifier = ? AND released = 0 ORDER BY jailed_at DESC LIMIT 1', {
            Player.identifier
        }, function(result)
            if result[1] then
                local record = result[1]
                local jailedAt = os.time(record.jailed_at)
                local timeServed = math.floor((os.time() - jailedAt) / 60) -- minutes to months
                local remainingTime = record.time - timeServed
                
                if remainingTime > 0 then
                    TriggerClientEvent('as-police:client:sendToJail', src, remainingTime, record.reason)
                else
                    MySQL.update('UPDATE jail_records SET released = 1 WHERE id = ?', {record.id})
                end
            end
        end)
    end
end)
