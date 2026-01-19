local mdtOpen = false

-- Open MDT
RegisterNetEvent('as-police:client:openMDT', function()
    if not exports['as-police']:IsOnDuty() then
        exports['as-core']:ShowNotification('You must be on duty', 'error')
        return
    end
    
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openMDT'
    })
    mdtOpen = true
end)

-- Close MDT
RegisterNUICallback('closeMDT', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'closeMDT'
    })
    mdtOpen = false
    cb('ok')
end)

-- Get warrants
RegisterNUICallback('getWarrants', function(data, cb)
    -- Request from server
    TriggerServerEvent('as-police:server:getWarrants')
    cb('ok')
end)

-- Load warrants
RegisterNetEvent('as-police:client:loadWarrants', function(warrants)
    SendNUIMessage({
        action = 'loadWarrants',
        warrants = warrants
    })
end)

-- Create warrant
RegisterNUICallback('createWarrant', function(data, cb)
    TriggerServerEvent('as-police:server:createWarrant', data.identifier, data.reason, data.expires)
    cb('ok')
end)

-- Dispatch alert
RegisterNetEvent('as-police:client:dispatchAlert', function(alert)
    -- Show notification
    exports['as-core']:ShowNotification('[' .. alert.code .. '] ' .. alert.message, 'error', 5000)
    
    -- Create blip
    local blip = AddBlipForCoord(alert.coords.x, alert.coords.y, alert.coords.z)
    SetBlipSprite(blip, alert.sprite)
    SetBlipColour(blip, alert.color)
    SetBlipScale(blip, 1.0)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, alert.color)
    
    -- Create radius
    local radiusBlip = AddBlipForRadius(alert.coords.x, alert.coords.y, alert.coords.z, 100.0)
    SetBlipColour(radiusBlip, alert.color)
    SetBlipAlpha(radiusBlip, 100)
    
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(alert.label)
    EndTextCommandSetBlipName(blip)
    
    -- Remove after time
    SetTimeout(alert.blipTime * 1000, function()
        RemoveBlip(blip)
        RemoveBlip(radiusBlip)
    end)
    
    -- Send to NUI for MDT
    if mdtOpen then
        SendNUIMessage({
            action = 'newDispatch',
            alert = alert
        })
    end
end)
