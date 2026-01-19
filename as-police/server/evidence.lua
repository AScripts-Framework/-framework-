local activeEvidence = {}
local evidenceId = 0

-- Create evidence
RegisterNetEvent('as-police:server:createEvidence', function(evidenceType, coords, data)
    local src = source
    
    evidenceId = evidenceId + 1
    
    activeEvidence[evidenceId] = {
        id = evidenceId,
        type = evidenceType,
        coords = coords,
        data = data,
        created = os.time(),
        collected = false
    }
    
    -- Sync to all police
    TriggerClientEvent('as-police:client:syncEvidence', -1, evidenceId, activeEvidence[evidenceId])
    
    -- Auto-despawn after configured time
    SetTimeout(Config.Evidence.despawnTime * 1000, function()
        if activeEvidence[evidenceId] and not activeEvidence[evidenceId].collected then
            activeEvidence[evidenceId] = nil
            TriggerClientEvent('as-police:client:removeEvidence', -1, evidenceId)
        end
    end)
end)

-- Collect evidence
RegisterNetEvent('as-police:server:collectEvidence', function(evidenceId)
    local src = source
    local Player = exports['as-core']:GetPlayer(src)
    
    if not Player then return end
    if not exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-core:Notify', src, 'You must be on duty', 'error')
        return
    end
    
    if not activeEvidence[evidenceId] then
        TriggerClientEvent('as-core:Notify', src, 'Evidence no longer available', 'error')
        return
    end
    
    local evidence = activeEvidence[evidenceId]
    
    -- Check if player has evidence bag
    local hasEvidenceBag = exports.ox_inventory:GetItem(src, 'evidence_bag', nil, true)
    if not hasEvidenceBag or hasEvidenceBag < 1 then
        TriggerClientEvent('as-core:Notify', src, 'You need an evidence bag', 'error')
        return
    end
    
    -- Remove evidence bag
    exports.ox_inventory:RemoveItem(src, 'evidence_bag', 1)
    
    -- Add evidence item to inventory
    local evidenceItem = 'evidence_' .. evidence.type
    local metadata = {
        type = evidence.type,
        collected_by = Player.name,
        collected_at = os.date('%Y-%m-%d %H:%M:%S'),
        data = evidence.data
    }
    
    exports.ox_inventory:AddItem(src, evidenceItem, 1, metadata)
    
    -- Mark as collected
    activeEvidence[evidenceId].collected = true
    
    -- Save to database
    MySQL.insert('INSERT INTO evidence (type, coords, data, collected_by, collected_at) VALUES (?, ?, ?, ?, NOW())', {
        evidence.type,
        json.encode(evidence.coords),
        json.encode(evidence.data),
        Player.identifier
    })
    
    TriggerClientEvent('as-core:Notify', src, 'Evidence collected', 'success')
    TriggerClientEvent('as-police:client:removeEvidence', -1, evidenceId)
end)

-- Get all active evidence (for police on duty)
RegisterNetEvent('as-police:server:getEvidence', function()
    local src = source
    
    if exports['as-police']:IsOnDuty(src) then
        TriggerClientEvent('as-police:client:loadEvidence', src, activeEvidence)
    end
end)

-- Blood trail handler
RegisterNetEvent('as-police:server:createBloodTrail', function(coords)
    if Config.Evidence.enableBloodTrails then
        TriggerEvent('as-police:server:createEvidence', 'blood_sample', coords, {
            time = os.date('%H:%M:%S')
        })
    end
end)

-- Bullet casing handler
RegisterNetEvent('as-police:server:createBulletCasing', function(coords, weapon)
    if Config.Evidence.enableBulletCasings then
        TriggerEvent('as-police:server:createEvidence', 'bullet_casing', coords, {
            weapon = weapon,
            time = os.date('%H:%M:%S')
        })
    end
end)
