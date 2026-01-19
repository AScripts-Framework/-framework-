local AS = exports['as-core']:GetCoreObject()

-- Create hospital blips
CreateThread(function()
    for _, hospital in ipairs(Config.Hospitals) do
        if hospital.blip then
            local blip = AddBlipForCoord(hospital.coords.x, hospital.coords.y, hospital.coords.z)
            SetBlipSprite(blip, hospital.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, hospital.blip.scale)
            SetBlipColour(blip, hospital.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(hospital.blip.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

-- Setup hospital interactions
CreateThread(function()
    Wait(1000) -- Wait for as-target to load
    
    for i, hospital in ipairs(Config.Hospitals) do
        -- Check-in point (for civilians when no EMS)
        exports['as-target']:AddBoxZone('hospital_checkin_' .. i, hospital.checkIn, 1.5, 1.5, {
            name = 'hospital_checkin_' .. i,
            heading = hospital.heading,
            debugPoly = false,
            minZ = hospital.checkIn.z - 1.0,
            maxZ = hospital.checkIn.z + 1.0,
        }, {
            options = {
                {
                    name = 'hospital_heal',
                    icon = 'fas fa-heart',
                    label = 'Get Treatment ($' .. Config.HealPrice .. ')',
                    onSelect = function()
                        CheckInHospital()
                    end,
                }
            },
            distance = 2.0
        })
        
        -- Duty toggle (for EMS)
        exports['as-target']:AddBoxZone('hospital_duty_' .. i, hospital.duty, 1.5, 1.5, {
            name = 'hospital_duty_' .. i,
            heading = hospital.heading,
            debugPoly = false,
            minZ = hospital.duty.z - 1.0,
            maxZ = hospital.duty.z + 1.0,
        }, {
            options = {
                {
                    name = 'ems_duty',
                    icon = 'fas fa-briefcase-medical',
                    label = 'Toggle Duty',
                    canInteract = function()
                        local player = AS.Client.GetPlayerData()
                        return player.job and player.job.name == Config.JobName
                    end,
                    onSelect = function()
                        local job = require('client.job')
                        job.ToggleDuty()
                    end,
                }
            },
            distance = 2.0
        })
        
        -- Garage (for EMS)
        exports['as-target']:AddBoxZone('hospital_garage_' .. i, hospital.garage, 3.0, 3.0, {
            name = 'hospital_garage_' .. i,
            heading = hospital.garageHeading,
            debugPoly = false,
            minZ = hospital.garage.z - 1.0,
            maxZ = hospital.garage.z + 1.0,
        }, {
            options = {
                {
                    name = 'ems_garage',
                    icon = 'fas fa-ambulance',
                    label = 'Vehicle Garage',
                    canInteract = function()
                        local player = AS.Client.GetPlayerData()
                        return player.job and player.job.name == Config.JobName
                    end,
                    onSelect = function()
                        OpenGarage(hospital)
                    end,
                },
                {
                    name = 'ems_store_vehicle',
                    icon = 'fas fa-parking',
                    label = 'Store Vehicle',
                    canInteract = function()
                        local player = AS.Client.GetPlayerData()
                        return player.job and player.job.name == Config.JobName and IsPedInAnyVehicle(PlayerPedId(), false)
                    end,
                    onSelect = function()
                        StoreVehicle()
                    end,
                }
            },
            distance = 5.0
        })
        
        -- Medical supplies stash (for EMS)
        exports['as-target']:AddBoxZone('hospital_stash_' .. i, hospital.stash, 1.5, 1.5, {
            name = 'hospital_stash_' .. i,
            heading = hospital.heading,
            debugPoly = false,
            minZ = hospital.stash.z - 1.0,
            maxZ = hospital.stash.z + 1.0,
        }, {
            options = {
                {
                    name = 'ems_stash',
                    icon = 'fas fa-medkit',
                    label = 'Medical Supplies',
                    canInteract = function()
                        local player = AS.Client.GetPlayerData()
                        return player.job and player.job.name == Config.JobName
                    end,
                    onSelect = function()
                        OpenMedicalStash()
                    end,
                }
            },
            distance = 2.0
        })
    end
end)

-- Check in at hospital (civilians)
function CheckInHospital()
    local player = AS.Client.GetPlayerData()
    
    -- Check if player has money
    if player.money.bank < Config.HealPrice then
        exports['as-core']:ShowNotification({
            title = 'Insufficient Funds',
            description = 'You need $' .. Config.HealPrice .. ' for treatment',
            type = 'error'
        })
        return
    end
    
    if exports['as-core']:ShowProgressCircle({
        duration = 5000,
        position = 'bottom',
        label = 'Receiving treatment...',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
            combat = true,
        },
    }) then
        TriggerServerEvent('as-ambulance:server:checkIn')
    end
end

-- Open vehicle garage
function OpenGarage(hospital)
    local options = {}
    
    for _, vehicle in ipairs(Config.Vehicles) do
        table.insert(options, {
            title = vehicle.label,
            description = vehicle.price > 0 and 'Price: $' .. vehicle.price or 'Free',
            icon = 'ambulance',
            onSelect = function()
                SpawnVehicle(vehicle.model, hospital.garage, hospital.garageHeading)
            end
        })
    end
    
    exports['as-core']:ShowContext({
        id = 'ems_garage',
        title = 'EMS Vehicle Garage',
        options = options
    })
end

-- Spawn vehicle
function SpawnVehicle(model, coords, heading)
    local hash = GetHashKey(model)
    
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end
    
    local vehicle = CreateVehicle(hash, coords.x, coords.y, coords.z, heading, true, false)
    SetVehicleNumberPlateText(vehicle, 'EMS' .. math.random(1000, 9999))
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleFuelLevel(vehicle, 100.0)
    
    -- Set vehicle as owned
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    -- Set vehicle as owned
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    
    exports['as-core']:ShowNotification({
        title = 'Vehicle Spawned',
        description = 'Your EMS vehicle is ready',
        type = 'success'
    })
-- Store vehicle
function StoreVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        exports['as-core']:ShowNotification({
            title = 'Error',
            description = 'You must be in a vehicle',
            type = 'error'
        })
        return
    end
    
    DeleteVehicle(vehicle)
    
    exports['as-core']:ShowNotification({
        title = 'Vehicle Stored',
        description = 'Your vehicle has been stored',
        type = 'success'
    })
end

-- Open medical stash
function OpenMedicalStash()
    -- ox_inventory integration
    exports.ox_inventory:openInventory('stash', 'ems_medical_supplies')
end

-- Server event to check in
RegisterNetEvent('as-ambulance:client:checkInComplete', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(ped)
    
    lib.notify({
        title = 'Treatment Complete',
        description = 'You have been treated and are feeling better',
        type = 'success'
    })
end)
-- Server event to check in
RegisterNetEvent('as-ambulance:client:checkInComplete', function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, 200)
    ClearPedBloodDamage(ped)
    
    exports['as-core']:ShowNotification({
        title = 'Treatment Complete',
        description = 'You have been treated and are feeling better',
        type = 'success'
    })
end)