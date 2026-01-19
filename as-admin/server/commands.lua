local AS = exports['as-core']:GetCoreObject()

-- Register admin commands
local function RegisterCommand(name, permission, callback)
    RegisterCommand(name, function(source, args, rawCommand)
        if not HasPermission(source, permission) then
            TriggerClientEvent('ox_lib:notify', source, {
                title = 'Admin',
                description = 'You don\'t have permission',
                type = 'error'
            })
            return
        end
        
        callback(source, args, rawCommand)
    end, false)
end

-- Noclip
RegisterCommand('noclip', 'noclip', function(source, args)
    TriggerClientEvent('as-admin:toggleNoclip', source)
end)

-- Godmode
RegisterCommand('god', 'god', function(source, args)
    TriggerClientEvent('as-admin:toggleGod', source)
end)

-- Invisible
RegisterCommand('invis', 'invisible', function(source, args)
    TriggerClientEvent('as-admin:toggleInvisible', source)
end)

-- Spectate
RegisterCommand('spectate', 'spectate', function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /spectate [id]',
            type = 'error'
        })
        return
    end
    
    TriggerClientEvent('as-admin:spectatePlayer', source, targetId)
end)

-- Quick teleports
RegisterCommand('tp', 'teleport', function(source, args)
    if not args[1] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /tp [id] or /tp [x] [y] [z]',
            type = 'error'
        })
        return
    end
    
    -- Teleport to player
    if #args == 1 then
        local targetId = tonumber(args[1])
        if not targetId then return end
        
        local targetCoords = GetEntityCoords(GetPlayerPed(targetId))
        TriggerClientEvent('as-admin:teleportTo', source, targetCoords)
    -- Teleport to coordinates
    elseif #args == 3 then
        local x, y, z = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
        if not x or not y or not z then return end
        
        TriggerClientEvent('as-admin:teleportTo', source, vector3(x, y, z))
    end
end)

-- Bring player
RegisterCommand('bring', 'teleport', function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /bring [id]',
            type = 'error'
        })
        return
    end
    
    local adminCoords = GetEntityCoords(GetPlayerPed(source))
    TriggerClientEvent('as-admin:teleportTo', targetId, adminCoords)
end)

-- Kick
RegisterCommand('kick', 'kick', function(source, args)
    local targetId = tonumber(args[1])
    if not targetId then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /kick [id] [reason]',
            type = 'error'
        })
        return
    end
    
    local reason = table.concat(args, ' ', 2) or 'Kicked by admin'
    TriggerEvent('as-admin:kickPlayer', targetId, reason)
end)

-- Ban
RegisterCommand('ban', 'ban', function(source, args)
    local targetId = tonumber(args[1])
    local duration = tonumber(args[2]) or 0
    
    if not targetId then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /ban [id] [days] [reason]',
            type = 'error'
        })
        return
    end
    
    local reason = table.concat(args, ' ', 3) or 'Banned by admin'
    TriggerEvent('as-admin:banPlayer', targetId, reason, duration)
end)

-- Announce
RegisterCommand('announce', 'announce', function(source, args)
    if not args[1] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /announce [message]',
            type = 'error'
        })
        return
    end
    
    local message = table.concat(args, ' ')
    TriggerEvent('as-admin:announcement', message)
end)

-- Weather
RegisterCommand('weather', 'weather', function(source, args)
    if not args[1] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /weather [type]',
            type = 'error'
        })
        return
    end
    
    TriggerEvent('as-admin:setWeather', args[1])
end)

-- Time
RegisterCommand('time', 'time', function(source, args)
    local hour = tonumber(args[1])
    local minute = tonumber(args[2]) or 0
    
    if not hour then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /time [hour] [minute]',
            type = 'error'
        })
        return
    end
    
    TriggerEvent('as-admin:setTime', hour, minute)
end)

-- Vehicle
RegisterCommand('car', 'vehicle', function(source, args)
    if not args[1] then
        TriggerClientEvent('ox_lib:notify', source, {
            title = 'Admin',
            description = 'Usage: /car [model]',
            type = 'error'
        })
        return
    end
    
    TriggerEvent('as-admin:spawnVehicle', args[1])
end)

RegisterCommand('dv', 'vehicle', function(source, args)
    TriggerEvent('as-admin:deleteVehicle')
end)

RegisterCommand('fix', 'vehicle', function(source, args)
    TriggerEvent('as-admin:repairVehicle')
end)

-- Heal
RegisterCommand('heal', 'heal', function(source, args)
    local targetId = tonumber(args[1]) or source
    TriggerEvent('as-admin:healPlayer', targetId)
end)

-- Revive
RegisterCommand('revive', 'revive', function(source, args)
    local targetId = tonumber(args[1]) or source
    TriggerEvent('as-admin:revivePlayer', targetId)
end)

print('^2[AS-Admin]^7 Server commands loaded')
