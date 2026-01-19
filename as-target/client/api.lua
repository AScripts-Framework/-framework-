-- Unified API for AS Target System

-- Add target to entity
-- @param entity number - Entity handle
-- @param options table - Target options
function ASTarget.AddEntity(entity, options)
    if not entity or not DoesEntityExist(entity) then
        print('^3[AS-TARGET]^7 Invalid entity provided')
        return
    end
    
    ASTarget.Bridge.AddEntityTarget(entity, options)
end

-- Add target to network entity
-- @param netId number - Network ID
-- @param options table - Target options
function ASTarget.AddNetworkEntity(netId, options)
    if not netId then
        print('^3[AS-TARGET]^7 Invalid network ID provided')
        return
    end
    
    ASTarget.Bridge.AddNetworkTarget(netId, options)
end

-- Add target to model(s)
-- @param models string|table - Model hash or array of model hashes
-- @param options table - Target options
function ASTarget.AddModel(models, options)
    if not models then
        print('^3[AS-TARGET]^7 No models provided')
        return
    end
    
    ASTarget.Bridge.AddModelTarget(models, options)
end

-- Add global player target
-- @param options table - Target options
function ASTarget.AddGlobalPlayer(options)
    ASTarget.Bridge.AddGlobalTarget(options)
end

-- Add box zone target
-- @param name string - Zone name
-- @param coords vector3 - Zone coordinates
-- @param size vector3 - Zone size (x, y, z)
-- @param options table - Zone options with targets
function ASTarget.AddBoxZone(name, coords, size, options)
    if not name or not coords or not size then
        print('^3[AS-TARGET]^7 Invalid box zone parameters')
        return
    end
    
    ASTarget.Bridge.AddBoxZone(name, coords, size, options)
end

-- Add circle/sphere zone target
-- @param name string - Zone name
-- @param coords vector3 - Zone coordinates
-- @param radius number - Zone radius
-- @param options table - Zone options with targets
function ASTarget.AddCircleZone(name, coords, radius, options)
    if not name or not coords or not radius then
        print('^3[AS-TARGET]^7 Invalid circle zone parameters')
        return
    end
    
    ASTarget.Bridge.AddCircleZone(name, coords, radius, options)
end

-- Remove target from entity
-- @param entity number - Entity handle
function ASTarget.RemoveEntity(entity)
    if not entity then
        print('^3[AS-TARGET]^7 Invalid entity provided')
        return
    end
    
    ASTarget.Bridge.RemoveEntityTarget(entity)
end

-- Remove zone
-- @param name string - Zone name
function ASTarget.RemoveZone(name)
    if not name then
        print('^3[AS-TARGET]^7 Zone name required')
        return
    end
    
    ASTarget.Bridge.RemoveZone(name)
end

-- Get current target system
-- @return string - Current target system name
function ASTarget.GetCurrentSystem()
    return ASTarget.CurrentSystem
end

-- Check if target system is available
-- @return boolean - True if target system is available
function ASTarget.IsAvailable()
    return ASTarget.CurrentSystem ~= nil
end

-- Exports
exports('GetTargetObject', function()
    return ASTarget
end)

exports('AddEntity', ASTarget.AddEntity)
exports('AddNetworkEntity', ASTarget.AddNetworkEntity)
exports('AddModel', ASTarget.AddModel)
exports('AddGlobalPlayer', ASTarget.AddGlobalPlayer)
exports('AddBoxZone', ASTarget.AddBoxZone)
exports('AddCircleZone', ASTarget.AddCircleZone)
exports('RemoveEntity', ASTarget.RemoveEntity)
exports('RemoveZone', ASTarget.RemoveZone)
exports('GetCurrentSystem', ASTarget.GetCurrentSystem)
exports('IsAvailable', ASTarget.IsAvailable)

print('^2[AS-TARGET]^7 API module loaded')
