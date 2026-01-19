local AS = exports['as-core']:GetCoreObject()
local currentVehicle = nil

-- Track when player enters ambulance
CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 and vehicle ~= currentVehicle then
            currentVehicle = vehicle
            local model = GetEntityModel(vehicle)
            
            -- Check if it's an ambulance
            if GetVehicleClass(vehicle) == 18 then -- Emergency vehicles
                SetupAmbulanceVehicle(vehicle)
            end
        elseif vehicle == 0 then
            currentVehicle = nil
        end
    end
end)

-- Setup ambulance features
function SetupAmbulanceVehicle(vehicle)
    -- Add trunk stash interaction if using as-target
    exports['as-target']:AddLocalEntity(vehicle, {
        {
            name = 'ambulance_trunk',
            icon = 'fas fa-briefcase-medical',
            label = 'Open Medical Trunk',
            bones = {'boot'},
            canInteract = function(entity)
                return GetVehicleDoorAngleRatio(entity, 5) > 0.0
            end,
            onSelect = function(data)
                OpenAmbulanceTrunk(data.entity)
            end,
        }
    })
end

-- Open ambulance trunk
function OpenAmbulanceTrunk(vehicle)
    local player = AS.Client.GetPlayerData()
    
    if player.job and player.job.name == Config.JobName then
        -- ox_inventory trunk integration
        local plate = GetVehicleNumberPlateText(vehicle)
        exports.ox_inventory:openInventory('trunk', plate)
    else
        exports['as-core']:ShowNotification({
            title = 'Access Denied',
            description = 'You must be EMS to access this',
            type = 'error'
        })
    end
end

-- Exports
exports('GetCurrentVehicle', function()
    return currentVehicle
end)
