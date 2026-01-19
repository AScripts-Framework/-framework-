AS = exports['as-core']:GetCoreObject()

local stationBlips = {}
local nearestStation = nil

-- Create blips for stations
CreateThread(function()
    if not Config.Fuel.ShowBlips then return end
    
    -- Gas stations
    for _, station in ipairs(Config.Fuel.GasStations) do
        local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
        SetBlipSprite(blip, Config.Fuel.GasStationBlip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Fuel.GasStationBlip.scale)
        SetBlipColour(blip, Config.Fuel.GasStationBlip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Fuel.GasStationBlip.label)
        EndTextCommandSetBlipName(blip)
        table.insert(stationBlips, blip)
    end
    
    -- Charging stations
    for _, station in ipairs(Config.Fuel.ChargingStations) do
        local blip = AddBlipForCoord(station.coords.x, station.coords.y, station.coords.z)
        SetBlipSprite(blip, Config.Fuel.ChargingStationBlip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Fuel.ChargingStationBlip.scale)
        SetBlipColour(blip, Config.Fuel.ChargingStationBlip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Fuel.ChargingStationBlip.label)
        EndTextCommandSetBlipName(blip)
        table.insert(stationBlips, blip)
    end
end)

-- Check if player is near a station
local function GetNearestStation()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if not vehicle or vehicle == 0 then return nil end
    
    local isElectric = exports['as-fuel']:IsElectricVehicle(vehicle)
    local stations = isElectric and Config.Fuel.ChargingStations or Config.Fuel.GasStations
    
    for _, station in ipairs(stations) do
        local dist = #(coords - station.coords)
        if dist <= station.radius then
            return station, dist
        end
    end
    
    return nil
end

-- Station interaction thread
CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                local station, dist = GetNearestStation()
                
                if station then
                    nearestStation = station
                    sleep = 0
                    
                    local isElectric = exports['as-fuel']:IsElectricVehicle(vehicle)
                    local currentFuel = exports['as-fuel']:GetVehicleFuel(vehicle)
                    
                    -- Check if using target system or 3D text
                    if Config.UseTarget then
                        -- Target system handles this via exports in api
                    else
                        -- Draw 3D text
                        local coords = GetEntityCoords(vehicle)
                        local text = isElectric and 'Press [E] to Charge' or 'Press [E] to Refuel'
                        text = text .. string.format('\n%.1f%%', currentFuel)
                        
                        DrawText3D(coords, text)
                        
                        -- Check for key press
                        if IsControlJustPressed(0, 38) then -- E key
                            exports['as-fuel']:RefuelVehicle(vehicle, isElectric)
                        end
                        
                        -- Stop refueling if player exits vehicle or moves away
                        if IsControlJustPressed(0, 73) then -- X key
                            exports['as-fuel']:StopRefueling()
                        end
                    end
                else
                    nearestStation = nil
                end
            end
        else
            nearestStation = nil
            sleep = 2000
        end
        
        Wait(sleep)
    end
end)

-- If using target system, add targets
if Config.UseTarget then
    CreateThread(function()
        -- Wait for as-target to load
        while GetResourceState('as-target') ~= 'started' do
            Wait(100)
        end
        
        -- Add gas station zones
        for i, station in ipairs(Config.Fuel.GasStations) do
            exports['as-target']:AddCircleZone('gas_station_' .. i, station.coords, station.radius, {
                targets = {
                    {
                        icon = 'fa-solid fa-gas-pump',
                        label = 'Refuel Vehicle',
                        distance = station.radius,
                        canInteract = function()
                            local ped = PlayerPedId()
                            if not IsPedInAnyVehicle(ped, false) then return false end
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            if GetPedInVehicleSeat(vehicle, -1) ~= ped then return false end
                            if exports['as-fuel']:IsElectricVehicle(vehicle) then return false end
                            local fuel = exports['as-fuel']:GetVehicleFuel(vehicle)
                            return fuel < 100.0
                        end,
                        onSelect = function()
                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                            exports['as-fuel']:RefuelVehicle(vehicle, false)
                        end
                    }
                }
            })
        end
        
        -- Add charging station zones
        for i, station in ipairs(Config.Fuel.ChargingStations) do
            exports['as-target']:AddCircleZone('charging_station_' .. i, station.coords, station.radius, {
                targets = {
                    {
                        icon = 'fa-solid fa-charging-station',
                        label = 'Charge Vehicle',
                        distance = station.radius,
                        canInteract = function()
                            local ped = PlayerPedId()
                            if not IsPedInAnyVehicle(ped, false) then return false end
                            local vehicle = GetVehiclePedIsIn(ped, false)
                            if GetPedInVehicleSeat(vehicle, -1) ~= ped then return false end
                            if not exports['as-fuel']:IsElectricVehicle(vehicle) then return false end
                            local fuel = exports['as-fuel']:GetVehicleFuel(vehicle)
                            return fuel < 100.0
                        end,
                        onSelect = function()
                            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                            exports['as-fuel']:RefuelVehicle(vehicle, true)
                        end
                    }
                }
            })
        end
        
        print('^2[AS-FUEL]^7 Added target zones for fuel stations')
    end)
end

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
