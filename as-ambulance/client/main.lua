local AS = exports['as-core']:GetCoreObject()
local menuOpen = false

-- Key mapping for menu
RegisterCommand('ems_menu', function()
    local player = AS.Client.GetPlayerData()
    if player and player.job and player.job.name == Config.JobName then
        ToggleMenu()
    end
end, false)

RegisterKeyMapping('ems_menu', 'Open EMS Menu', 'keyboard', Config.MenuKey)

-- Toggle menu
function ToggleMenu()
    menuOpen = not menuOpen
    
    if menuOpen then
        OpenMenu()
    else
        CloseMenu()
    end
end

-- Open menu
function OpenMenu()
    local player = AS.Client.GetPlayerData()
    local job = require('client.job')
    
    SendNUIMessage({
        action = 'openMenu',
        dutyStatus = job.IsOnDuty(),
        emsCount = 1, -- Would get from server
        callCount = 0, -- Would get from server
    })
    
    SetNuiFocus(true, true)
    menuOpen = true
end

-- Close menu
function CloseMenu()
    SendNUIMessage({
        action = 'closeMenu'
    })
    
    SetNuiFocus(false, false)
    menuOpen = false
end

-- NUI Callbacks
RegisterNUICallback('closeMenu', function(data, cb)
    CloseMenu()
    cb('ok')
end)

RegisterNUICallback('menuAction', function(data, cb)
    local action = data.action
    local job = require('client.job')
    
    if action == 'revive' then
        job.ReviveNearbyPlayer()
    elseif action == 'heal' then
        job.HealNearbyPlayer()
    elseif action == 'vitals' then
        job.CheckVitals()
    elseif action == 'escort' then
        -- Toggle escort
        TriggerEvent('as-ambulance:client:escort')
    elseif action == 'stretcher' then
        -- Place on stretcher
        exports['as-core']:ShowNotification({
            title = 'Stretcher',
            description = 'Feature coming soon',
            type = 'info'
        })
    elseif action == 'diagnose' then
        -- Diagnose injuries
        exports['as-core']:ShowNotification({
            title = 'Diagnose',
            description = 'Feature coming soon',
            type = 'info'
        })
    elseif action == 'announce' then
        -- EMS announcement
        local input = exports['as-core']:ShowInput('EMS Announcement', {
            {type = 'textarea', label = 'Message', required = true}
        })
        
        if input then
            TriggerServerEvent('as-ambulance:server:announcement', input[1])
        end
    elseif action == 'callsign' then
        -- Set callsign
        local input = exports['as-core']:ShowInput('Set Callsign', {
            {type = 'input', label = 'Callsign', placeholder = 'e.g., EMS-1', required = true}
        })
        
        if input then
            exports['as-core']:ShowNotification({
                title = 'Callsign Set',
                description = 'Your callsign is now: ' .. input[1],
                type = 'success'
            })
        end
    end
    
    cb('ok')
end)

-- Exports
exports('OpenMenu', function()
    if not menuOpen then
        OpenMenu()
    end
end)

exports('CloseMenu', function()
    if menuOpen then
        CloseMenu()
    end
end)
