-- Target system bridge
local TargetBridge = {}

-- Detect which target system is available
function TargetBridge.DetectSystem()
    -- Check if using custom target
    if Config.Target.UseCustomTarget then
        return 'as_target'
    end
    
    if Config.Target.ForceSystem then
        if GetResourceState(Config.Target.ForceSystem) == 'started' then
            return Config.Target.ForceSystem
        else
            print('^3[AS-TARGET]^7 Forced system "' .. Config.Target.ForceSystem .. '" not found, using custom target...')
            return 'as_target'
        end
    end
    
    -- Priority: ox_target > qb-target > custom
    if GetResourceState('ox_target') == 'started' then
        return 'ox_target'
    elseif GetResourceState('qb-target') == 'started' then
        return 'qb-target'
    end
    
    return 'as_target'
end

-- Initialize bridge
function TargetBridge.Initialize()
    local system = TargetBridge.DetectSystem()
    
    ASTarget.CurrentSystem = system
    print('^2[AS-TARGET]^7 Using target system: ^3' .. system .. '^7')
    
    return true
end

-- Add target to entity
function TargetBridge.AddEntityTarget(entity, options)
    if not ASTarget.CurrentSystem then return end
    
    if ASTarget.CurrentSystem == 'as_target' then
        -- Use our custom target
        ASTarget.AddEntity(entity, options)
    elseif ASTarget.CurrentSystem == 'ox_target' then
        -- ox_target format
        exports.ox_target:addLocalEntity(entity, options)
    elseif ASTarget.CurrentSystem == 'qb-target' then
        -- qb-target format
        local qbOptions = {}
        for _, opt in ipairs(options) do
            table.insert(qbOptions, {
                icon = opt.icon,
                label = opt.label,
                action = opt.onSelect,
                canInteract = opt.canInteract,
                distance = opt.distance or Config.Target.DefaultDistance
            })
        end
        exports['qb-target']:AddTargetEntity(entity, {
            options = qbOptions,
            distance = Config.Target.DefaultDistance
        })
    end
end

-- Add target to network entity
function TargetBridge.AddNetworkTarget(netId, options)
    if not ASTarget.CurrentSystem then return end
    
    if ASTarget.CurrentSystem == 'as_target' then
        ASTarget.AddEntity(netId, options)
    elseif ASTarget.CurrentSystem == 'ox_target' then
        exports.ox_target:addEntity(netId, options)
    elseif ASTarget.CurrentSystem == 'qb-target' then
        local entity = NetworkGetEntityFromNetworkId(netId)
        TargetBridge.AddEntityTarget(entity, options)
    end
end

-- Add target to model
function TargetBridge.AddModelTarget(models, options)
    if not ASTarget.CurrentSystem then return end
    
    if type(models) ~= 'table' then
        models = {models}
    end
    
    if ASTarget.CurrentSystem == 'as_target' then
        ASTarget.AddModel(models, options)
    elseif ASTarget.CurrentSystem == 'ox_target' then
        exports.ox_target:addModel(models, options)
    elseif ASTarget.CurrentSystem == 'qb-target' then
        local qbOptions = {}
        for _, opt in ipairs(options) do
            table.insert(qbOptions, {
                icon = opt.icon,
                label = opt.label,
                action = opt.onSelect,
                canInteract = opt.canInteract,
                distance = opt.distance or Config.Target.DefaultDistance
            })
        end
        for _, model in ipairs(models) do
            exports['qb-target']:AddTargetModel(model, {
                options = qbOptions,
                distance = Config.Target.DefaultDistance
            })
        end
    end
end

-- Add global target
function TargetBridge.AddGlobalTarget(options)
    if not ASTarget.CurrentSystem then return end
    
    if ASTarget.CurrentSystem == 'as_target' then
        ASTarget.AddGlobalPed(options)
    elseif ASTarget.CurrentSystem == 'ox_target' then
        exports.ox_target:addGlobalPlayer(options)
    elseif ASTarget.CurrentSystem == 'qb-target' then
        local qbOptions = {}
        for _, opt in ipairs(options) do
            table.insert(qbOptions, {
                icon = opt.icon,
                label = opt.label,
                action = opt.onSelect,
                canInteract = opt.canInteract,
                distance = opt.distance or Config.Target.DefaultDistance
            })
        end
        exports['qb-target']:AddGlobalPlayer({
            options = qbOptions,
            distance = Config.Target.DefaultDistance
        })
    end
end

-- Add target to coordinates
function TargetBridge.AddBoxZone(name, coords, size, options)
    if not ASTarget.CurrentSystem then return end
    
    if ASTarget.CurrentSystem == 'as_target' then
        ASTarget.AddBoxZone(name, coords, size, options.rotation or 0.0, options.targets)
    elseif ASTarget.CurrentSystem == 'ox_target' then
        exports.ox_target:addBoxZone({
            coords = coords,
            size = size,
            rotation = options.rotation or 0.0,
            debug = Config.Target.Debug,
            options = options.targets
        })
    elseif ASTarget.CurrentSystem == 'qb-target' then
        local qbOptions = {}
        for _, opt in ipairs(options.targets) do
            table.insert(qbOptions, {
                icon = opt.icon,
                label = opt.label,
                action = opt.onSelect,
                canInteract = opt.canInteract,
                distance = opt.distance or Config.Target.DefaultDistance
            })
        end
        exports['qb-target']:AddBoxZone(name, coords, size.x, size.y, {
            name = name,
            heading = options.rotation or 0.0,
            debugPoly = Config.Target.Debug,
            minZ = coords.z - (size.z / 2),
            maxZ = coords.z + (size.z / 2)
        }, {
            options = qbOptions,
            distance = Config.Target.DefaultDistance
        })
    end
end

-- Add circle zone
function TargetBridge.AddCircleZone(name, coords, radius, options)
    if not ASTarget.CurrentSystem then return end
    
    if ASTarget.CurrentSystem == 'as_target' then
        ASTarget.AddCircleZone(name, coords, radius, options.targets)
    elseif ASTarget.CurrentSystem == 'ox_target' then
        exports.ox_target:addSphereZone({
            coords = coords,
            radius = radius,
            debug = Config.Target.Debug,
            options = options.targets
        })
    elseif ASTarget.CurrentSystem == 'qb-target' then
        local qbOptions = {}
        for _, opt in ipairs(options.targets) do
            table.insert(qbOptions, {
                icon = opt.icon,
                label = opt.label,
                action = opt.onSelect,
                canInteract = opt.canInteract,
                distance = opt.distance or Config.Target.DefaultDistance
            })
        end
        exports['qb-target']:AddCircleZone(name, coords, radius, {
            name = name,
            debugPoly = Config.Target.Debug
        }, {
            options = qbOptions,
            distance = Config.Target.DefaultDistance
        })
    end
end

-- Remove target from entity
function TargetBridge.RemoveEntityTarget(entity)
    if not ASTarget.CurrentSystem then return end
    
    if ASTarget.CurrentSystem == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity)
    elseif ASTarget.CurrentSystem == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(entity)
    end
end

-- Remove zone
function TargetBridge.RemoveZone(name)
    if not ASTarget.CurrentSystem then return end
    
    if ASTarget.CurrentSystem == 'ox_target' then
        exports.ox_target:removeZone(name)
    elseif ASTarget.CurrentSystem == 'qb-target' then
        exports['qb-target']:RemoveZone(name)
    end
end

-- Initialize on load
CreateThread(function()
    Wait(1000)
    TargetBridge.Initialize()
end)

ASTarget.Bridge = TargetBridge

print('^2[AS-TARGET]^7 Bridge module loaded')
