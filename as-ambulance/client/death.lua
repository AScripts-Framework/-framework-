local AS = exports['as-core']:GetCoreObject()
local isDead = false
local inLastStand = false
local deathTimer = 0
local lastStandTimer = 0
local deathCoords = nil
local deathCause = nil

-- Death handler
AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' then
        local victim = data[1]
        local attacker = data[2]
        local weaponHash = data[7]
        
        if victim == PlayerPedId() and IsPedDeadOrDying(victim, true) then
            local playerHealth = GetEntityHealth(victim)
            
            if playerHealth <= 0 and not isDead then
                deathCoords = GetEntityCoords(victim)
                deathCause = weaponHash
                
                if Config.EnableLastStand and not inLastStand then
                    EnterLastStand()
                else
                    OnPlayerDeath()
                end
            end
        end
    end
end)

-- Enter last stand state
function EnterLastStand()
    inLastStand = true
    lastStandTimer = Config.LastStandTime
    
    exports['as-core']:ShowNotification({
        title = 'Critically Injured',
        description = 'You are in critical condition! EMS has been notified.',
        type = 'error',
        duration = 5000
    })
    
    -- Notify EMS
    TriggerServerEvent('as-ambulance:server:notifyEMS', deathCoords)
    
    -- Start last stand NUI
    SendNUIMessage({
        action = 'showLastStand',
        time = lastStandTimer
    })
    
    -- Play injured animation
    local ped = PlayerPedId()
    RequestAnimDict('combat@damage@writhe')
    while not HasAnimDictLoaded('combat@damage@writhe') do
        Wait(10)
    end
    TaskPlayAnim(ped, 'combat@damage@writhe', 'writhe_loop', 8.0, -8.0, -1, 1, 0, false, false, false)
    
    -- Start timer
    CreateThread(function()
        while inLastStand and lastStandTimer > 0 do
            Wait(1000)
            lastStandTimer = lastStandTimer - 1
            
            SendNUIMessage({
                action = 'updateLastStandTimer',
                time = lastStandTimer
            })
            
            -- Check if health restored
            if GetEntityHealth(PlayerPedId()) > 150 then
                ExitLastStand()
                return
            end
        end
        
        if inLastStand then
            OnPlayerDeath()
        end
    end)
end

-- Exit last stand (revived)
function ExitLastStand()
    inLastStand = false
    lastStandTimer = 0
    
    SendNUIMessage({
        action = 'hideLastStand'
    })
    
    ClearPedTasks(PlayerPedId())
end

-- Player death
function OnPlayerDeath()
    if isDead then return end
    
    isDead = true
    inLastStand = false
    deathTimer = Config.RespawnTime
    
    local ped = PlayerPedId()
    
    -- Death animation
    if Config.DeathAnimation.dict and Config.DeathAnimation.anim then
        RequestAnimDict(Config.DeathAnimation.dict)
        while not HasAnimDictLoaded(Config.DeathAnimation.dict) do
            Wait(10)
        end
        TaskPlayAnim(ped, Config.DeathAnimation.dict, Config.DeathAnimation.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    end
    
    -- Show death screen
    SendNUIMessage({
        action = 'showDeathScreen',
        time = deathTimer,
        canRespawn = false
    })
    
    -- Notify server
    TriggerServerEvent('as-ambulance:server:onPlayerDeath', deathCoords, deathCause)
    
    -- Disable controls
    CreateThread(function()
        while isDead do
            Wait(0)
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- Camera movement
            EnableControlAction(0, 2, true)
        end
    end)
    
    -- Start respawn timer
    CreateThread(function()
        while isDead and deathTimer > 0 do
            Wait(1000)
            deathTimer = deathTimer - 1
            
            SendNUIMessage({
                action = 'updateDeathTimer',
                time = deathTimer,
                canRespawn = deathTimer <= 0
            })
        end
    end)
end

-- Respawn player
function RespawnPlayer()
    if not isDead then return end
    
    isDead = false
    deathTimer = 0
    
    local ped = PlayerPedId()
    
    -- Find nearest hospital or use death coords
    local respawnCoords = deathCoords
    local respawnHeading = 0.0
    
    if Config.RespawnAtHospital then
        local nearestHospital = GetNearestHospital(deathCoords)
        if nearestHospital then
            respawnCoords = nearestHospital.coords
            respawnHeading = nearestHospital.heading
        end
    end
    
    -- Fade out
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(10)
    end
    
    -- Clear animations and effects
    ClearPedTasksImmediately(ped)
    
    -- Teleport to respawn location
    SetEntityCoords(ped, respawnCoords.x, respawnCoords.y, respawnCoords.z, false, false, false, false)
    SetEntityHeading(ped, respawnHeading)
    
    -- Restore health
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(ped)
    
    -- Revive
    NetworkResurrectLocalPlayer(respawnCoords.x, respawnCoords.y, respawnCoords.z, respawnHeading, true, false)
    
    -- Notify server
    TriggerServerEvent('as-ambulance:server:onPlayerRespawn')
    
    -- Hide death screen
    SendNUIMessage({
        action = 'hideDeathScreen'
    })
    
    -- Fade in
    DoScreenFadeIn(500)
    
    exports['as-core']:ShowNotification({
        title = 'Respawned',
        description = 'You have been discharged from the hospital.',
        type = 'success'
    })
end

-- Revive player (called by EMS or admin)
function RevivePlayer()
    if not isDead and not inLastStand then return end
    
    isDead = false
    inLastStand = false
    deathTimer = 0
    lastStandTimer = 0
    
    local ped = PlayerPedId()
    
    -- Clear animations
    ClearPedTasksImmediately(ped)
    
    -- Restore health
    SetEntityHealth(ped, Config.ReviveHealth)
    ClearPedBloodDamage(ped)
    
    -- Revive
    if IsPedDeadOrDying(ped, true) then
        local coords = GetEntityCoords(ped)
        local heading = GetEntityHeading(ped)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
    end
    
    -- Hide NUI
    SendNUIMessage({
        action = 'hideDeathScreen'
    })
    
    SendNUIMessage({
        action = 'hideLastStand'
    })
    
    exports['as-core']:ShowNotification({
        title = 'Revived',
        description = 'You have been revived!',
        type = 'success'
    })
end

-- Get nearest hospital
function GetNearestHospital(coords)
    local nearestHospital = nil
    local nearestDistance = 999999.0
    
    for _, hospital in ipairs(Config.Hospitals) do
        local distance = #(coords - hospital.coords)
        if distance < nearestDistance then
            nearestDistance = distance
            nearestHospital = hospital
        end
    end
    
    return nearestHospital
end

-- NUI Callbacks
RegisterNUICallback('respawn', function(data, cb)
    if deathTimer <= 0 then
        RespawnPlayer()
    end
    cb('ok')
end)

-- Server events
RegisterNetEvent('as-ambulance:client:revive', function()
    RevivePlayer()
end)

RegisterNetEvent('as-ambulance:client:heal', function(amount)
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped)
    SetEntityHealth(ped, math.min(health + amount, 200))
    ClearPedBloodDamage(ped)
    
    exports['as-core']:ShowNotification({
        title = 'Healed',
        description = 'You have been treated.',
        type = 'success'
    })
end)

-- Exports
exports('IsDead', function()
    return isDead
end)

exports('IsInLastStand', function()
    return inLastStand
end)

exports('Revive', function()
    RevivePlayer()
end)
