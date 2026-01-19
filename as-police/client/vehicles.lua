-- Create vehicle garages
CreateThread(function()
    for stationId, station in pairs(Config.Stations) do
        -- Ground vehicles
        exports['as-target']:AddBoxZone('police_garage_' .. stationId, station.garage.vehicle.xyz, 3.0, 3.0, {
            name = 'police_garage_' .. stationId,
            heading = station.garage.vehicle.w,
            debugPoly = false,
            minZ = station.garage.vehicle.z - 1.0,
            maxZ = station.garage.vehicle.z + 1.0
        }, {
            options = {
                {
                    type = 'client',
                    event = 'as-police:client:openGarageMenu',
                    icon = 'fas fa-car',
                    label = 'Vehicle Garage',
                    canInteract = function()
                        return exports['as-police']:IsOnDuty()
                    end
                },
                {
                    type = 'client',
                    event = 'as-police:client:storeVehicle',
                    icon = 'fas fa-warehouse',
                    label = 'Store Vehicle',
                    canInteract = function()
                        return IsPedInAnyVehicle(PlayerPedId(), false)
                    end
                }
            },
            distance = 3.0
        })
        
        -- Helicopters
        exports['as-target']:AddBoxZone('police_heli_' .. stationId, station.garage.heli.xyz, 5.0, 5.0, {
            name = 'police_heli_' .. stationId,
            heading = station.garage.heli.w,
            debugPoly = false,
            minZ = station.garage.heli.z - 1.0,
            maxZ = station.garage.heli.z + 1.0
        }, {
            options = {
                {
                    type = 'client',
                    event = 'as-police:client:openHeliMenu',
                    icon = 'fas fa-helicopter',
                    label = 'Helicopter Garage',
                    canInteract = function()
                        return exports['as-police']:IsOnDuty()
                    end
                }
            },
            distance = 5.0
        })
    end
end)

-- Open garage menu
RegisterNetEvent('as-police:client:openGarageMenu', function()
    TriggerServerEvent('as-police:server:getVehicles')
end)

-- Display garage
RegisterNetEvent('as-police:client:openGarage', function(vehicles)
    local menuItems = {
        {header = 'Police Garage', isMenuHeader = true},
    }
    
    for _, vehicle in ipairs(vehicles) do
        table.insert(menuItems, {
            header = vehicle.label,
            txt = 'Spawn ' .. vehicle.label,
            params = {
                event = 'as-police:client:spawnVehicle',
                args = vehicle
            }
        })
    end
    
    exports['as-core']:ShowContext(menuItems)
end)

-- Spawn vehicle
RegisterNetEvent('as-police:client:spawnVehicle', function(vehicleData)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    -- Find nearest garage spawn point
    local nearestSpawn = nil
    local nearestDist = 999999
    
    for _, station in pairs(Config.Stations) do
        local dist = #(coords - station.garage.vehicle.xyz)
        if dist < nearestDist then
            nearestDist = dist
            nearestSpawn = station.garage.vehicle
        end
    end
    
    if nearestSpawn then
        exports['as-core']:ShowProgressCircle({
            duration = 3000,
            label = 'Spawning vehicle...',
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true
            }
        }, function(cancelled)
            if not cancelled then
                TriggerServerEvent('as-police:server:spawnVehicle', vehicleData, nearestSpawn.xyz, nearestSpawn.w)
            end
        end)
    end
end)

-- Store vehicle
RegisterNetEvent('as-police:client:storeVehicle', function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle and vehicle ~= 0 then
        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerServerEvent('as-police:server:deleteVehicle', netId)
    end
end)

-- Open heli menu
RegisterNetEvent('as-police:client:openHeliMenu', function()
    exports['as-core']:ShowNotification('Helicopter garage coming soon', 'info')
end)
