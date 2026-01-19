AS = exports['as-core']:GetCoreObject()
ASTarget = {}
ASTarget.CurrentSystem = nil

-- Initialize target system
CreateThread(function()
    -- Wait for as-core
    while GetResourceState('as-core') ~= 'started' do
        Wait(100)
    end
    
    print('^2[AS-TARGET]^7 Initializing target system...')
end)

print('^2[AS-TARGET]^7 Client main loaded')
