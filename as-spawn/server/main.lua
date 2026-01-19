local AS = exports['as-core']:GetCoreObject()

-- Get player spawn location
AS.Server.RegisterCallback('as-spawn:server:getSpawnLocation', function(source)
    local player = AS.Server.GetPlayer(source)
    
    if player and player.data.position then
        local pos = json.decode(player.data.position)
        return {
            x = pos.x,
            y = pos.y,
            z = pos.z,
            heading = pos.heading or 0.0
        }
    end
    
    return nil
end)

-- Save selected spawn
RegisterNetEvent('as-spawn:server:saveSpawn', function(coords)
    local source = source
    local player = AS.Server.GetPlayer(source)
    
    if player then
        player.setCoords(coords)
        player.save()
    end
end)

print('^2[AS-SPAWN]^7 Server main loaded')
