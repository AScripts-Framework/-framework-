local AS = exports['as-core']:GetCoreObject()

-- Register ox_inventory stashes for hospitals
if GetResourceState('ox_inventory') == 'started' then
    exports.ox_inventory:RegisterStash('ems_medical_supplies', 'Medical Supplies', 50, 100000, true)
end
