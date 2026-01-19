Config = Config or {}

-- Spawn System Configuration
Config.Spawn = {}

-- Multicharacter settings
Config.Spawn.EnableMulticharacter = GetConvarInt('as_spawn_multicharacter', 1) == 1
Config.Spawn.MaxCharacters = GetConvarInt('as_spawn_max_characters', 5)

-- Default spawn location (if player has no saved location)
Config.Spawn.DefaultSpawn = {
    coords = vector4(-1035.71, -2731.87, 12.86, 0.0),
    label = "Los Santos Airport"
}

-- Available spawn locations
Config.Spawn.Locations = {
    {
        id = 'airport',
        label = 'Los Santos Airport',
        coords = vector4(-1035.71, -2731.87, 12.86, 0.0),
        icon = 'plane',
        public = true
    },
    {
        id = 'sandy',
        label = 'Sandy Shores',
        coords = vector4(1965.52, 3744.95, 32.34, 300.0),
        icon = 'warehouse',
        public = true
    },
    {
        id = 'paleto',
        label = 'Paleto Bay',
        coords = vector4(-105.62, 6472.05, 31.62, 135.0),
        icon = 'mountain',
        public = true
    },
    {
        id = 'downtown',
        label = 'Downtown Los Santos',
        coords = vector4(228.15, -877.87, 30.49, 160.0),
        icon = 'city',
        public = true
    },
    {
        id = 'vespucci',
        label = 'Vespucci Beach',
        coords = vector4(-1201.59, -1586.24, 4.61, 125.0),
        icon = 'umbrella-beach',
        public = true
    },
    {
        id = 'last_location',
        label = 'Last Location',
        coords = nil, -- Will be set from player data
        icon = 'location-dot',
        public = true,
        isLastLocation = true
    }
}

-- Job-specific spawn locations
Config.Spawn.JobLocations = {
    police = {
        {
            id = 'mrpd',
            label = 'Mission Row PD',
            coords = vector4(441.07, -981.82, 30.68, 180.0),
            icon = 'building-shield',
            minGrade = 0
        },
        {
            id = 'sandy_pd',
            label = 'Sandy Shores PD',
            coords = vector4(1852.91, 3689.5, 34.27, 210.0),
            icon = 'building-shield',
            minGrade = 0
        }
    },
    ambulance = {
        {
            id = 'pillbox',
            label = 'Pillbox Hospital',
            coords = vector4(304.27, -600.33, 43.28, 270.0),
            icon = 'house-medical',
            minGrade = 0
        },
        {
            id = 'sandy_medical',
            label = 'Sandy Shores Medical',
            coords = vector4(1839.6, 3672.93, 34.28, 210.0),
            icon = 'house-medical',
            minGrade = 0
        }
    },
    mechanic = {
        {
            id = 'bennys',
            label = "Benny's Garage",
            coords = vector4(-212.13, -1324.78, 30.89, 270.0),
            icon = 'wrench',
            minGrade = 0
        }
    }
}

-- Character creation defaults
Config.Spawn.CharacterDefaults = {
    startMoney = {
        cash = GetConvarInt('as_spawn_starting_money', 5000),
        bank = 25000
    },
    startJob = 'unemployed',
    startJobGrade = 0
}

-- Camera settings for character selection
Config.Spawn.Camera = {
    coords = vector3(-1355.89, -1487.78, 520.0),
    rotation = vector3(-10.0, 0.0, 230.0),
    fov = 30.0
}

-- Spawn system settings
Config.Spawn.FadeInTime = 2000 -- ms
Config.Spawn.FreezeOnSpawn = 3000 -- ms

-- Appearance system settings
Config.Spawn.Appearance = {
    -- Will auto-detect which appearance system is running
    -- Priority: fivem-appearance > illenium-appearance
    EnableCustomization = true,
    
    -- Appearance coordinates for character creation
    CreationCoords = vector4(402.92, -996.87, -99.00, 180.0)
}
