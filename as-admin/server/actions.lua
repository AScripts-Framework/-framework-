local AS = exports['as-core']:GetCoreObject()

-- Player management actions
RegisterNetEvent('as-admin:kickPlayer')
AddEventHandler('as-admin:kickPlayer', function(targetId, reason)
    local source = source
    
    if not HasPermission(source, 'kick') then return end
    
    local targetPlayer = AS.Server.GetPlayer(targetId)
    if not targetPlayer then return end
    
    DropPlayer(targetId, reason or 'Kicked by admin')
    SendLog('Kick', source, GetPlayerName(targetId), reason or 'No reason provided')
end)

RegisterNetEvent('as-admin:banPlayer')
AddEventHandler('as-admin:banPlayer', function(targetId, reason, duration)
    local source = source
    
    if not HasPermission(source, 'ban') then return end
    
    local targetPlayer = AS.Server.GetPlayer(targetId)
    if not targetPlayer then return end
    
    local identifier = targetPlayer.getIdentifier()
    local bannedUntil = duration > 0 and (os.time() + (duration * 86400)) or 0
    
    MySQL.insert('INSERT INTO as_bans (identifier, reason, banned_by, banned_until) VALUES (?, ?, ?, ?)', {
        identifier,
        reason or 'Banned by admin',
        GetPlayerName(source),
        bannedUntil
    })
    
    DropPlayer(targetId, string.format('Banned: %s', reason or 'No reason provided'))
    
    local durationText = duration > 0 and duration .. ' days' or 'Permanent'
    SendLog('Ban', source, GetPlayerName(targetId), string.format('%s (%s)', reason or 'No reason', durationText))
end)

RegisterNetEvent('as-admin:warnPlayer')
AddEventHandler('as-admin:warnPlayer', function(targetId, message)
    local source = source
    
    if not HasPermission(source, 'warn') then return end
    
    TriggerClientEvent('as-admin:receiveWarning', targetId, message)
    SendLog('Warn', source, GetPlayerName(targetId), message)
end)

RegisterNetEvent('as-admin:notifyPlayer')
AddEventHandler('as-admin:notifyPlayer', function(targetId, message, notifyType)
    local source = source
    
    if not HasPermission(source, 'warn') then return end
    
    TriggerClientEvent('ox_lib:notify', targetId, {
        title = 'Admin',
        description = message,
        type = notifyType or 'info'
    })
    SendLog('Notify', source, GetPlayerName(targetId), message)
end)

RegisterNetEvent('as-admin:freezePlayer')
AddEventHandler('as-admin:freezePlayer', function(targetId, freeze)
    local source = source
    
    if not HasPermission(source, 'freeze') then return end
    
    TriggerClientEvent('as-admin:setFrozen', targetId, freeze)
    SendLog('Freeze', source, GetPlayerName(targetId), freeze and 'Frozen' or 'Unfrozen')
end)

-- Teleport actions
RegisterNetEvent('as-admin:teleportToPlayer')
AddEventHandler('as-admin:teleportToPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'teleport') then return end
    
    local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
    TriggerClientEvent('as-admin:teleportTo', source, targetCoords)
    SendLog('Teleport', source, GetPlayerName(targetId), 'Teleported to player')
end)

RegisterNetEvent('as-admin:bringPlayer')
AddEventHandler('as-admin:bringPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'teleport') then return end
    
    local adminCoords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent('as-admin:teleportTo', targetId, adminCoords)
    SendLog('Bring', source, GetPlayerName(targetId), 'Brought player')
end)

RegisterNetEvent('as-admin:teleportToCoords')
AddEventHandler('as-admin:teleportToCoords', function(coords)
    local source = source
    
    if not HasPermission(source, 'teleport') then return end
    
    TriggerClientEvent('as-admin:teleportTo', source, coords)
end)

-- Vehicle actions
RegisterNetEvent('as-admin:spawnVehicle')
AddEventHandler('as-admin:spawnVehicle', function(model)
    local source = source
    
    if not HasPermission(source, 'vehicle') then return end
    
    TriggerClientEvent('as-admin:spawnVeh', source, model)
    SendLog('Spawn Vehicle', source, nil, model)
end)

RegisterNetEvent('as-admin:deleteVehicle')
AddEventHandler('as-admin:deleteVehicle', function()
    local source = source
    
    if not HasPermission(source, 'vehicle') then return end
    
    TriggerClientEvent('as-admin:deleteVeh', source)
    SendLog('Delete Vehicle', source, nil, 'Deleted nearby vehicle')
end)

RegisterNetEvent('as-admin:repairVehicle')
AddEventHandler('as-admin:repairVehicle', function()
    local source = source
    
    if not HasPermission(source, 'vehicle') then return end
    
    TriggerClientEvent('as-admin:repairVeh', source)
    SendLog('Repair Vehicle', source, nil, 'Repaired vehicle')
end)

-- Money actions
RegisterNetEvent('as-admin:giveMoney')
AddEventHandler('as-admin:giveMoney', function(targetId, account, amount)
    local source = source
    
    if not HasPermission(source, 'money') then return end
    
    local targetPlayer = AS.Server.GetPlayer(targetId)
    if not targetPlayer then return end
    
    targetPlayer.addMoney(account, amount)
    SendLog('Give Money', source, GetPlayerName(targetId), string.format('$%s to %s', amount, account))
end)

RegisterNetEvent('as-admin:removeMoney')
AddEventHandler('as-admin:removeMoney', function(targetId, account, amount)
    local source = source
    
    if not HasPermission(source, 'money') then return end
    
    local targetPlayer = AS.Server.GetPlayer(targetId)
    if not targetPlayer then return end
    
    targetPlayer.removeMoney(account, amount)
    SendLog('Remove Money', source, GetPlayerName(targetId), string.format('$%s from %s', amount, account))
end)

-- Job actions
RegisterNetEvent('as-admin:setJob')
AddEventHandler('as-admin:setJob', function(targetId, job, grade)
    local source = source
    
    if not HasPermission(source, 'job') then return end
    
    local targetPlayer = AS.Server.GetPlayer(targetId)
    if not targetPlayer then return end
    
    targetPlayer.setJob(job, grade or 0)
    SendLog('Set Job', source, GetPlayerName(targetId), string.format('%s (Grade %s)', job, grade or 0))
end)

-- Server actions
RegisterNetEvent('as-admin:setWeather')
AddEventHandler('as-admin:setWeather', function(weather)
    local source = source
    
    if not HasPermission(source, 'weather') then return end
    
    TriggerClientEvent('as-admin:syncWeather', -1, weather)
    SendLog('Set Weather', source, nil, weather)
end)

RegisterNetEvent('as-admin:setTime')
AddEventHandler('as-admin:setTime', function(hour, minute)
    local source = source
    
    if not HasPermission(source, 'time') then return end
    
    TriggerClientEvent('as-admin:syncTime', -1, hour, minute)
    SendLog('Set Time', source, nil, string.format('%02d:%02d', hour, minute))
end)

RegisterNetEvent('as-admin:announcement')
AddEventHandler('as-admin:announcement', function(message)
    local source = source
    
    if not HasPermission(source, 'announce') then return end
    
    TriggerClientEvent('as-admin:showAnnouncement', -1, message)
    SendLog('Announcement', source, nil, message)
end)

RegisterNetEvent('as-admin:revivePlayer')
AddEventHandler('as-admin:revivePlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'revive') then return end
    
    TriggerClientEvent('as-admin:revive', targetId)
    SendLog('Revive', source, GetPlayerName(targetId), 'Revived player')
end)

RegisterNetEvent('as-admin:healPlayer')
AddEventHandler('as-admin:healPlayer', function(targetId)
    local source = source
    
    if not HasPermission(source, 'heal') then return end
    
    TriggerClientEvent('as-admin:heal', targetId)
    SendLog('Heal', source, GetPlayerName(targetId), 'Healed player')
end)

print('^2[AS-Admin]^7 Server actions loaded')
