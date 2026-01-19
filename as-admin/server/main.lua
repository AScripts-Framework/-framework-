local AS = exports['as-core']:GetCoreObject()

-- Get admin level
function GetAdminLevel(source)
    local player = AS.Server.GetPlayer(source)
    if not player then return 0 end
    
    -- Check superadmin
    if IsPlayerAceAllowed(source, Config.Admin.Permissions.superadmin.ace) then
        return 3
    end
    
    -- Check admin
    if IsPlayerAceAllowed(source, Config.Admin.Permissions.admin.ace) then
        return 2
    end
    
    -- Check moderator
    if IsPlayerAceAllowed(source, Config.Admin.Permissions.moderator.ace) then
        return 1
    end
    
    -- Check job
    local job = player.getJob()
    if job then
        for _, adminJob in pairs(Config.Admin.Permissions.superadmin.jobs) do
            if job.name == adminJob then return 3 end
        end
        for _, adminJob in pairs(Config.Admin.Permissions.admin.jobs) do
            if job.name == adminJob then return 2 end
        end
        for _, adminJob in pairs(Config.Admin.Permissions.moderator.jobs) do
            if job.name == adminJob then return 1 end
        end
    end
    
    return 0
end

-- Check if player has permission for feature
function HasPermission(source, feature)
    local adminLevel = GetAdminLevel(source)
    local requiredLevel = Config.Admin.Features[feature] or 99
    return adminLevel >= requiredLevel
end

-- Get online players
RegisterNetEvent('as-admin:getPlayers')
AddEventHandler('as-admin:getPlayers', function()
    local source = source
    
    if GetAdminLevel(source) == 0 then return end
    
    local players = {}
    local allPlayers = AS.Server.GetPlayers()
    
    for _, playerId in ipairs(allPlayers) do
        local player = AS.Server.GetPlayer(playerId)
        if player then
            table.insert(players, {
                id = playerId,
                name = GetPlayerName(playerId),
                identifier = player.getIdentifier(),
                job = player.getJob(),
                money = player.getAccount('bank')
            })
        end
    end
    
    TriggerClientEvent('as-admin:receivePlayerList', source, players)
end)

-- Get admin level for client
RegisterNetEvent('as-admin:checkPermission')
AddEventHandler('as-admin:checkPermission', function()
    local source = source
    local level = GetAdminLevel(source)
    TriggerClientEvent('as-admin:setAdminLevel', source, level)
end)

-- Send Discord log
function SendLog(action, admin, target, details)
    if not Config.Admin.Logging.enabled or Config.Admin.Logging.webhook == '' then return end
    
    local embed = {
        {
            ['title'] = '🛡️ Admin Action',
            ['color'] = Config.Admin.Logging.color,
            ['fields'] = {
                {
                    ['name'] = 'Action',
                    ['value'] = action,
                    ['inline'] = true
                },
                {
                    ['name'] = 'Admin',
                    ['value'] = GetPlayerName(admin),
                    ['inline'] = true
                },
                {
                    ['name'] = 'Target',
                    ['value'] = target or 'N/A',
                    ['inline'] = true
                },
                {
                    ['name'] = 'Details',
                    ['value'] = details or 'N/A',
                    ['inline'] = false
                }
            },
            ['footer'] = {
                ['text'] = 'AS Admin Menu'
            },
            ['timestamp'] = os.date('!%Y-%m-%dT%H:%M:%S')
        }
    }
    
    PerformHttpRequest(Config.Admin.Logging.webhook, function(err, text, headers) end, 'POST', json.encode({
        username = 'AS Admin',
        embeds = embed
    }), {['Content-Type'] = 'application/json'})
end

-- Export functions
exports('GetAdminLevel', GetAdminLevel)
exports('HasPermission', HasPermission)
exports('SendLog', SendLog)

print('^2[AS-Admin]^7 Server main loaded')
