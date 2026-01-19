local draggedPlayer = nil
local isDragging = false
local isHandcuffed = false

-- Open interaction menu
RegisterNetEvent('as-police:client:openInteractMenu', function()
    local player, distance = exports['as-core']:GetClosestPlayer()
    
    if not player or distance > 3.0 then
        exports['as-core']:ShowNotification('No player nearby', 'error')
        return
    end
    
    local menuItems = {
        {header = 'Player Interactions', isMenuHeader = true},
        {
            header = 'Handcuff / Uncuff',
            txt = 'Restrain the player',
            params = {
                event = 'as-police:client:cuffPlayer',
                args = {playerId = GetPlayerServerId(player)}
            }
        },
        {
            header = 'Drag',
            txt = 'Drag the player',
            params = {
                event = 'as-police:client:dragPlayer',
                args = {playerId = GetPlayerServerId(player)}
            }
        },
        {
            header = 'Put in Vehicle',
            txt = 'Place in nearest vehicle',
            params = {
                event = 'as-police:client:putInVehicle',
                args = {playerId = GetPlayerServerId(player)}
            }
        },
        {
            header = 'Remove from Vehicle',
            txt = 'Take out of vehicle',
            params = {
                event = 'as-police:client:removeFromVehicle',
                args = {playerId = GetPlayerServerId(player)}
            }
        },
        {
            header = 'Search',
            txt = 'Search player inventory',
            params = {
                event = 'as-police:client:searchPlayer',
                args = {playerId = GetPlayerServerId(player)}
            }
        },
        {
            header = 'Fine',
            txt = 'Issue a fine',
            params = {
                event = 'as-police:client:finePlayer',
                args = {playerId = GetPlayerServerId(player)}
            }
        },
        {
            header = 'Jail',
            txt = 'Send to prison',
            params = {
                event = 'as-police:client:jailPlayer',
                args = {playerId = GetPlayerServerId(player)}
            }
        },
    }
    
    exports['as-core']:ShowContext(menuItems)
end)

-- Handcuff player
RegisterNetEvent('as-police:client:cuffPlayer', function(data)
    local ped = PlayerPedId()
    
    -- Check for handcuffs in inventory
    local hasHandcuffs = exports.ox_inventory:Search('count', 'handcuffs')
    if not hasHandcuffs or hasHandcuffs < 1 then
        exports['as-core']:ShowNotification('You need handcuffs', 'error')
        return
    end
    
    -- Play animation
    TaskPlayAnim(ped, 'mp_arrest_paired', 'cop_p2_back_left', 8.0, -8.0, 3000, 0, 0, false, false, false)
    
    Wait(3000)
    
    TriggerServerEvent('as-police:server:cuffPlayer', data.playerId)
end)

-- Receive cuff
RegisterNetEvent('as-police:client:getCuffed', function()
    local ped = PlayerPedId()
    
    isHandcuffed = not isHandcuffed
    
    if isHandcuffed then
        -- Load animation
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Wait(10)
        end
        
        TaskPlayAnim(ped, 'mp_arresting', 'idle', 8.0, -8.0, -1, 49, 0, false, false, false)
        SetEnableHandcuffs(ped, true)
        DisablePlayerFiring(ped, true)
        SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
        
        exports['as-core']:ShowNotification('You have been handcuffed', 'error')
    else
        ClearPedTasks(ped)
        SetEnableHandcuffs(ped, false)
        DisablePlayerFiring(ped, false)
        
        exports['as-core']:ShowNotification('You have been uncuffed', 'success')
    end
end)

-- Drag player
RegisterNetEvent('as-police:client:dragPlayer', function(data)
    TriggerServerEvent('as-police:server:dragPlayer', data.playerId)
end)

-- Get dragged
RegisterNetEvent('as-police:client:getDragged', function(officerId)
    isDragging = not isDragging
    
    if isDragging then
        local officerPed = GetPlayerPed(GetPlayerFromServerId(officerId))
        AttachEntityToEntity(PlayerPedId(), officerPed, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
        exports['as-core']:ShowNotification('You are being dragged', 'info')
    else
        DetachEntity(PlayerPedId(), true, false)
        exports['as-core']:ShowNotification('You are no longer being dragged', 'info')
    end
end)

-- Put in vehicle
RegisterNetEvent('as-police:client:putInVehicle', function(data)
    TriggerServerEvent('as-police:server:putInVehicle', data.playerId)
end)

-- Get put in vehicle
RegisterNetEvent('as-police:client:getPutInVehicle', function()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)
    
    if vehicle ~= 0 then
        for i = 1, 2 do
            if IsVehicleSeatFree(vehicle, i) then
                TaskWarpPedIntoVehicle(ped, vehicle, i)
                break
            end
        end
    end
end)

-- Remove from vehicle
RegisterNetEvent('as-police:client:removeFromVehicle', function(data)
    TriggerServerEvent('as-police:server:removeFromVehicle', data.playerId)
end)

-- Get removed from vehicle
RegisterNetEvent('as-police:client:getOutOfVehicle', function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 16)
    end
end)

-- Search player
RegisterNetEvent('as-police:client:searchPlayer', function(data)
    exports.ox_inventory:openInventory('player', data.playerId)
end)

-- Fine player
RegisterNetEvent('as-police:client:finePlayer', function(data)
    local input = exports['as-core']:ShowInput({
        header = 'Issue Fine',
        submitText = 'Submit',
        inputs = {
            {
                text = 'Amount ($)',
                name = 'amount',
                type = 'number',
                isRequired = true
            },
            {
                text = 'Reason',
                name = 'reason',
                type = 'text',
                isRequired = true
            }
        }
    })
    
    if input then
        TriggerServerEvent('as-police:server:finePlayer', data.playerId, tonumber(input.amount), input.reason)
    end
end)

-- Jail player
RegisterNetEvent('as-police:client:jailPlayer', function(data)
    local input = exports['as-core']:ShowInput({
        header = 'Send to Jail',
        submitText = 'Submit',
        inputs = {
            {
                text = 'Time (months)',
                name = 'time',
                type = 'number',
                isRequired = true
            },
            {
                text = 'Reason',
                name = 'reason',
                type = 'text',
                isRequired = true
            }
        }
    })
    
    if input then
        TriggerServerEvent('as-police:server:jailPlayer', data.playerId, tonumber(input.time), input.reason)
    end
end)

-- Send to jail
RegisterNetEvent('as-police:client:sendToJail', function(time, reason)
    local ped = PlayerPedId()
    
    -- Find random cell
    local cellIndex = math.random(1, #Config.Jail.cells)
    local cell = Config.Jail.cells[cellIndex]
    
    SetEntityCoords(ped, cell.x, cell.y, cell.z)
    SetEntityHeading(ped, cell.w)
    
    exports['as-core']:ShowNotification('You have been jailed for ' .. time .. ' months', 'error')
    
    -- Start jail timer (simplified)
    local jailTime = time * 5 * 1000 -- 5 seconds per month for demo
    SetTimeout(jailTime, function()
        TriggerEvent('as-police:client:releaseFromJail')
    end)
end)

-- Release from jail
RegisterNetEvent('as-police:client:releaseFromJail', function()
    local ped = PlayerPedId()
    SetEntityCoords(ped, Config.Jail.release.x, Config.Jail.release.y, Config.Jail.release.z)
    SetEntityHeading(ped, Config.Jail.release.w)
    exports['as-core']:ShowNotification('You have been released from jail', 'success')
end)
