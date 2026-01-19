-- Zone management functions

-- Add entity target
function ASTarget.AddEntity(entity, options)
    if type(entity) == 'table' then
        for _, ent in ipairs(entity) do
            ASTarget.Targets.entities[ent] = options
        end
    else
        ASTarget.Targets.entities[entity] = options
    end
    
    if Config.Target.Debug then
        print('^2[AS-TARGET]^7 Added entity target:', entity)
    end
end

-- Remove entity target
function ASTarget.RemoveEntity(entity)
    if type(entity) == 'table' then
        for _, ent in ipairs(entity) do
            ASTarget.Targets.entities[ent] = nil
        end
    else
        ASTarget.Targets.entities[entity] = nil
    end
    
    if Config.Target.Debug then
        print('^2[AS-TARGET]^7 Removed entity target:', entity)
    end
end

-- Add model target
function ASTarget.AddModel(models, options)
    if type(models) ~= 'table' then
        models = {models}
    end
    
    for _, model in ipairs(models) do
        local hash = type(model) == 'string' and GetHashKey(model) or model
        ASTarget.Targets.models[hash] = options
        
        if Config.Target.Debug then
            print('^2[AS-TARGET]^7 Added model target:', model)
        end
    end
end

-- Remove model target
function ASTarget.RemoveModel(models)
    if type(models) ~= 'table' then
        models = {models}
    end
    
    for _, model in ipairs(models) do
        local hash = type(model) == 'string' and GetHashKey(model) or model
        ASTarget.Targets.models[hash] = nil
        
        if Config.Target.Debug then
            print('^2[AS-TARGET]^7 Removed model target:', model)
        end
    end
end

-- Add box zone
function ASTarget.AddBoxZone(name, coords, size, rotation, options)
    ASTarget.Targets.zones[name] = {
        type = 'box',
        coords = type(coords) == 'table' and vector3(coords.x, coords.y, coords.z) or coords,
        size = type(size) == 'table' and vector3(size.x, size.y, size.z) or size,
        rotation = rotation or 0.0,
        options = options
    }
    
    if Config.Target.Debug then
        print('^2[AS-TARGET]^7 Added box zone:', name)
    end
end

-- Add circle zone
function ASTarget.AddCircleZone(name, coords, radius, options)
    ASTarget.Targets.zones[name] = {
        type = 'circle',
        coords = type(coords) == 'table' and vector3(coords.x, coords.y, coords.z) or coords,
        radius = radius,
        options = options
    }
    
    if Config.Target.Debug then
        print('^2[AS-TARGET]^7 Added circle zone:', name)
    end
end

-- Remove zone
function ASTarget.RemoveZone(name)
    ASTarget.Targets.zones[name] = nil
    
    if Config.Target.Debug then
        print('^2[AS-TARGET]^7 Removed zone:', name)
    end
end

-- Add global ped target
function ASTarget.AddGlobalPed(options)
    ASTarget.Targets.global.peds = options
    
    if Config.Target.Debug then
        print('^2[AS-TARGET]^7 Added global ped target')
    end
end

-- Add global vehicle target
function ASTarget.AddGlobalVehicle(options)
    ASTarget.Targets.global.vehicles = options
    
    if Config.Target.Debug then
        print('^2[AS-TARGET]^7 Added global vehicle target')
    end
end

-- Add global object target
function ASTarget.AddGlobalObject(options)
    ASTarget.Targets.global.objects = options
    
    if Config.Target.Debug then
        print('^2[AS-TARGET]^7 Added global object target')
    end
end

-- Exports for external use
exports('AddEntity', ASTarget.AddEntity)
exports('RemoveEntity', ASTarget.RemoveEntity)
exports('AddModel', ASTarget.AddModel)
exports('RemoveModel', ASTarget.RemoveModel)
exports('AddBoxZone', ASTarget.AddBoxZone)
exports('AddCircleZone', ASTarget.AddCircleZone)
exports('RemoveZone', ASTarget.RemoveZone)
exports('AddGlobalPed', ASTarget.AddGlobalPed)
exports('AddGlobalVehicle', ASTarget.AddGlobalVehicle)
exports('AddGlobalObject', ASTarget.AddGlobalObject)
