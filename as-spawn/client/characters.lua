local AS = exports['as-core']:GetCoreObject()
local selectedCharId = nil
local inCharSelection = false

-- Detect which appearance system is running
function GetAppearanceResource()
    if GetResourceState('fivem-appearance') == 'started' then
        return 'fivem-appearance'
    elseif GetResourceState('illenium-appearance') == 'started' then
        return 'illenium-appearance'
    end
    return nil
end

-- Open appearance customization menu
function OpenAppearanceMenu(characterData, charId, callback)
    local appearanceResource = GetAppearanceResource()
    
    if not appearanceResource then
        print('^3[AS-SPAWN]^7 No appearance resource detected, skipping customization')
        if callback then callback(true) end
        return
    end
    
    local ped = PlayerPedId()
    
    -- Set ped model based on gender
    local model = characterData.sex == 'M' and `mp_m_freemode_01` or `mp_f_freemode_01`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    
    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)
    
    -- Teleport to appearance location
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do Wait(0) end
    
    local coords = Config.Spawn.Appearance.CreationCoords
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(ped, coords.w or 0.0)
    FreezeEntityPosition(ped, true)
    
    Wait(500)
    DoScreenFadeIn(1000)
    Wait(1000)
    
    -- Open appropriate appearance menu
    if appearanceResource == 'fivem-appearance' then
        -- fivem-appearance
        exports['fivem-appearance']:startPlayerCustomization(function(appearance)
            if appearance then
                -- Save appearance to server
                TriggerServerEvent('as-spawn:server:saveAppearance', charId, appearance)
                
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do Wait(0) end
                
                FreezeEntityPosition(ped, false)
                
                if callback then callback(true) end
            else
                -- User cancelled
                if callback then callback(false) end
            end
        end)
    elseif appearanceResource == 'illenium-appearance' then
        -- illenium-appearance
        exports['illenium-appearance']:startPlayerCustomization(function(appearance)
            if appearance then
                -- Save appearance to server
                TriggerServerEvent('as-spawn:server:saveAppearance', charId, appearance)
                
                DoScreenFadeOut(500)
                while not IsScreenFadedOut() do Wait(0) end
                
                FreezeEntityPosition(ped, false)
                
                if callback then callback(true) end
            else
                -- User cancelled
                if callback then callback(false) end
            end
        end)
    end
end

-- Create character selection camera
function CreateCharSelectionCamera()
    local cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    SetCamCoord(cam, Config.Spawn.Camera.coords.x, Config.Spawn.Camera.coords.y, Config.Spawn.Camera.coords.z)
    SetCamRot(cam, Config.Spawn.Camera.rotation.x, Config.Spawn.Camera.rotation.y, Config.Spawn.Camera.rotation.z, 2)
    SetCamFov(cam, Config.Spawn.Camera.fov)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)
    return cam
end

-- Show character creation dialog
function ShowCharacterCreation(onComplete)
    local input = exports['as-core']:ShowInput({
        {
            type = 'input',
            label = 'First Name',
            description = 'Enter your character\'s first name',
            required = true,
            min = 2,
            max = 50
        },
        {
            type = 'input',
            label = 'Last Name',
            description = 'Enter your character\'s last name',
            required = true,
            min = 2,
            max = 50
        },
        {
            type = 'date',
            label = 'Date of Birth',
            description = 'Select your character\'s date of birth',
            required = true,
            format = "MM/DD/YYYY",
            returnString = true
        },
        {
            type = 'select',
            label = 'Gender',
            description = 'Select your character\'s gender',
            required = true,
            options = {
                {value = 'M', label = 'Male'},
                {value = 'F', label = 'Female'}
            }
        },
        {
            type = 'slider',
            label = 'Height (cm)',
            description = 'Select your character\'s height',
            required = true,
            min = 150,
            max = 200,
            default = 175
        }
    })
    
    if input then
        local characterData = {
            firstname = input[1],
            lastname = input[2],
            dateofbirth = input[3],
            sex = input[4],
            height = input[5]
        }
        
        -- Create character on server
        local result = AS.Client.TriggerCallback('as-spawn:server:createCharacter', characterData)
        
        if result.success then
            -- Open appearance customization
            if Config.Spawn.Appearance.EnableCustomization then
                OpenAppearanceMenu(characterData, result.charId, function(success)
                    if success then
                        exports['as-core']:ShowNotification({
                            title = 'Character Created',
                            description = 'Your character has been created successfully',
                            type = 'success'
                        })
                        
                        if onComplete then
                            onComplete()
                        end
                    end
                end)
            else
                exports['as-core']:ShowNotification({
                    title = 'Character Created',
                    description = 'Your character has been created successfully',
                    type = 'success'
                })
                
                if onComplete then
                    onComplete()
                end
            end
        else
            exports['as-core']:ShowNotification({
                title = 'Error',
                description = result.message or 'Failed to create character',
                type = 'error'
            })
        end
    end
end

-- Show character selection menu
function ShowCharacterSelection(characters)
    local options = {}
    
    -- Add existing characters
    for _, char in ipairs(characters) do
        table.insert(options, {
            title = char.firstname .. ' ' .. char.lastname,
            description = 'DOB: ' .. char.dateofbirth .. ' | Gender: ' .. (char.sex == 'M' and 'Male' or 'Female'),
            icon = 'user',
            onSelect = function()
                selectedCharId = char.char_id
                TriggerServerEvent('as-spawn:server:selectCharacter', char.char_id)
            end,
            metadata = {
                {label = 'Character ID', value = char.char_id}
            }
        })
    end
    
    -- Add create new character option if not at max
    if #characters < Config.Player.MaxCharacters then
        table.insert(options, {
            title = 'Create New Character',
            description = 'Create a new character (' .. #characters .. '/' .. Config.Player.MaxCharacters .. ')',
            icon = 'user-plus',
            onSelect = function()
                ShowCharacterCreation(function()
                    -- Reload character selection
                    Wait(500)
                    InitializeCharacterSelection()
                end)
            end
        })
    end
    
    -- Register and show context menu
    exports['as-core']:ShowContext({
        id = 'character_selection',
        title = 'Select Your Character',
        options = options,
        onExit = function()
            -- Prevent closing without selecting
            if not selectedCharId then
                exports['as-core']:ShowContext({
                    id = 'character_selection',
                    title = 'Select Your Character',
                    options = options
                })
            end
        end
    })
end

-- Initialize character selection
function InitializeCharacterSelection()
    if not Config.Player.EnableMultiChar then
        -- Skip character selection and load directly
        TriggerServerEvent('as-core:server:loadPlayer')
        return
    end
    
    inCharSelection = true
    local ped = PlayerPedId()
    
    -- Freeze player
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, false)
    SetEntityInvincible(ped, true)
    
    -- Fade out
    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    
    -- Set player to safe location
    SetEntityCoords(ped, Config.Spawn.Camera.coords.x, Config.Spawn.Camera.coords.y, Config.Spawn.Camera.coords.z, false, false, false, false)
    
    -- Create camera
    local cam = CreateCharSelectionCamera()
    
    -- Fade in
    Wait(500)
    DoScreenFadeIn(1000)
    
    -- Get characters from server
    local characters = AS.Client.TriggerCallback('as-spawn:server:getCharacters')
    
    -- Show character selection
    Wait(500)
    ShowCharacterSelection(characters)
end

-- Start character selection on resource start
CreateThread(function()
    -- Wait for network to be active
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    
    -- Wait for as-core to be ready
    while GetResourceState('as-core') ~= 'started' do
        Wait(100)
    end
    
    -- Initialize character selection
    Wait(1000)
    InitializeCharacterSelection()
end)

-- Handle player loaded event from as-core
AddEventHandler('as-core:client:playerLoaded', function(playerData)
    if inCharSelection then
        inCharSelection = false
        
        -- Player loaded, now show spawn selection
        Wait(500)
        exports['as-spawn']:InitializeSpawnSelection()
    end
end)

print('^2[AS-SPAWN]^7 Client characters module loaded')
