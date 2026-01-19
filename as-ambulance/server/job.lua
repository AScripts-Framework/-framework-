local AS = exports['as-core']:GetCoreObject()

-- Revive player
RegisterNetEvent('as-ambulance:server:revivePlayer', function(targetId)
    local src = source
    local player = AS.Server.GetPlayer(src)
    local target = AS.Server.GetPlayer(targetId)
    
    if not player or not target then return end
    
    -- Check if source is EMS
    if player.job.name ~= Config.JobName then
        return
    end
    
    -- Revive target
    TriggerClientEvent('as-ambulance:client:revive', targetId)
    
    -- Reward EMS
    player.addMoney('bank', Config.ReviveReward)
    
    lib.notify(src, {
        title = 'Player Revived',
        description = 'You revived ' .. target.getName() .. ' and received $' .. Config.ReviveReward,
        type = 'success'
    })
    
    lib.notify(targetId, {
        title = 'Revived',
        description = 'You have been revived by ' .. player.getName(),
        type = 'success'
    })
    
    -- Log
    if Config.EnableLogging and Config.WebhookURL ~= '' then
        SendLog(Config.WebhookURL, {
            title = 'Player Revived',
            color = 3066993, -- Green
            fields = {
                {name = 'EMS', value = player.getName(), inline = true},
                {name = 'Patient', value = target.getName(), inline = true},
                {name = 'Reward', value = '$' .. Config.ReviveReward, inline = true},
            },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
        })
    end
end)

-- Heal player
RegisterNetEvent('as-ambulance:server:healPlayer', function(targetId)
    local src = source
    local player = AS.Server.GetPlayer(src)
    local target = AS.Server.GetPlayer(targetId)
    
    if not player or not target then return end
    
    -- Check if source is EMS
    if player.job.name ~= Config.JobName then
        return
    end
    
    -- Heal target
    TriggerClientEvent('as-ambulance:client:heal', targetId, 200)
    
    lib.notify(src, {
        title = 'Player Healed',
        description = 'You healed ' .. target.getName(),
        type = 'success'
    })
    
    lib.notify(targetId, {
        title = 'Healed',
        description = 'You have been treated by ' .. player.getName(),
        type = 'success'
    })
end)

-- Check in at hospital
RegisterNetEvent('as-ambulance:server:checkIn', function()
    local src = source
    local player = AS.Server.GetPlayer(src)
    
    if not player then return end
    
    -- Check if player has enough money
    if player.getMoney('bank') < Config.HealPrice then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Insufficient Funds',
            description = 'You need $' .. Config.HealPrice,
            type = 'error'
        })
        return
    end
    
    -- Remove money
    player.removeMoney('bank', Config.HealPrice)
    
    -- Heal player
    TriggerClientEvent('as-ambulance:client:checkInComplete', src)
end)

-- Check vitals
RegisterNetEvent('as-ambulance:server:checkVitals', function(targetId)
    local src = source
    local player = AS.Server.GetPlayer(src)
    
    if not player then return end
    
    -- Check if source is EMS
    if player.job.name ~= Config.JobName then
        return
    end
    
    -- Get target vitals
    local targetPed = GetPlayerPed(targetId)
    local health = GetEntityHealth(targetPed)
    local armor = GetPedArmour(targetPed)
    
    TriggerClientEvent('as-ambulance:client:showVitals', src, {
        health = math.floor((health / 200) * 100),
        armor = armor
    })
end)

-- Toggle duty
RegisterNetEvent('as-ambulance:server:toggleDuty', function(onDuty)
    local src = source
    local player = AS.Server.GetPlayer(src)
    
    if not player then return end
    
    -- Check if player is EMS
    if player.job.name ~= Config.JobName then
        return
    end
    
    -- Could set player metadata here for duty status
    -- player.setMeta('onDuty', onDuty)
end)

-- Discord logging
function SendLog(webhook, data)
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'AS Ambulance',
        embeds = {{
            title = data.title,
            color = data.color,
            fields = data.fields,
            timestamp = data.timestamp,
            footer = {text = 'AS Framework'}
        }}
    }), {['Content-Type'] = 'application/json'})
end
