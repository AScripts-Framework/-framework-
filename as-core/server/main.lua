AS = AS or {}
AS.Server = {}
AS.Players = {}
AS.UseFunctions = {}

-- Initialize framework
CreateThread(function()
    while GetResourceState('ox_lib') ~= 'started' do
        Wait(100)
    end
    
    while GetResourceState('oxmysql') ~= 'started' do
        Wait(100)
    end
    
    print('^2[AS-CORE]^7 Framework initialized successfully!')
    
    -- Initialize database
    AS.Database.Initialize()
    
    -- Start auto-save
    if Config.Database.AutoSave then
        CreateThread(function()
            while true do
                Wait(Config.Database.AutoSaveInterval)
                AS.Server.SaveAllPlayers()
            end
        end)
    end
    
    -- Check for updates
    if Config.Framework.UpdateCheck then
        AS.Version.Check()
    end
end)

-- Get player by source
function AS.Server.GetPlayer(source)
    return AS.Players[source]
end

-- Get player by identifier
function AS.Server.GetPlayerByIdentifier(identifier)
    for _, player in pairs(AS.Players) do
        if player.identifier == identifier then
            return player
        end
    end
    return nil
end

-- Get all players
function AS.Server.GetPlayers()
    return AS.Players
end

-- Save all players
function AS.Server.SaveAllPlayers()
    local count = 0
    for source, player in pairs(AS.Players) do
        player.save()
        count = count + 1
    end
    if Config.Debug then
        print('^3[AS-CORE]^7 Auto-saved ' .. count .. ' players')
    end
end

-- Register server callback using ox_lib
function AS.Server.RegisterCallback(name, cb)
    lib.callback.register(name, cb)
end

-- Use functions (similar to ESX/QBCore pattern)
function AS.UseFunctions.GetPlayer(source)
    return AS.Server.GetPlayer(source)
end

function AS.UseFunctions.GetPlayers()
    return AS.Server.GetPlayers()
end

function AS.UseFunctions.GetPlayerByIdentifier(identifier)
    return AS.Server.GetPlayerByIdentifier(identifier)
end

-- Exports
exports('GetCoreObject', function()
    return AS
end)

exports('GetPlayer', function(source)
    return AS.Server.GetPlayer(source)
end)

-- Player connecting
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    deferrals.defer()
    
    local playerId = source
    local identifiers = GetPlayerIdentifiers(playerId)
    local license = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, 'license:') then
            license = id
            break
        end
    end
    
    if not license then
        deferrals.done('No valid license found')
        return
    end
    
    deferrals.update('Checking whitelist...')
    Wait(500)
    
    deferrals.update('Loading player data...')
    Wait(500)
    
    deferrals.done()
end)

-- Player joined
AddEventHandler('playerJoining', function()
    local playerId = source
    if Config.Debug then
        print('^3[AS-CORE]^7 Player ' .. playerId .. ' joining...')
    end
end)

-- Player dropped
AddEventHandler('playerDropped', function(reason)
    local playerId = source
    local player = AS.Server.GetPlayer(playerId)
    
    if player then
        player.save()
        AS.Players[playerId] = nil
        
        if Config.Debug then
            print('^3[AS-CORE]^7 Player ' .. playerId .. ' disconnected: ' .. reason)
        end
    end
end)

-- Resource stop - save all players
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        AS.Server.SaveAllPlayers()
        print('^2[AS-CORE]^7 All players saved before shutdown')
    end
end)

-- Register events
RegisterNetEvent('as-core:server:playerLoaded', function()
    local playerId = source
    TriggerClientEvent('as-core:client:playerLoaded', playerId)
end)

RegisterNetEvent('as-core:server:updatePlayerData', function(data)
    local playerId = source
    local player = AS.Server.GetPlayer(playerId)
    
    if player then
        for key, value in pairs(data) do
            if player.data[key] ~= nil then
                player.data[key] = value
            end
        end
    end
end)

-- Admin commands
lib.addCommand('saveall', {
    help = 'Save all player data',
    restricted = 'group.admin'
}, function(source, args, raw)
    AS.Server.SaveAllPlayers()
    lib.notify(source, {
        title = 'Framework',
        description = 'All players saved successfully',
        type = 'success'
    })
end)

lib.addCommand('getplayers', {
    help = 'Get online players count',
    restricted = 'group.admin'
}, function(source, args, raw)
    local count = 0
    for _ in pairs(AS.Players) do
        count = count + 1
    end
    
    lib.notify(source, {
        title = 'Framework',
        description = 'Online players: ' .. count,
        type = 'info'
    })
end)

print('^2[AS-CORE]^7 Server main loaded')
