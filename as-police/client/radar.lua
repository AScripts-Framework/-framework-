local radarActive = false
local frontSpeed = 0
local rearSpeed = 0

-- Toggle radar
RegisterCommand('radar', function()
    if not exports['as-police']:IsOnDuty() then
        exports['as-core']:ShowNotification('You must be on duty', 'error')
        return
    end
    
    radarActive = not radarActive
    
    if radarActive then
        exports['as-core']:ShowNotification('Radar activated', 'success')
        SendNUIMessage({
            action = 'toggleRadar',
            show = true
        })
    else
        exports['as-core']:ShowNotification('Radar deactivated', 'info')
        SendNUIMessage({
            action = 'toggleRadar',
            show = false
        })
    end
end, false)

-- Radar loop
CreateThread(function()
    while true do
        Wait(100)
        
        if radarActive then
            local ped = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if vehicle and vehicle ~= 0 then
                local coords = GetEntityCoords(vehicle)
                local heading = GetEntityHeading(vehicle)
                
                -- Front radar
                local frontCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, Config.Radar.maxDistance, 0.0)
                local frontVehicle = GetClosestVehicle(frontCoords.x, frontCoords.y, frontCoords.z, 10.0, 0, 70)
                
                if frontVehicle and frontVehicle ~= vehicle then
                    local speed = GetEntitySpeed(frontVehicle) * 2.23694 -- Convert to MPH
                    frontSpeed = math.floor(speed)
                    
                    -- Check if speeding
                    if speed > Config.Radar.speedLimit then
                        local plate = GetVehicleNumberPlateText(frontVehicle)
                        local vehCoords = GetEntityCoords(frontVehicle)
                        TriggerServerEvent('as-police:server:speedingVehicle', vehCoords, speed, plate)
                    end
                else
                    frontSpeed = 0
                end
                
                -- Rear radar
                local rearCoords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -Config.Radar.maxDistance, 0.0)
                local rearVehicle = GetClosestVehicle(rearCoords.x, rearCoords.y, rearCoords.z, 10.0, 0, 70)
                
                if rearVehicle and rearVehicle ~= vehicle then
                    local speed = GetEntitySpeed(rearVehicle) * 2.23694
                    rearSpeed = math.floor(speed)
                else
                    rearSpeed = 0
                end
                
                -- Update NUI
                SendNUIMessage({
                    action = 'updateRadar',
                    front = frontSpeed,
                    rear = rearSpeed,
                    speedLimit = Config.Radar.speedLimit
                })
            else
                radarActive = false
                SendNUIMessage({
                    action = 'toggleRadar',
                    show = false
                })
            end
        end
    end
end)
