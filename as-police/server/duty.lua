local onDutyOfficers = {}

-- Toggle duty status
RegisterNetEvent('as-police:server:toggleDuty', function()
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    
    local job = Player.job
    local isPolice = false
    
    for _, policeJob in ipairs(Config.PoliceJobs) do
        if job.name == policeJob then
            isPolice = true
            break
        end
    end
    
    if not isPolice then
        TriggerClientEvent('as-core:Notify', src, 'You are not a police officer', 'error')
        return
    end
    
    onDutyOfficers[src] = not onDutyOfficers[src]
    
    if onDutyOfficers[src] then
        TriggerClientEvent('as-core:Notify', src, 'You are now on duty', 'success')
        TriggerClientEvent('as-police:client:setDuty', src, true)
    else
        TriggerClientEvent('as-core:Notify', src, 'You are now off duty', 'info')
        TriggerClientEvent('as-police:client:setDuty', src, false)
    end
    
    -- Sync duty status to all players
    TriggerClientEvent('as-police:client:updateDutyCount', -1, GetOnDutyCount())
end)

-- Get on-duty count
function GetOnDutyCount()
    local count = 0
    for _, status in pairs(onDutyOfficers) do
        if status then
            count = count + 1
        end
    end
    return count
end

-- Check if player is on duty
function IsOnDuty(source)
    return onDutyOfficers[source] or false
end

-- Player disconnect
AddEventHandler('playerDropped', function()
    local src = source
    if onDutyOfficers[src] then
        onDutyOfficers[src] = nil
        TriggerClientEvent('as-police:client:updateDutyCount', -1, GetOnDutyCount())
    end
end)

-- Export functions
exports('GetOnDutyCount', GetOnDutyCount)
exports('IsOnDuty', IsOnDuty)
