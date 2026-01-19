Config = Config or {}

Config.Admin = {}

-- Admin permission levels
Config.Admin.Permissions = {
    moderator = {
        ace = 'as.moderator',
        jobs = {'moderator'},
        level = 1
    },
    admin = {
        ace = 'as.admin',
        jobs = {'admin'},
        level = 2
    },
    superadmin = {
        ace = 'as.superadmin',
        jobs = {'superadmin'},
        level = 3
    }
}

-- Menu keybind
Config.Admin.MenuKey = GetConvar('as_admin_menu_key', 'F10')

-- Enable features by permission level
Config.Admin.Features = {
    -- Level 1 - Moderator
    kickPlayer = 1,
    freezePlayer = 1,
    spectatePlayer = 1,
    sendAnnouncement = 1,
    teleportToPlayer = 1,
    teleportToWaypoint = 1,
    
    -- Level 2 - Admin
    banPlayer = 2,
    unbanPlayer = 2,
    revivePlayer = 2,
    healPlayer = 2,
    giveItem = 2,
    giveMoney = 2,
    setJob = 2,
    spawnVehicle = 2,
    deleteVehicle = 2,
    clearArea = 2,
    weatherControl = 2,
    timeControl = 2,
    
    -- Level 3 - Superadmin
    giveWeapon = 3,
    executeCode = 3,
    manageResources = 3,
    serverShutdown = 3
}

-- Vehicle spawning
Config.Admin.VehicleSpawning = {
    spawnInside = true,
    deleteOldVehicle = true,
    maxVehiclesPerPlayer = 5
}

-- Player management
Config.Admin.PlayerManagement = {
    defaultBanDuration = 0, -- 0 = permanent
    kickReason = 'Kicked by admin',
    banReason = 'Banned by admin'
}

-- Teleport settings
Config.Admin.Teleport = {
    fadeScreen = true,
    fadeDuration = 500
}

-- Weather options
Config.Admin.Weather = {
    'EXTRASUNNY',
    'CLEAR',
    'NEUTRAL',
    'SMOG',
    'FOGGY',
    'OVERCAST',
    'CLOUDS',
    'CLEARING',
    'RAIN',
    'THUNDER',
    'SNOW',
    'BLIZZARD',
    'SNOWLIGHT',
    'XMAS',
    'HALLOWEEN'
}

-- Quick teleport locations
Config.Admin.TeleportLocations = {
    {label = 'LSPD', coords = vector3(441.07, -981.82, 30.68)},
    {label = 'Pillbox Hospital', coords = vector3(304.27, -600.33, 43.28)},
    {label = 'Airport', coords = vector3(-1035.71, -2731.87, 12.86)},
    {label = 'Sandy Shores', coords = vector3(1965.52, 3744.95, 32.34)},
    {label = 'Paleto Bay', coords = vector3(-105.62, 6472.05, 31.62)},
    {label = 'Maze Bank', coords = vector3(-75.5, -818.5, 326.0)},
    {label = 'Fort Zancudo', coords = vector3(-2047.99, 3132.13, 32.81)},
    {label = 'Luxury Car Dealer', coords = vector3(-33.803, -1102.44, 26.42)}
}

-- Logging
Config.Admin.Logging = {
    enabled = true,
    webhook = GetConvar('as_admin_webhook', ''),
    color = 3447003 -- Blue
}
