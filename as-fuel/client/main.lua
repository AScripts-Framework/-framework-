AS = exports['as-core']:GetCoreObject()

local currentVehicle = nil
local currentFuel = 100.0
local isRefueling = false
local isElectric = false

-- Check if vehicle is electric
local function IsElectricVehicle(vehicle)
    local model = GetEntityModel(vehicle)
    return Config.Fuel.ElectricVehicles[model] == true
end

-- Get fuel/battery level for vehicle
local function GetVehicleFuel(vehicle)
    if not DoesEntityExist(vehicle) then return 100.0 end
    return Entity(vehicle).state.fuel or 100.0
end

-- Set fuel/battery level for vehicle
local function SetVehicleFuel(vehicle, fuel)
    if not DoesEntityExist(vehicle) then return end
    fuel = math.max(0.0, math.min(100.0, fuel))
    Entity(vehicle).state:set('fuel', fuel, true)
    return fuel
end

-- Calculate fuel consumption
local function GetFuelConsumption(vehicle)
    if not DoesEntityExist(vehicle) then return 0.0 end
    
    local vehClass = GetVehicleClass(vehicle)
    local classMultiplier = Config.Fuel.ClassMultipliers[vehClass] or 1.0
    
    -- No consumption for cycles and trains
    if classMultiplier == 0.0 then return 0.0 end
    
    -- Check if vehicle is moving
    local speed = GetEntitySpeed(vehicle)
    local rpm = GetVehicleCurrentRpm(vehicle)
    
    -- Base consumption
    local consumption = Config.Fuel.IdleConsumption
    
    if speed > 0.1 then
        -- Calculate consumption based on RPM and speed
        local rpmConsumption = rpm * 0.5
        local speedConsumption = (speed / 50.0) * 0.3
        consumption = rpmConsumption + speedConsumption
        
        -- Cap maximum consumption
        consumption = math.min(consumption, Config.Fuel.MaxConsumption)
    end
    
    -- Apply class multiplier
    consumption = consumption * classMultiplier
    
    -- Apply global consumption rate
    local rate = isElectric and Config.Fuel.BatteryConsumptionRate or Config.Fuel.ConsumptionRate
    consumption = consumption * rate
    
    return consumption
end

-- Main fuel consumption thread
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if vehicle ~= currentVehicle then
                currentVehicle = vehicle
                currentFuel = GetVehicleFuel(vehicle)
                isElectric = IsElectricVehicle(vehicle)
            end
            
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                -- Driver seat, consume fuel
                if not isRefueling then
                    local consumption = GetFuelConsumption(vehicle)
                    
                    if consumption > 0 then
                        currentFuel = currentFuel - consumption
                        currentFuel = math.max(0.0, currentFuel)
                        SetVehicleFuel(vehicle, currentFuel)
                        
                        -- Disable engine if out of fuel
                        if currentFuel <= 0.0 then
                            SetVehicleEngineOn(vehicle, false, true, true)
                            
                            if Config.Fuel.ShowHUD then
                                AS.Client.Notify(isElectric and 'Battery depleted!' or 'Out of fuel!', 'error')
                            end
                        elseif currentFuel <= 10.0 then
                            -- Low fuel warning (only once per session)
                            if not Entity(vehicle).state.lowFuelWarned then
                                AS.Client.Notify(isElectric and 'Low battery!' or 'Low fuel!', 'warning')
                                Entity(vehicle).state:set('lowFuelWarned', true, false)
                            end
                        end
                    end
                end
                
                sleep = 1000
            end
        else
            currentVehicle = nil
            currentFuel = 100.0
            isElectric = false
            sleep = 2000
        end
        
        Wait(sleep)
    end
end)

-- Refuel/Recharge function
function RefuelVehicle(vehicle, isCharging)
    if isRefueling then return end
    
    isRefueling = true
    isCharging = isCharging or false
    
    local refuelRate = isCharging and Config.Fuel.ChargingRate or Config.Fuel.RefuelRate
    local price = isCharging and Config.Fuel.ChargingPrice or Config.Fuel.RefuelPrice
    local currentFuelLevel = GetVehicleFuel(vehicle)
    
    -- Show progress
    local pumpType = isCharging and 'Charging' or 'Refueling'
    
    CreateThread(function()
        while isRefueling and currentFuelLevel < 100.0 do
            Wait(1000)
            
            -- Add fuel
            currentFuelLevel = currentFuelLevel + refuelRate
            currentFuelLevel = math.min(100.0, currentFuelLevel)
            SetVehicleFuel(vehicle, currentFuelLevel)
            currentFuel = currentFuelLevel
            
            -- Charge player
            local cost = refuelRate * price
            TriggerServerEvent('as-fuel:server:PayForFuel', cost, isCharging)
            
            -- Update HUD or progress
            if Config.Fuel.ShowHUD then
                local fuelType = isCharging and 'battery' or 'fuel'
                DrawText3D(GetEntityCoords(vehicle), string.format('%s: %.1f%%', pumpType, currentFuelLevel))
            end
        end
        
        isRefueling = false
        AS.Client.Notify(isCharging and 'Charging complete!' or 'Refueling complete!', 'success')
    end)
end

-- Stop refueling
function StopRefueling()
    isRefueling = false
end

-- Exports
exports('RefuelVehicle', RefuelVehicle)
exports('StopRefueling', StopRefueling)
exports('GetVehicleFuel', GetVehicleFuel)
exports('SetVehicleFuel', SetVehicleFuel)
exports('IsElectricVehicle', IsElectricVehicle)

-- Draw 3D text helper
function DrawText3D(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z + 1.0)
    
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
        
        local factor = (string.len(text)) / 370
        DrawRect(x, y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
    end
end

print('^2[AS-FUEL]^7 Client initialized')
