-- Target system core
ASTarget.Targets = {
    entities = {},
    models = {},
    zones = {},
    global = {}
}

ASTarget.CurrentTarget = {
    entity = nil,
    options = nil,
    distance = nil
}

local isTargetActive = false
local raycastDistance = Config.Target.DefaultDistance or 5.0

-- Raycast function
function ASTarget.RaycastCamera(distance)
    local camCoords = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local camDir = ASTarget.RotationToDirection(camRot)
    local destination = vector3(
        camCoords.x + camDir.x * distance,
        camCoords.y + camDir.y * distance,
        camCoords.z + camDir.z * distance
    )
    
    local handle = StartShapeTestRay(
        camCoords.x, camCoords.y, camCoords.z,
        destination.x, destination.y, destination.z,
        -1,
        PlayerPedId(),
        0
    )
    
    return GetShapeTestResult(handle)
end

-- Convert rotation to direction
function ASTarget.RotationToDirection(rotation)
    local adjustedRotation = vector3(
        (math.pi / 180) * rotation.x,
        (math.pi / 180) * rotation.y,
        (math.pi / 180) * rotation.z
    )
    
    local direction = vector3(
        -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        math.sin(adjustedRotation.x)
    )
    
    return direction
end

-- Check if player is aiming at valid target
function ASTarget.CheckTarget()
    local hit, entityHit, endCoords, surfaceNormal, materialHash = ASTarget.RaycastCamera(raycastDistance)
    
    if not hit or hit == 0 then
        return nil, nil, nil
    end
    
    if not DoesEntityExist(entityHit) or entityHit == 0 then
        -- Check zones
        local zoneOptions = ASTarget.CheckZones(endCoords)
        if zoneOptions then
            return nil, zoneOptions, nil
        end
        return nil, nil, nil
    end
    
    -- Check entity targets
    local options = ASTarget.GetEntityOptions(entityHit)
    if not options then
        return nil, nil, nil
    end
    
    -- Calculate distance
    local playerCoords = GetEntityCoords(PlayerPedId())
    local entityCoords = GetEntityCoords(entityHit)
    local distance = #(playerCoords - entityCoords)
    
    -- Filter options by distance and canInteract
    local validOptions = {}
    for _, option in ipairs(options) do
        local maxDist = option.distance or raycastDistance
        if distance <= maxDist then
            if not option.canInteract or option.canInteract(entityHit) then
                table.insert(validOptions, option)
            end
        end
    end
    
    if #validOptions == 0 then
        return nil, nil, nil
    end
    
    return entityHit, validOptions, distance
end

-- Get options for entity
function ASTarget.GetEntityOptions(entity)
    -- Check direct entity targets
    if ASTarget.Targets.entities[entity] then
        return ASTarget.Targets.entities[entity]
    end
    
    -- Check network entity targets
    local netId = NetworkGetNetworkIdFromEntity(entity)
    if ASTarget.Targets.entities[netId] then
        return ASTarget.Targets.entities[netId]
    end
    
    -- Check model targets
    local model = GetEntityModel(entity)
    if ASTarget.Targets.models[model] then
        return ASTarget.Targets.models[model]
    end
    
    -- Check global targets
    if GetEntityType(entity) == 1 and entity ~= PlayerPedId() then -- Ped
        if ASTarget.Targets.global.peds then
            return ASTarget.Targets.global.peds
        end
    end
    
    return nil
end

-- Check if coordinates are in any zone
function ASTarget.CheckZones(coords)
    for name, zone in pairs(ASTarget.Targets.zones) do
        if zone.type == 'box' then
            if ASTarget.IsPointInBox(coords, zone.coords, zone.size, zone.rotation) then
                return zone.options
            end
        elseif zone.type == 'circle' then
            local dist = #(coords - zone.coords)
            if dist <= zone.radius then
                return zone.options
            end
        end
    end
    return nil
end

-- Check if point is in box zone
function ASTarget.IsPointInBox(point, center, size, rotation)
    local dx = point.x - center.x
    local dy = point.y - center.y
    local dz = point.z - center.z
    
    -- Apply rotation
    local rad = math.rad(rotation or 0.0)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    
    local rx = dx * cos + dy * sin
    local ry = -dx * sin + dy * cos
    
    -- Check bounds
    return math.abs(rx) <= size.x / 2 and
           math.abs(ry) <= size.y / 2 and
           math.abs(dz) <= size.z / 2
end

-- Main target loop
CreateThread(function()
    while true do
        local sleep = 500
        
        if isTargetActive then
            sleep = 0
            
            local entity, options, distance = ASTarget.CheckTarget()
            
            if options and #options > 0 then
                -- Has valid target
                if entity ~= ASTarget.CurrentTarget.entity or not ASTarget.CurrentTarget.options then
                    ASTarget.CurrentTarget.entity = entity
                    ASTarget.CurrentTarget.options = options
                    ASTarget.CurrentTarget.distance = distance
                    
                    -- Get entity label if exists
                    local label = nil
                    if entity and DoesEntityExist(entity) then
                        if IsEntityAPed(entity) then
                            label = GetPlayerName(PlayerId())
                        end
                    end
                    
                    SendNUIMessage({
                        action = 'updateOptions',
                        options = options,
                        distance = distance,
                        label = label
                    })
                end
            else
                -- No valid target
                if ASTarget.CurrentTarget.options then
                    ASTarget.CurrentTarget.entity = nil
                    ASTarget.CurrentTarget.options = nil
                    ASTarget.CurrentTarget.distance = nil
                    
                    SendNUIMessage({
                        action = 'updateOptions',
                        options = {}
                    })
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Toggle target
function ASTarget.Toggle(state)
    if state == nil then
        state = not isTargetActive
    end
    
    isTargetActive = state
    
    if state then
        SendNUIMessage({
            action = 'show'
        })
    else
        SendNUIMessage({
            action = 'hide'
        })
        ASTarget.CurrentTarget = {
            entity = nil,
            options = nil,
            distance = nil
        }
    end
end

-- NUI Callback for option selection
RegisterNUICallback('selectOption', function(data, cb)
    cb('ok')
    
    if not ASTarget.CurrentTarget.options then return end
    
    local option = ASTarget.CurrentTarget.options[data.index + 1] -- Lua is 1-indexed
    if not option then return end
    
    -- Call onSelect callback
    if option.onSelect then
        option.onSelect(ASTarget.CurrentTarget.entity)
    end
    
    -- Hide target after selection if configured
    if Config.Target.CloseOnSelect then
        ASTarget.Toggle(false)
    end
end)

-- Keybind to toggle target
RegisterCommand('+target', function()
    ASTarget.Toggle(true)
end, false)

RegisterCommand('-target', function()
    ASTarget.Toggle(false)
end, false)

RegisterKeyMapping('+target', 'Open Target Eye', 'keyboard', Config.Target.Keybind or 'LMENU')

print('^2[AS-TARGET]^7 Target system initialized')
