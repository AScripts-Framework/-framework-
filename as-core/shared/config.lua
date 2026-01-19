Config = {}

-- Framework Settings
Config.Framework = {
    Name = 'AS Framework',
    Version = '1.0.0',
    UpdateCheck = true
}

-- Database Settings
Config.Database = {
    UseOxMySQL = true,
    AutoSave = true,
    AutoSaveInterval = 300000 -- 5 minutes in ms
}

-- Player Settings
Config.Player = {
    DefaultMoney = {
        cash = 5000,
        bank = 25000
    },
    MaxPlayers = 64,
    EnableMultiChar = true,
    MaxCharacters = 5,
    StartingLocation = vector4(-1035.71, -2731.87, 12.86, 0.0)
}

-- Job Settings
Config.Jobs = {
    Default = 'unemployed',
    MaxGrade = 10
}

-- Inventory Settings
Config.Inventory = {
    UseOxInventory = true,
    DefaultSlots = 40,
    DefaultWeight = 100000 -- grams
}

-- Vehicle Settings
Config.Vehicle = {
    EnableKeys = true,
    EnableGarages = true,
    DespawnTimer = 3600000 -- 1 hour
}

-- Interaction Settings
Config.UseTarget = GetConvarInt('as_use_target', 1) == 1 -- Use as-target for interactions (true) or 3D text/markers (false)

-- Debug Settings
Config.Debug = GetConvarInt('as_core_debug', 0) == 1

-- Debug Settings
Config.Debug = false

-- Locale Settings
Config.Locale = 'en'
