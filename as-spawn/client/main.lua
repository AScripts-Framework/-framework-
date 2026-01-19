local AS = exports['as-core']:GetCoreObject()

-- Disable default spawn
AddEventHandler('playerSpawned', function()
    -- This prevents the default GTA spawn
end)

-- Prevent player from spawning before character selection
CreateThread(function()
    exports.spawnmanager:setAutoSpawn(false)
end)

print('^2[AS-SPAWN]^7 Client main loaded')
