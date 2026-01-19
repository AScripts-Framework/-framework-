-- Get armory items for player
RegisterNetEvent('as-police:server:getArmory', function()
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    local grade = Player.job.grade_name or 'recruit'
    local weapons = Config.Weapons[grade] or Config.Weapons['recruit']
    local equipment = Config.Equipment
    
    TriggerClientEvent('as-police:client:openArmory', src, weapons, equipment)
end)

-- Take weapon from armory
RegisterNetEvent('as-police:server:takeWeapon', function(weaponData)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    -- Add weapon to inventory
    local added = exports.ox_inventory:AddItem(src, weaponData.name, 1)
    
    if added then
        -- Add ammo if weapon has it
        if weaponData.ammo then
            exports.ox_inventory:AddItem(src, weaponData.ammo, 50)
        end
        TriggerClientEvent('as-core:Notify', src, 'You took a ' .. weaponData.label, 'success')
    else
        TriggerClientEvent('as-core:Notify', src, 'Inventory full', 'error')
    end
end)

-- Take equipment from armory
RegisterNetEvent('as-police:server:takeEquipment', function(itemData)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    local amount = 1
    if itemData.name == 'bandage' or itemData.name == 'evidence_bag' then
        amount = 5
    end
    
    local added = exports.ox_inventory:AddItem(src, itemData.name, amount)
    
    if added then
        TriggerClientEvent('as-core:Notify', src, 'You took ' .. itemData.label, 'success')
    else
        TriggerClientEvent('as-core:Notify', src, 'Inventory full', 'error')
    end
end)

-- Deposit items to armory
RegisterNetEvent('as-police:server:depositItem', function(item, amount)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    
    local removed = exports.ox_inventory:RemoveItem(src, item, amount)
    
    if removed then
        TriggerClientEvent('as-core:Notify', src, 'Item deposited', 'success')
    else
        TriggerClientEvent('as-core:Notify', src, 'Failed to deposit item', 'error')
    end
end)
