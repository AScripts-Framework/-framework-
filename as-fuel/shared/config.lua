Config = Config or {}

Config.Fuel = {}

-- Fuel consumption settings
Config.Fuel.ConsumptionRate = GetConvarInt('as_fuel_consumption_rate', 1.0) -- Multiplier for fuel consumption (higher = faster consumption)
Config.Fuel.IdleConsumption = 0.1 -- Fuel consumed per second while idling
Config.Fuel.MaxConsumption = 2.5 -- Maximum fuel consumption per second

-- Electric vehicle settings
Config.Fuel.ElectricVehicles = {
    -- Vehicle models that use electricity instead of fuel
    [`neon`] = true,
    [`cyclone`] = true,
    [`raiden`] = true,
    [`voltic`] = true,
    [`voltic2`] = true,
    [`tezeract`] = true,
    [`imorgon`] = true,
    [`dilettante`] = true,
    [`surge`] = true,
    -- Add more electric vehicle models here
}

-- Battery consumption for electric vehicles (generally slower than fuel)
Config.Fuel.BatteryConsumptionRate = GetConvarInt('as_fuel_electric_drain_rate', 0.5)

-- Vehicle class multipliers (affects consumption rate)
Config.Fuel.ClassMultipliers = {
    [0] = 1.0,  -- Compacts
    [1] = 1.0,  -- Sedans
    [2] = 1.2,  -- SUVs
    [3] = 1.0,  -- Coupes
    [4] = 1.3,  -- Muscle
    [5] = 1.1,  -- Sports Classics
    [6] = 1.4,  -- Sports
    [7] = 1.6,  -- Super
    [8] = 0.6,  -- Motorcycles
    [9] = 1.5,  -- Off-road
    [10] = 2.0, -- Industrial
    [11] = 1.2, -- Utility
    [12] = 1.3, -- Vans
    [13] = 0.0, -- Cycles (no fuel)
    [14] = 1.8, -- Boats
    [15] = 2.5, -- Helicopters
    [16] = 3.0, -- Planes
    [17] = 1.0, -- Service
    [18] = 2.0, -- Emergency
    [19] = 1.5, -- Military
    [20] = 2.5, -- Commercial
    [21] = 0.0, -- Trains (no fuel)
}

-- Refueling settings
Config.Fuel.RefuelPrice = GetConvarInt('as_fuel_price_per_liter', 2.5) -- Price per liter of fuel
Config.Fuel.ChargingPrice = 1.5 -- Price per unit of electricity (cheaper than fuel)
Config.Fuel.RefuelRate = 1.0 -- Liters per second when refueling
Config.Fuel.ChargingRate = 1.5 -- Battery units per second when charging (faster)

-- Jerry can settings
Config.Fuel.JerryCanCapacity = 20.0 -- Liters
Config.Fuel.JerryCanRefuelRate = 0.5 -- Liters per second

-- Show fuel HUD
Config.Fuel.ShowHUD = true

-- Fuel stations (gas stations)
Config.Fuel.GasStations = {
    -- Los Santos
    {coords = vector3(49.4187, 2778.793, 58.043), radius = 10.0, type = 'fuel'},
    {coords = vector3(263.894, 2606.463, 44.983), radius = 10.0, type = 'fuel'},
    {coords = vector3(1039.958, 2671.134, 39.550), radius = 10.0, type = 'fuel'},
    {coords = vector3(1207.260, 2660.175, 37.899), radius = 10.0, type = 'fuel'},
    {coords = vector3(2539.685, 2594.192, 37.944), radius = 10.0, type = 'fuel'},
    {coords = vector3(2679.858, 3263.946, 55.240), radius = 10.0, type = 'fuel'},
    {coords = vector3(2005.055, 3773.887, 32.403), radius = 10.0, type = 'fuel'},
    {coords = vector3(1687.156, 4929.392, 42.078), radius = 10.0, type = 'fuel'},
    {coords = vector3(1701.314, 6416.028, 32.763), radius = 10.0, type = 'fuel'},
    {coords = vector3(179.857, 6602.839, 31.868), radius = 10.0, type = 'fuel'},
    {coords = vector3(-94.4619, 6419.594, 31.489), radius = 10.0, type = 'fuel'},
    {coords = vector3(-2554.996, 2334.40, 33.078), radius = 10.0, type = 'fuel'},
    {coords = vector3(-1800.375, 803.661, 138.651), radius = 10.0, type = 'fuel'},
    {coords = vector3(-1437.622, -276.747, 46.207), radius = 10.0, type = 'fuel'},
    {coords = vector3(-2096.243, -320.286, 13.168), radius = 10.0, type = 'fuel'},
    {coords = vector3(-724.619, -935.1631, 19.213), radius = 10.0, type = 'fuel'},
    {coords = vector3(-526.019, -1211.003, 18.184), radius = 10.0, type = 'fuel'},
    {coords = vector3(-70.2148, -1761.792, 29.534), radius = 10.0, type = 'fuel'},
    {coords = vector3(265.648, -1261.309, 29.292), radius = 10.0, type = 'fuel'},
    {coords = vector3(819.653, -1028.846, 26.403), radius = 10.0, type = 'fuel'},
    {coords = vector3(1208.951, -1402.567, 35.224), radius = 10.0, type = 'fuel'},
    {coords = vector3(1181.381, -330.847, 69.316), radius = 10.0, type = 'fuel'},
    {coords = vector3(620.843, 269.100, 103.089), radius = 10.0, type = 'fuel'},
    {coords = vector3(2581.321, 362.039, 108.468), radius = 10.0, type = 'fuel'},
}

-- Electric charging stations (fewer locations)
Config.Fuel.ChargingStations = {
    {coords = vector3(-2096.243, -320.286, 13.168), radius = 8.0, type = 'electric'},
    {coords = vector3(265.648, -1261.309, 29.292), radius = 8.0, type = 'electric'},
    {coords = vector3(1181.381, -330.847, 69.316), radius = 8.0, type = 'electric'},
    {coords = vector3(-1437.622, -276.747, 46.207), radius = 8.0, type = 'electric'},
    {coords = vector3(179.857, 6602.839, 31.868), radius = 8.0, type = 'electric'},
}

-- Blip settings
Config.Fuel.GasStationBlip = {
    sprite = 361,
    color = 1,
    scale = 0.8,
    label = 'Gas Station'
}

Config.Fuel.ChargingStationBlip = {
    sprite = 354,
    color = 2,
    scale = 0.8,
    label = 'Charging Station'
}

-- Show blips on map
Config.Fuel.ShowBlips = GetConvarInt('as_fuel_show_blips', 1) == 1
