AS = exports['as-core']:GetCoreObject()

-- Pay for fuel/charging
RegisterNetEvent('as-fuel:server:PayForFuel', function(cost, isCharging)
    local src = source
    local player = AS.Server.GetPlayer(src)
    
    if not player then return end
    
    -- Check if player has enough money
    if player.getMoney('cash') >= cost then
        player.removeMoney('cash', cost)
    elseif player.getMoney('bank') >= cost then
        player.removeMoney('bank', cost)
    else
        AS.Server.Notify(src, 'Not enough money!', 'error')
        TriggerClientEvent('as-fuel:client:StopRefueling', src)
    end
end)

-- Client event to stop refueling
RegisterNetEvent('as-fuel:client:StopRefueling', function()
    exports['as-fuel']:StopRefueling()
end)

print('^2[AS-FUEL]^7 Server initialized')
