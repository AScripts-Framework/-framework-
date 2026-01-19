local AS = exports['as-core']:GetCoreObject()
local adminLevel = 0
local menuOpen = false
local noclip = false
local god = false
local invisible = false
local spectating = false
local oldCoords = nil

-- Get admin level on resource start
CreateThread(function()
    TriggerServerEvent('as-admin:checkPermission')
end)

RegisterNetEvent('as-admin:setAdminLevel')
AddEventHandler('as-admin:setAdminLevel', function(level)
    adminLevel = level
end)

-- Open admin menu
local function OpenAdminMenu()
    if adminLevel == 0 then return end
    
    menuOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openMenu',
        adminLevel = adminLevel
    })
    
    -- Request player list
    TriggerServerEvent('as-admin:getPlayers')
end

-- Close admin menu
local function CloseAdminMenu()
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeMenu'
    })
end

-- Menu key
CreateThread(function()
    local menuKey = GetConvar('as_admin_menu_key', 'F10')
    
    while true do
        Wait(0)
        
        if IsControlJustReleased(0, GetControlFromKey(menuKey)) then
            if menuOpen then
                CloseAdminMenu()
            else
                OpenAdminMenu()
            end
        end
    end
end)

-- Receive player list
RegisterNetEvent('as-admin:receivePlayerList')
AddEventHandler('as-admin:receivePlayerList', function(players)
    SendNUIMessage({
        action = 'updatePlayers',
        players = players
    })
end)

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    CloseAdminMenu()
    cb('ok')
end)

RegisterNUICallback('kickPlayer', function(data, cb)
    TriggerServerEvent('as-admin:kickPlayer', data.id, data.reason)
    cb('ok')
end)

RegisterNUICallback('banPlayer', function(data, cb)
    TriggerServerEvent('as-admin:banPlayer', data.id, data.reason, data.duration)
    cb('ok')
end)

RegisterNUICallback('warnPlayer', function(data, cb)
    TriggerServerEvent('as-admin:warnPlayer', data.id, data.message)
    cb('ok')
end)

RegisterNUICallback('freezePlayer', function(data, cb)
    TriggerServerEvent('as-admin:freezePlayer', data.id, data.freeze)
    cb('ok')
end)

RegisterNUICallback('teleportToPlayer', function(data, cb)
    TriggerServerEvent('as-admin:teleportToPlayer', data.id)
    cb('ok')
end)

RegisterNUICallback('bringPlayer', function(data, cb)
    TriggerServerEvent('as-admin:bringPlayer', data.id)
    cb('ok')
end)

RegisterNUICallback('teleportToLocation', function(data, cb)
    TriggerServerEvent('as-admin:teleportToCoords', data.coords)
    cb('ok')
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
    TriggerServerEvent('as-admin:spawnVehicle', data.model)
    cb('ok')
end)

RegisterNUICallback('deleteVehicle', function(data, cb)
    TriggerServerEvent('as-admin:deleteVehicle')
    cb('ok')
end)

RegisterNUICallback('repairVehicle', function(data, cb)
    TriggerServerEvent('as-admin:repairVehicle')
    cb('ok')
end)

RegisterNUICallback('giveMoney', function(data, cb)
    TriggerServerEvent('as-admin:giveMoney', data.id, data.account, data.amount)
    cb('ok')
end)

RegisterNUICallback('removeMoney', function(data, cb)
    TriggerServerEvent('as-admin:removeMoney', data.id, data.account, data.amount)
    cb('ok')
end)

RegisterNUICallback('setJob', function(data, cb)
    TriggerServerEvent('as-admin:setJob', data.id, data.job, data.grade)
    cb('ok')
end)

RegisterNUICallback('setWeather', function(data, cb)
    TriggerServerEvent('as-admin:setWeather', data.weather)
    cb('ok')
end)

RegisterNUICallback('setTime', function(data, cb)
    TriggerServerEvent('as-admin:setTime', data.hour, data.minute)
    cb('ok')
end)

RegisterNUICallback('announcement', function(data, cb)
    TriggerServerEvent('as-admin:announcement', data.message)
    cb('ok')
end)

RegisterNUICallback('revivePlayer', function(data, cb)
    TriggerServerEvent('as-admin:revivePlayer', data.id)
    cb('ok')
end)

RegisterNUICallback('healPlayer', function(data, cb)
    TriggerServerEvent('as-admin:healPlayer', data.id)
    cb('ok')
end)

RegisterNUICallback('spectatePlayer', function(data, cb)
    SpectatePlayer(data.id)
    cb('ok')
end)

RegisterNUICallback('toggleNoclip', function(data, cb)
    ToggleNoclip()
    cb('ok')
end)

RegisterNUICallback('toggleGod', function(data, cb)
    ToggleGod()
    cb('ok')
end)

RegisterNUICallback('toggleInvisible', function(data, cb)
    ToggleInvisible()
    cb('ok')
end)

RegisterNUICallback('refreshPlayers', function(data, cb)
    TriggerServerEvent('as-admin:getPlayers')
    cb('ok')
end)

-- Helper function to get control from key
function GetControlFromKey(key)
    local keys = {
        ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F4'] = 166,
        ['F5'] = 167, ['F6'] = 168, ['F7'] = 56, ['F8'] = 57,
        ['F9'] = 344, ['F10'] = 57
    }
    return keys[key] or 57
end

print('^2[AS-Admin]^7 Client main loaded')
