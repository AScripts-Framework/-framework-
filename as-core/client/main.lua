AS = AS or {}
AS.Client = {}
AS.PlayerData = {}
AS.PlayerLoaded = false

-- Initialize framework on client
CreateThread(function()
    while GetResourceState('ox_lib') ~= 'started' do
        Wait(100)
    end
    
    print('^2[AS-CORE]^7 Client initialized')
end)

-- Get core object
function AS.Client.GetCoreObject()
    return AS
end

-- Get player data
function AS.Client.GetPlayerData()
    return AS.PlayerData
end

-- Is player loaded
function AS.Client.IsPlayerLoaded()
    return AS.PlayerLoaded
end

-- Trigger server callback
function AS.Client.TriggerCallback(name, ...)
    return lib.callback.await(name, false, ...)
end

-- Request player load
CreateThread(function()
    -- Wait for player to spawn
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    
    -- Request player data from server
    TriggerServerEvent('as-core:server:loadPlayer')
end)

-- Player loaded event
RegisterNetEvent('as-core:client:playerLoaded', function(playerData)
    AS.PlayerData = playerData
    AS.PlayerLoaded = true
    
    print('^2[AS-CORE]^7 Player loaded successfully')
    
    -- Trigger custom event for other resources
    TriggerEvent('as-core:client:onPlayerLoaded')
    
    -- Start position saving thread
    CreateThread(function()
        while AS.PlayerLoaded do
            Wait(60000) -- Save position every minute
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            
            TriggerServerEvent('as-core:server:updateCoords', {
                x = coords.x,
                y = coords.y,
                z = coords.z,
                heading = heading
            })
        end
    end)
end)

-- Update money
RegisterNetEvent('as-core:client:updateMoney', function(account, amount)
    if AS.PlayerData.money then
        if type(AS.PlayerData.money) == 'string' then
            AS.PlayerData.money = json.decode(AS.PlayerData.money)
        end
        AS.PlayerData.money[account] = amount
        TriggerEvent('as-core:client:onMoneyChange', account, amount)
    end
end)

-- Update job
RegisterNetEvent('as-core:client:updateJob', function(job, grade)
    AS.PlayerData.job = job
    AS.PlayerData.job_grade = grade
    TriggerEvent('as-core:client:onJobUpdate', job, grade)
end)

-- Update group
RegisterNetEvent('as-core:client:updateGroup', function(group)
    AS.PlayerData.group = group
    TriggerEvent('as-core:client:onGroupUpdate', group)
end)

-- Update metadata
RegisterNetEvent('as-core:client:updateMetadata', function(key, value)
    if type(AS.PlayerData.metadata) == 'string' then
        AS.PlayerData.metadata = json.decode(AS.PlayerData.metadata)
    end
    AS.PlayerData.metadata[key] = value
    TriggerEvent('as-core:client:onMetadataUpdate', key, value)
end)

-- Exports
exports('GetCoreObject', function()
    return AS
end)

exports('GetPlayerData', function()
    return AS.PlayerData
end)

exports('IsPlayerLoaded', function()
    return AS.PlayerLoaded
end)

-- Player logout
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        AS.PlayerLoaded = false
        AS.PlayerData = {}
    end
end)

print('^2[AS-CORE]^7 Client main loaded')
