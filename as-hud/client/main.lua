local AS = exports['as-core']:GetCoreObject()
local hudSettings = {}
local settingsMenuOpen = false

-- Load settings from client storage
function LoadSettings()
    local saved = GetResourceKvpString('as_hud_settings')
    
    if saved then
        hudSettings = json.decode(saved)
    else
        -- Use defaults from config
        hudSettings = {
            position = Config.HUD.Defaults.position,
            scale = Config.HUD.Defaults.scale,
            offsetX = Config.HUD.Defaults.offsetX,
            offsetY = Config.HUD.Defaults.offsetY,
            iconStyle = Config.HUD.Defaults.iconStyle,
            colorTheme = Config.HUD.Defaults.colorTheme,
            vehiclePosition = Config.HUD.Defaults.vehiclePosition,
            vehicleScale = Config.HUD.Defaults.vehicleScale,
            vehicleOffsetX = Config.HUD.Defaults.vehicleOffsetX,
            vehicleOffsetY = Config.HUD.Defaults.vehicleOffsetY
        }
    end
    
    SendNUIMessage({
        action = 'loadSettings',
        settings = hudSettings
    })
end

-- Save settings to client storage
RegisterNUICallback('saveSettings', function(data, cb)
    hudSettings = data
    SetResourceKvp('as_hud_settings', json.encode(hudSettings))
    cb('ok')
end)

-- Close settings callback
RegisterNUICallback('closeSettings', function(data, cb)
    settingsMenuOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Initialize HUD
CreateThread(function()
    -- Wait for as-core
    while GetResourceState('as-core') ~= 'started' do
        Wait(100)
    end
    
    -- Wait for player to be loaded
    while not AS.Client.IsPlayerLoaded() do
        Wait(100)
    end
    
    -- Load settings
    LoadSettings()
    
    -- Show HUD
    SendNUIMessage({
        action = 'show'
    })
    
    print('^2[AS-HUD]^7 HUD initialized')
end)

-- Update HUD data
CreateThread(function()
    while true do
        Wait(Config.HUD.UpdateInterval)
        
        if AS.Client.IsPlayerLoaded() then
            local ped = PlayerPedId()
            
            -- Get health (0-100)
            local health = GetEntityHealth(ped) - 100
            local maxHealth = GetEntityMaxHealth(ped) - 100
            local healthPercent = (health / maxHealth) * 100
            
            -- Get armor (0-100)
            local armor = GetPedArmour(ped)
            
            -- Get stamina (0-100)
            local stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
            
            -- Send to NUI
            SendNUIMessage({
                action = 'update',
                health = math.max(0, math.min(100, healthPercent)),
                armor = armor,
                stamina = math.max(0, math.min(100, stamina))
            })
        end
    end
end)

-- Update vehicle HUD data
CreateThread(function()
    while true do
        Wait(100) -- Update faster for smoother speedometer
        
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == ped then
            -- Get speed
            local speed = GetEntitySpeed(vehicle) * 2.236936 -- Convert to MPH
            local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle) * 2.236936
            local speedPercent = (speed / maxSpeed) * 100
            
            -- Get RPM
            local rpm = GetVehicleCurrentRpm(vehicle) * 10000
            
            -- Get current gear
            local gear = GetVehicleCurrentGear(vehicle)
            local gearDisplay = 'N'
            if gear == 0 then
                gearDisplay = 'R'
            elseif gear > 0 then
                gearDisplay = tostring(gear)
            end
            
            -- Get fuel using as-fuel export
            local fuel = 100.0
            if GetResourceState('as-fuel') == 'started' then
                fuel = exports['as-fuel']:GetVehicleFuel(vehicle)
            end
            
            -- Check if electric vehicle
            local isElectric = false
            if GetResourceState('as-fuel') == 'started' then
                isElectric = exports['as-fuel']:IsElectricVehicle(vehicle)
            end
            
            -- Send to NUI
            SendNUIMessage({
                action = 'updateVehicle',
                speed = math.floor(speed),
                speedPercent = math.max(0, math.min(100, speedPercent)),
                rpm = math.floor(rpm),
                gear = gearDisplay,
                fuel = fuel,
                isElectric = isElectric,
                inVehicle = true
            })
        else
            -- Hide vehicle HUD
            SendNUIMessage({
                action = 'updateVehicle',
                inVehicle = false
            })
        end
    end
end)

-- Settings menu toggle
RegisterCommand('hudsettings', function()
    if not settingsMenuOpen then
        settingsMenuOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = 'showSettings',
            settings = hudSettings
        })
    else
        settingsMenuOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = 'hideSettings'
        })
    end
end, false)

-- Register keybind
RegisterKeyMapping('hudsettings', 'Open HUD Settings', 'keyboard', Config.HUD.SettingsKey)

-- Hide HUD when player dies
CreateThread(function()
    while true do
        Wait(1000)
        
        if IsPlayerDead(PlayerId()) then
            SendNUIMessage({
                action = 'hide'
            })
            
            -- Wait until respawn
            while IsPlayerDead(PlayerId()) do
                Wait(500)
            end
            
            SendNUIMessage({
                action = 'show'
            })
        end
    end
end)

-- Hide default HUD elements
CreateThread(function()
    while true do
        Wait(0)
        
        -- Hide default health/armor
        HideHudComponentThisFrame(3)  -- SP Health
        HideHudComponentThisFrame(4)  -- SP Armour
        HideHudComponentThisFrame(7)  -- Area Name
        HideHudComponentThisFrame(9)  -- Street Name
    end
end)

print('^2[AS-HUD]^7 Client main loaded')
