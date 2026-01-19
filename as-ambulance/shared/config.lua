Config = {}

-- General Settings
Config.MenuKey = 'F6' -- Key to open ambulance menu when on duty
Config.RespawnTime = 300 -- Time in seconds before player can respawn (5 minutes)
Config.LastStandTime = 60 -- Time in seconds in last stand before death (1 minute)
Config.EnableLastStand = true -- Allow players to be in last stand before dying
Config.RemoveItemsOnDeath = false -- Remove items from inventory on death
Config.RespawnAtHospital = true -- Respawn at nearest hospital or last location

-- Job Settings
Config.JobName = 'ambulance'
Config.MinimumAmbulance = 0 -- Minimum EMS online to allow self-respawn
Config.ReviveReward = 500 -- Money reward for reviving a player
Config.HealPrice = 100 -- Price to heal at hospital when no EMS online

-- Hospitals
Config.Hospitals = {
    {
        name = 'Pillbox Hill Medical Center',
        coords = vector3(307.7, -595.1, 43.3),
        heading = 68.0,
        blip = {
            sprite = 61,
            color = 2,
            scale = 0.8,
            label = 'Hospital'
        },
        -- Interaction points
        checkIn = vector3(308.5, -595.4, 43.3), -- Walk-in check in
        duty = vector3(313.4, -599.0, 43.3), -- Clock in/out
        garage = vector3(294.2, -574.3, 43.2), -- Vehicle spawn
        garageHeading = 68.0,
        stash = vector3(306.4, -601.7, 43.3), -- Medical supplies storage
    },
    {
        name = 'Sandy Shores Medical Center',
        coords = vector3(1839.6, 3672.9, 34.3),
        heading = 210.0,
        blip = {
            sprite = 61,
            color = 2,
            scale = 0.8,
            label = 'Hospital'
        },
        checkIn = vector3(1839.6, 3672.9, 34.3),
        duty = vector3(1842.3, 3674.5, 34.3),
        garage = vector3(1869.3, 3696.6, 33.6),
        garageHeading = 210.0,
        stash = vector3(1843.8, 3670.0, 34.3),
    },
    {
        name = 'Paleto Bay Medical Center',
        coords = vector3(-254.8, 6324.5, 32.4),
        heading = 315.0,
        blip = {
            sprite = 61,
            color = 2,
            scale = 0.8,
            label = 'Hospital'
        },
        checkIn = vector3(-254.8, 6324.5, 32.4),
        duty = vector3(-253.0, 6326.0, 32.4),
        garage = vector3(-261.2, 6315.5, 32.5),
        garageHeading = 315.0,
        stash = vector3(-256.0, 6321.0, 32.4),
    }
}

-- Ambulance Vehicles
Config.Vehicles = {
    {label = 'Ambulance', model = 'ambulance', price = 0},
}

-- Medical Items (from ox_inventory or your inventory system)
Config.ReviveItem = 'defib' -- Item required to revive players
Config.BandageItem = 'bandage' -- Item to heal minor injuries
Config.MedkitItem = 'medkit' -- Item to fully heal

-- Medical Supplies (can be taken from stash)
Config.MedicalSupplies = {
    {item = 'bandage', label = 'Bandage', price = 10},
    {item = 'medkit', label = 'Medical Kit', price = 50},
    {item = 'defib', label = 'Defibrillator', price = 100},
}

-- Revive Settings
Config.ReviveHealth = 200 -- Health after being revived
Config.ReviveDistance = 3.0 -- Distance to revive player

-- Animations
Config.DeathAnimation = {
    dict = 'dead',
    anim = 'dead_a',
}

Config.ReviveAnimation = {
    dict = 'mini@cpr@char_a@cpr_str',
    anim = 'cpr_pumpchest',
    duration = 5000, -- 5 seconds
}

-- Pain/Injury System (optional)
Config.EnablePainSystem = false -- Enable pain effects when health is low
Config.PainThreshold = 100 -- Health below this triggers pain effects

-- Logging
Config.EnableLogging = true
Config.WebhookURL = '' -- Discord webhook for logging revives/deaths
