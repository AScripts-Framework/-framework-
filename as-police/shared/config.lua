Config = Config or {}

-- Police Job Settings
Config.PoliceJobs = {
    'police',
    'sheriff'
}

Config.MinimumPolice = 0 -- Minimum police required for certain actions

-- Police Stations
Config.Stations = {
    mission_row = {
        name = 'Mission Row PD',
        blip = {coords = vector3(425.13, -979.56, 30.71), sprite = 60, color = 29, scale = 0.8},
        duty = {
            coords = vector3(441.79, -982.08, 30.69),
            heading = 180.0
        },
        armory = {
            coords = vector3(452.65, -980.05, 30.69),
            heading = 180.0
        },
        garage = {
            vehicle = vector4(438.42, -1018.31, 28.62, 90.0),
            heli = vector4(449.21, -981.23, 43.69, 180.0)
        },
        evidence = {
            coords = vector3(475.06, -996.88, 26.27),
            heading = 270.0
        }
    },
    vespucci = {
        name = 'Vespucci PD',
        blip = {coords = vector3(-1096.02, -834.89, 19.0), sprite = 60, color = 29, scale = 0.8},
        duty = {
            coords = vector3(-1096.02, -834.89, 19.0),
            heading = 180.0
        },
        armory = {
            coords = vector3(-1106.43, -827.13, 19.32),
            heading = 180.0
        },
        garage = {
            vehicle = vector4(-1071.42, -851.35, 4.88, 217.0),
            heli = vector4(-1096.02, -834.89, 37.7, 180.0)
        },
        evidence = {
            coords = vector3(-1095.23, -827.66, 14.28),
            heading = 270.0
        }
    },
    sandy = {
        name = 'Sandy Shores Sheriff',
        blip = {coords = vector3(1853.24, 3689.93, 34.27), sprite = 60, color = 29, scale = 0.8},
        duty = {
            coords = vector3(1853.24, 3689.93, 34.27),
            heading = 210.0
        },
        armory = {
            coords = vector3(1849.65, 3695.27, 34.27),
            heading = 210.0
        },
        garage = {
            vehicle = vector4(1868.39, 3696.58, 33.53, 210.0),
            heli = vector4(1853.24, 3689.93, 40.0, 210.0)
        },
        evidence = {
            coords = vector3(1848.82, 3690.45, 34.27),
            heading = 210.0
        }
    },
    paleto = {
        name = 'Paleto Bay Sheriff',
        blip = {coords = vector3(-447.14, 6013.62, 31.72), sprite = 60, color = 29, scale = 0.8},
        duty = {
            coords = vector3(-447.14, 6013.62, 31.72),
            heading = 315.0
        },
        armory = {
            coords = vector3(-450.23, 6006.03, 31.72),
            heading = 315.0
        },
        garage = {
            vehicle = vector4(-475.43, 6027.52, 31.34, 225.0),
            heli = vector4(-447.14, 6013.62, 40.0, 315.0)
        },
        evidence = {
            coords = vector3(-443.72, 6015.23, 31.72),
            heading = 315.0
        }
    }
}

-- Weapons (ox_inventory compatible)
Config.Weapons = {
    recruit = {
        {name = 'WEAPON_NIGHTSTICK', label = 'Nightstick', price = 0},
        {name = 'WEAPON_FLASHLIGHT', label = 'Flashlight', price = 0},
        {name = 'WEAPON_STUNGUN', label = 'Taser', price = 0},
        {name = 'WEAPON_PISTOL', label = 'Pistol', price = 0, ammo = 'ammo-9'},
    },
    officer = {
        {name = 'WEAPON_NIGHTSTICK', label = 'Nightstick', price = 0},
        {name = 'WEAPON_FLASHLIGHT', label = 'Flashlight', price = 0},
        {name = 'WEAPON_STUNGUN', label = 'Taser', price = 0},
        {name = 'WEAPON_PISTOL', label = 'Pistol', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_CARBINERIFLE', label = 'Carbine Rifle', price = 0, ammo = 'ammo-rifle'},
    },
    sergeant = {
        {name = 'WEAPON_NIGHTSTICK', label = 'Nightstick', price = 0},
        {name = 'WEAPON_FLASHLIGHT', label = 'Flashlight', price = 0},
        {name = 'WEAPON_STUNGUN', label = 'Taser', price = 0},
        {name = 'WEAPON_PISTOL', label = 'Pistol', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_CARBINERIFLE', label = 'Carbine Rifle', price = 0, ammo = 'ammo-rifle'},
        {name = 'WEAPON_PUMPSHOTGUN', label = 'Pump Shotgun', price = 0, ammo = 'ammo-shotgun'},
    },
    lieutenant = {
        {name = 'WEAPON_NIGHTSTICK', label = 'Nightstick', price = 0},
        {name = 'WEAPON_FLASHLIGHT', label = 'Flashlight', price = 0},
        {name = 'WEAPON_STUNGUN', label = 'Taser', price = 0},
        {name = 'WEAPON_PISTOL', label = 'Pistol', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_CARBINERIFLE', label = 'Carbine Rifle', price = 0, ammo = 'ammo-rifle'},
        {name = 'WEAPON_PUMPSHOTGUN', label = 'Pump Shotgun', price = 0, ammo = 'ammo-shotgun'},
        {name = 'WEAPON_SMG', label = 'SMG', price = 0, ammo = 'ammo-9'},
    },
    chief = {
        {name = 'WEAPON_NIGHTSTICK', label = 'Nightstick', price = 0},
        {name = 'WEAPON_FLASHLIGHT', label = 'Flashlight', price = 0},
        {name = 'WEAPON_STUNGUN', label = 'Taser', price = 0},
        {name = 'WEAPON_PISTOL', label = 'Pistol', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_COMBATPISTOL', label = 'Combat Pistol', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_CARBINERIFLE', label = 'Carbine Rifle', price = 0, ammo = 'ammo-rifle'},
        {name = 'WEAPON_PUMPSHOTGUN', label = 'Pump Shotgun', price = 0, ammo = 'ammo-shotgun'},
        {name = 'WEAPON_SMG', label = 'SMG', price = 0, ammo = 'ammo-9'},
        {name = 'WEAPON_SNIPERRIFLE', label = 'Sniper Rifle', price = 0, ammo = 'ammo-rifle'},
    }
}

-- Equipment (ox_inventory compatible)
Config.Equipment = {
    {name = 'handcuffs', label = 'Handcuffs', price = 0},
    {name = 'radio', label = 'Radio', price = 0},
    {name = 'armor', label = 'Body Armor', price = 0},
    {name = 'bandage', label = 'Bandage', price = 0},
    {name = 'medkit', label = 'Medkit', price = 0},
    {name = 'repairkit', label = 'Repair Kit', price = 0},
    {name = 'evidence_bag', label = 'Evidence Bag', price = 0},
    {name = 'police_stormram', label = 'Battering Ram', price = 0},
    {name = 'spikestrip', label = 'Spike Strip', price = 0},
}

-- Police Vehicles
Config.Vehicles = {
    recruit = {
        {model = 'police', label = 'Police Cruiser', livery = 0, extras = {}},
    },
    officer = {
        {model = 'police', label = 'Police Cruiser', livery = 0, extras = {}},
        {model = 'police2', label = 'Police Cruiser 2', livery = 0, extras = {}},
    },
    sergeant = {
        {model = 'police', label = 'Police Cruiser', livery = 0, extras = {}},
        {model = 'police2', label = 'Police Cruiser 2', livery = 0, extras = {}},
        {model = 'police3', label = 'Police Cruiser 3', livery = 0, extras = {}},
        {model = 'policeb', label = 'Police Bike', livery = 0, extras = {}},
    },
    lieutenant = {
        {model = 'police', label = 'Police Cruiser', livery = 0, extras = {}},
        {model = 'police2', label = 'Police Cruiser 2', livery = 0, extras = {}},
        {model = 'police3', label = 'Police Cruiser 3', livery = 0, extras = {}},
        {model = 'police4', label = 'Unmarked Cruiser', livery = 0, extras = {}},
        {model = 'policeb', label = 'Police Bike', livery = 0, extras = {}},
    },
    chief = {
        {model = 'police', label = 'Police Cruiser', livery = 0, extras = {}},
        {model = 'police2', label = 'Police Cruiser 2', livery = 0, extras = {}},
        {model = 'police3', label = 'Police Cruiser 3', livery = 0, extras = {}},
        {model = 'police4', label = 'Unmarked Cruiser', livery = 0, extras = {}},
        {model = 'policeb', label = 'Police Bike', livery = 0, extras = {}},
        {model = 'riot', label = 'SWAT Van', livery = 0, extras = {}},
        {model = 'polmav', label = 'Police Helicopter', livery = 0, extras = {}},
    }
}

-- Jail System
Config.Jail = {
    coords = vector3(1641.91, 2571.14, 45.56),
    cells = {
        vector4(1641.91, 2571.14, 45.56, 180.0),
        vector4(1637.52, 2571.14, 45.56, 180.0),
        vector4(1633.13, 2571.14, 45.56, 180.0),
        vector4(1628.74, 2571.14, 45.56, 180.0),
    },
    release = vector4(1847.12, 2585.95, 45.67, 270.0),
    maxTime = 300, -- Maximum jail time in months (5 minutes per month)
}

-- Evidence System
Config.Evidence = {
    types = {
        'bullet_casing',
        'blood_sample',
        'fingerprint',
        'dna_sample',
        'photo_evidence',
        'item_evidence'
    },
    despawnTime = 600, -- 10 minutes
    enableBloodTrails = true,
    enableBulletCasings = true,
    enableFingerprints = true,
}

-- Dispatch System
Config.Dispatch = {
    alerts = {
        shooting = {label = 'Shots Fired', code = '10-71', sprite = 110, color = 1, blipTime = 60},
        speeding = {label = 'Speeding Vehicle', code = '10-40', sprite = 225, color = 17, blipTime = 45},
        robbery = {label = 'Robbery', code = '10-90', sprite = 374, color = 1, blipTime = 90},
        carjacking = {label = 'Car Jacking', code = '10-35', sprite = 595, color = 1, blipTime = 60},
        assault = {label = 'Assault', code = '10-10', sprite = 126, color = 1, blipTime = 60},
        kidnapping = {label = 'Kidnapping', code = '10-34', sprite = 432, color = 1, blipTime = 90},
        drugActivity = {label = 'Drug Activity', code = '10-31', sprite = 51, color = 1, blipTime = 60},
    }
}

-- Radar Settings
Config.Radar = {
    maxDistance = 150.0, -- meters
    frontAngle = 45, -- degrees
    rearAngle = 45, -- degrees
    speedLimit = 80, -- mph (for automatic alerts)
}

-- Handcuff Settings
Config.Handcuffs = {
    breakoutChance = 5, -- Percentage chance to break free
    breakoutTime = 120, -- Seconds to attempt breakout
}

-- Interaction Settings
Config.Interactions = {
    searchRadius = 2.0,
    dragSpeed = 1.0,
    carryEnabled = true,
    vehicleSeatEnabled = true,
}

-- MDT Settings
Config.MDT = {
    enableReports = true,
    enableWarrants = true,
    enableBolos = true,
    enablePenalCode = true,
    enableOfficerRoster = true,
}

-- Logging
Config.Logging = {
    discord = {
        webhook = '', -- Your Discord webhook URL
        enabled = false,
    }
}
