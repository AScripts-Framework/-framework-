Config = Config or {}

Config.HUD = {}

-- Default HUD settings
Config.HUD.Defaults = {
    position = 'bottom-left', -- bottom-left, bottom-right, top-left, top-right
    scale = 1.0, -- 0.5 to 2.0
    offsetX = 20, -- pixels from edge
    offsetY = 0, -- pixels from edge
    showHealth = true,
    showArmor = true,
    showStamina = true,
    iconStyle = 'modern', -- modern, classic, minimal
    colorTheme = 'purple', -- purple, blue, red, green, custom
    customColor = '#8B5CF6', -- If colorTheme is 'custom'
    
    -- Vehicle HUD settings
    vehiclePosition = 'bottom-center', -- bottom-left, bottom-center, bottom-right, top-left, top-center, top-right
    vehicleScale = 1.0, -- 0.5 to 2.0
    vehicleOffsetX = 0, -- pixels from edge/center
    vehicleOffsetY = 0 -- pixels from edge
}

-- Update intervals (milliseconds)
Config.HUD.UpdateInterval = GetConvarInt('as_hud_update_interval', 250)

-- Minimap settings
Config.HUD.Minimap = {
    enableDynamicMinimap = true, -- Show/hide minimap based on vehicle
    roundedMinimap = false,
    minimapOffset = {
        x = -10,
        y = -10
    }
}

-- Icon styles
Config.HUD.Icons = {
    modern = {
        health = 'fa-heart',
        armor = 'fa-shield-halved',
        stamina = 'fa-person-running'
    },
    classic = {
        health = 'fa-heart-pulse',
        armor = 'fa-shield',
        stamina = 'fa-gauge-high'
    },
    minimal = {
        health = 'fa-heart',
        armor = 'fa-shield',
        stamina = 'fa-circle'
    }
}

-- Color themes
Config.HUD.Colors = {
    purple = {
        primary = '#8B5CF6',
        secondary = '#A78BFA',
        background = 'rgba(88, 28, 135, 0.4)',
        text = '#E9D5FF'
    },
    blue = {
        primary = '#3B82F6',
        secondary = '#60A5FA',
        background = 'rgba(30, 64, 175, 0.4)',
        text = '#DBEAFE'
    },
    red = {
        primary = '#EF4444',
        secondary = '#F87171',
        background = 'rgba(127, 29, 29, 0.4)',
        text = '#FEE2E2'
    },
    green = {
        primary = '#10B981',
        secondary = '#34D399',
        background = 'rgba(6, 78, 59, 0.4)',
        text = '#D1FAE5'
    }
}

-- Settings menu keybind
Config.HUD.SettingsKey = GetConvar('as_hud_settings_key', 'F9')
