local AS = exports['as-core']:GetCoreObject()

-- Handle player death
RegisterNetEvent('as-ambulance:server:onPlayerDeath', function(coords, cause)
    local src = source
    local player = AS.Server.GetPlayer(src)
    if not player then return end
    
    -- Log death
    if Config.EnableLogging and Config.WebhookURL ~= '' then
        local weaponName = 'Unknown'
        if cause then
            weaponName = GetWeaponName(cause)
        end
        
        SendLog(Config.WebhookURL, {
            title = 'Player Death',
            color = 15158332, -- Red
            fields = {
                {name = 'Player', value = player.getName(), inline = true},
                {name = 'Identifier', value = player.identifier, inline = true},
                {name = 'Cause', value = weaponName, inline = true},
                {name = 'Location', value = string.format('X: %.2f, Y: %.2f, Z: %.2f', coords.x, coords.y, coords.z), inline = false},
            },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
        })
    end
    
    -- Remove items on death if enabled
    if Config.RemoveItemsOnDeath then
        -- Implement item removal based on your inventory system
        -- TriggerEvent('inventory:server:clearInventory', src)
    end
end)

-- Handle player respawn
RegisterNetEvent('as-ambulance:server:onPlayerRespawn', function()
    local src = source
    local player = AS.Server.GetPlayer(src)
    if not player then return end
    
    -- Optional: Charge hospital bill
    -- player.removeMoney('bank', 500)
    
    if Config.EnableLogging and Config.WebhookURL ~= '' then
        SendLog(Config.WebhookURL, {
            title = 'Player Respawn',
            color = 3066993, -- Green
            fields = {
                {name = 'Player', value = player.getName(), inline = true},
                {name = 'Identifier', value = player.identifier, inline = true},
            },
            timestamp = os.date('!%Y-%m-%dT%H:%M:%S')
        })
    end
end)

-- Notify EMS of player in last stand
RegisterNetEvent('as-ambulance:server:notifyEMS', function(coords)
    local src = source
    local player = AS.Server.GetPlayer(src)
    if not player then return end
    
    -- Get all ambulance players
    local ambulancePlayers = AS.Server.GetPlayersWithJob(Config.JobName)
    
    for _, ambulancePlayer in ipairs(ambulancePlayers) do
        TriggerClientEvent('ox_lib:notify', ambulancePlayer, {
            title = 'Emergency Call',
            description = player.getName() .. ' is critically injured!',
            type = 'error',
            duration = 8000
        })
        
        -- Set waypoint for EMS
        TriggerClientEvent('as-ambulance:client:setWaypoint', ambulancePlayer, coords)
    end
end)

-- Get weapon name from hash
function GetWeaponName(hash)
    local weapons = {
        [`WEAPON_UNARMED`] = 'Unarmed',
        [`WEAPON_PISTOL`] = 'Pistol',
        [`WEAPON_COMBATPISTOL`] = 'Combat Pistol',
        [`WEAPON_APPISTOL`] = 'AP Pistol',
        [`WEAPON_MICROSMG`] = 'Micro SMG',
        [`WEAPON_SMG`] = 'SMG',
        [`WEAPON_ASSAULTRIFLE`] = 'Assault Rifle',
        [`WEAPON_CARBINERIFLE`] = 'Carbine Rifle',
        [`WEAPON_PUMPSHOTGUN`] = 'Pump Shotgun',
        [`WEAPON_SAWNOFFSHOTGUN`] = 'Sawed-Off Shotgun',
        [`WEAPON_SNIPERRIFLE`] = 'Sniper Rifle',
        [`WEAPON_HEAVYSNIPER`] = 'Heavy Sniper',
        [`WEAPON_GRENADELAUNCHER`] = 'Grenade Launcher',
        [`WEAPON_RPG`] = 'RPG',
        [`WEAPON_MOLOTOV`] = 'Molotov',
        [`WEAPON_GRENADE`] = 'Grenade',
        [`WEAPON_STICKYBOMB`] = 'Sticky Bomb',
        [`WEAPON_KNIFE`] = 'Knife',
        [`WEAPON_NIGHTSTICK`] = 'Nightstick',
        [`WEAPON_HAMMER`] = 'Hammer',
        [`WEAPON_BAT`] = 'Baseball Bat',
        [`WEAPON_CROWBAR`] = 'Crowbar',
        [`WEAPON_GOLFCLUB`] = 'Golf Club',
        [`WEAPON_BOTTLE`] = 'Bottle',
        [`WEAPON_DAGGER`] = 'Dagger',
        [`WEAPON_HATCHET`] = 'Hatchet',
        [`WEAPON_MACHETE`] = 'Machete',
        [`WEAPON_SWITCHBLADE`] = 'Switchblade',
        [`WEAPON_RUN_OVER_BY_CAR`] = 'Vehicle',
        [`WEAPON_RAMMED_BY_CAR`] = 'Vehicle',
        [`WEAPON_FALL`] = 'Fall Damage',
        [`WEAPON_EXPLOSION`] = 'Explosion',
        [`WEAPON_FIRE`] = 'Fire',
        [`WEAPON_DROWNING`] = 'Drowning',
    }
    
    return weapons[hash] or 'Unknown (' .. tostring(hash) .. ')'
end

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
