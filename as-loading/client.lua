-- AS Loading Screen - Client
local playerLoaded = false

-- Disable cursor controls during loading
CreateThread(function()
    while not playerLoaded do
        Wait(0)
        -- Disable controls that would interfere with loading screen
        DisableAllControlActions(0)
        
        -- Enable cursor movement for loading screen controls
        EnableControlAction(0, 1, true)  -- Camera Left/Right
        EnableControlAction(0, 2, true)  -- Camera Up/Down
        EnableControlAction(0, 24, true) -- Attack (Mouse Click)
        EnableControlAction(0, 25, true) -- Aim
    end
end)

-- Listen for AS Framework player loaded event
RegisterNetEvent('AS:Client:OnPlayerLoaded', function()
    playerLoaded = true
    
    -- Send message to loading screen to shutdown
    SendLoadingScreenMessage(json.encode({
        eventName = 'playerLoaded',
        action = 'playerLoaded'
    }))
    
    -- Wait a moment then shutdown loading screen
    Wait(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    
    -- Re-enable all controls
    EnableAllControlActions(0)
end)

-- Alternative: Listen for character selection completion (if using multichar)
RegisterNetEvent('AS:Client:OnCharacterSelected', function()
    playerLoaded = true
    
    SendLoadingScreenMessage(json.encode({
        eventName = 'playerLoaded',
        action = 'playerLoaded'
    }))
    
    Wait(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    EnableAllControlActions(0)
end)

-- Fallback: Auto-shutdown after max time (5 minutes)
CreateThread(function()
    Wait(200000) -- 5 minutes
    if not playerLoaded then
        print('[AS-Loading] Forcing shutdown after timeout')
        playerLoaded = true
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        EnableAllControlActions(0)
    end
end)
