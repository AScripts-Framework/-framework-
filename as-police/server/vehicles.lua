local spawnedVehicles = {}

-- Get available vehicles for player
RegisterNetEvent('as-police:server:getVehicles', function()
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    local grade = Player.job.grade_name or 'recruit'
    local vehicles = Config.Vehicles[grade] or Config.Vehicles['recruit']
    
    TriggerClientEvent('as-police:client:openGarage', src, vehicles)
end)

-- Spawn vehicle
RegisterNetEvent('as-police:server:spawnVehicle', function(vehicleData, coords, heading)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    -- Create vehicle
    local netId = exports['as-core']:CreateVehicle(vehicleData.model, coords, heading, function(vehicle)
        if vehicle then
            -- Apply livery and extras
            if vehicleData.livery then
                SetVehicleLivery(vehicle, vehicleData.livery)
            end
            
            if vehicleData.extras then
                for extra, enabled in pairs(vehicleData.extras) do
                    SetVehicleExtra(vehicle, extra, enabled and 0 or 1)
                end
            end
            
            -- Set as police vehicle
            SetVehicleEngineOn(vehicle, false, false, true)
            SetVehicleNumberPlateText(vehicle, 'LSPD' .. math.random(1000, 9999))
            
            -- Track spawned vehicle
            spawnedVehicles[netId] = {
                owner = src,
                model = vehicleData.model,
                plate = GetVehicleNumberPlateText(vehicle)
            }
        end
    end)
    
    TriggerClientEvent('as-core:Notify', src, 'Vehicle spawned', 'success')
end)

-- Delete vehicle
RegisterNetEvent('as-police:server:deleteVehicle', function(netId)
    local src = source
    
    if spawnedVehicles[netId] then
        if spawnedVehicles[netId].owner == src then
            local vehicle = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
                spawnedVehicles[netId] = nil
                TriggerClientEvent('as-core:Notify', src, 'Vehicle stored', 'success')
            end
        else
            TriggerClientEvent('as-core:Notify', src, 'This is not your vehicle', 'error')
        end
    end
end)

-- Cleanup on disconnect
AddEventHandler('playerDropped', function()
    local src = source
    
    for netId, data in pairs(spawnedVehicles) do
        if data.owner == src then
            local vehicle = NetworkGetEntityFromNetworkId(netId)
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
            spawnedVehicles[netId] = nil
        end
    end
end)
