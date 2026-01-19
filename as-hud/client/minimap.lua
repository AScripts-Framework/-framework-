-- Minimap controller
local inVehicle = false
local minimapEnabled = false

-- Setup minimap style
function SetupMinimap()
    if not Config.HUD.Minimap.roundedMinimap then return end
    
    -- Request minimap anchor
    RequestStreamedTextureDict("squaremap", false)
    while not HasStreamedTextureDictLoaded("squaremap") do
        Wait(100)
    end
    
    -- Set minimap to rounded
    SetMinimapComponentPosition('minimap', 'L', 'B', Config.HUD.Minimap.minimapOffset.x, Config.HUD.Minimap.minimapOffset.y, 0.0, 0.0)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', Config.HUD.Minimap.minimapOffset.x, Config.HUD.Minimap.minimapOffset.y, 0.0, 0.0)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', Config.HUD.Minimap.minimapOffset.x, Config.HUD.Minimap.minimapOffset.y, 0.0, 0.0)
    
    -- Set aspect ratio
    SetMinimapClipType(0)
end

-- Show minimap
function ShowMinimap()
    if minimapEnabled then return end
    
    minimapEnabled = true
    DisplayRadar(true)
    
    CreateThread(function()
        local startTime = GetGameTimer()
        local duration = 300 -- Animation duration in ms
        
        while GetGameTimer() - startTime < duration do
            local progress = (GetGameTimer() - startTime) / duration
            SetRadarZoom(1100 - (progress * 100))
            Wait(0)
        end
        
        SetRadarZoom(1000)
    end)
end

-- Hide minimap
function HideMinimap()
    if not minimapEnabled then return end
    
    minimapEnabled = false
    
    CreateThread(function()
        local startTime = GetGameTimer()
        local duration = 300
        
        while GetGameTimer() - startTime < duration do
            local progress = (GetGameTimer() - startTime) / duration
            SetRadarZoom(1000 + (progress * 100))
            Wait(0)
        end
        
        DisplayRadar(false)
    end)
end

-- Initialize minimap
CreateThread(function()
    -- Wait for game to load
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    
    -- Setup minimap style
    SetupMinimap()
    
    -- Hide by default
    DisplayRadar(false)
    
    print('^2[AS-HUD]^7 Minimap initialized')
end)

-- Monitor vehicle state
CreateThread(function()
    while true do
        Wait(500)
        
        if Config.HUD.Minimap.enableDynamicMinimap then
            local ped = PlayerPedId()
            local currentlyInVehicle = IsPedInAnyVehicle(ped, false)
            
            if currentlyInVehicle and not inVehicle then
                -- Just entered vehicle
                inVehicle = true
                ShowMinimap()
            elseif not currentlyInVehicle and inVehicle then
                -- Just exited vehicle
                inVehicle = false
                HideMinimap()
            end
        end
    end
end)

-- Export functions
exports('ShowMinimap', ShowMinimap)
exports('HideMinimap', HideMinimap)

print('^2[AS-HUD]^7 Minimap module loaded')
