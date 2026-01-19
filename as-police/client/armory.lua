-- Create armory points
CreateThread(function()
    for stationId, station in pairs(Config.Stations) do
        exports['as-target']:AddBoxZone('police_armory_' .. stationId, station.armory.coords, 2.0, 1.5, {
            name = 'police_armory_' .. stationId,
            heading = station.armory.heading,
            debugPoly = false,
            minZ = station.armory.coords.z - 1.0,
            maxZ = station.armory.coords.z + 1.0
        }, {
            options = {
                {
                    type = 'client',
                    event = 'as-police:client:openArmoryMenu',
                    icon = 'fas fa-gun',
                    label = 'Access Armory',
                    canInteract = function()
                        return exports['as-police']:IsOnDuty()
                    end
                }
            },
            distance = 2.0
        })
    end
end)

-- Open armory menu
RegisterNetEvent('as-police:client:openArmoryMenu', function()
    TriggerServerEvent('as-police:server:getArmory')
end)

-- Display armory
RegisterNetEvent('as-police:client:openArmory', function(weapons, equipment)
    local menuItems = {
        {header = 'Police Armory', isMenuHeader = true},
        {header = '⬅ Weapons', txt = 'Available weapons', isMenuHeader = true},
    }
    
    for _, weapon in ipairs(weapons) do
        table.insert(menuItems, {
            header = weapon.label,
            txt = weapon.ammo and 'Includes 50 rounds' or '',
            params = {
                isServer = true,
                event = 'as-police:server:takeWeapon',
                args = weapon
            }
        })
    end
    
    table.insert(menuItems, {header = '⬅ Equipment', txt = 'Available equipment', isMenuHeader = true})
    
    for _, item in ipairs(equipment) do
        table.insert(menuItems, {
            header = item.label,
            txt = '',
            params = {
                isServer = true,
                event = 'as-police:server:takeEquipment',
                args = item
            }
        })
    end
    
    exports['as-core']:ShowContext(menuItems)
end)
