# AS-Fuel

**AS Framework Fuel System** - Comprehensive fuel and electric vehicle battery management.

## Features

- **Realistic Fuel Consumption** - Vehicle-specific consumption rates
- **Electric Vehicle Support** - Battery drain for electric vehicles
- **Fuel Stations** - 24 gas stations and 5 charging stations across the map
- **Station Blips** - Optional map markers for fuel/charging stations
- **Entity State Persistence** - Fuel levels persist across resource restarts
- **Export Integration** - Easy integration with other resources (HUD, etc.)
- **Configurable** - All settings via convars

## Installation

1. Add `as-fuel` to your resources folder
2. Ensure dependencies are started first
3. Add to `server.cfg`:
   ```cfg
   ensure as-core
   ensure as-fuel
   ```

## Configuration

Settings are in `as-core/convars.cfg`:

```cfg
# Fuel consumption rate multiplier (default: 1.0)
set as_fuel_consumption_rate 1.0

# Electric vehicle battery drain multiplier (default: 1.0)
set as_fuel_electric_drain_rate 1.0

# Show fuel blips on map (0 = off, 1 = on)
set as_fuel_show_blips 1

# Fuel price per liter
set as_fuel_price_per_liter 5
```

## Usage

### Exports

```lua
-- Get vehicle fuel level (0-100)
local fuel = exports['as-fuel']:GetVehicleFuel(vehicle)

-- Set vehicle fuel level
exports['as-fuel']:SetVehicleFuel(vehicle, 75.0)

-- Check if vehicle is electric
local isElectric = exports['as-fuel']:IsElectricVehicle(vehicle)
```

### Vehicle Classes

Fuel consumption varies by vehicle class:
- **Compacts** - 0.8x consumption
- **Sedans** - 1.0x consumption
- **SUVs** - 1.3x consumption
- **Sports** - 1.5x consumption
- **Super** - 2.0x consumption
- **Motorcycles** - 0.6x consumption
- **Bicycles** - 0.0x (no fuel)

### Electric Vehicles

Pre-configured electric vehicles:
- `voltic`
- `raiden`
- `cyclone`
- `tezeract`
- `dilettante`
- `surge`
- `khamelion`
- `neon`

Add more in `shared/config.lua`:

```lua
Config.ElectricVehicles = {
    ['model_name'] = true,
}
```

## Fuel Stations

### Gas Stations (24 locations)

- Downtown Los Santos
- Vespucci Beach
- Del Perro
- Little Seoul
- La Mesa
- El Rancho Blvd
- Route 68
- Great Ocean Highway
- And more...

### Charging Stations (5 locations)

- LifeInvader Parking
- Legion Square Parking
- Rockford Plaza
- Vinewood Hills
- Pacific Bluffs

## Integration

Integrate with your HUD:

```lua
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
if vehicle ~= 0 then
    local fuel = exports['as-fuel']:GetVehicleFuel(vehicle)
    local isElectric = exports['as-fuel']:IsElectricVehicle(vehicle)
    
    -- Update HUD with fuel level
    -- isElectric determines if it's fuel or battery
end
```

## Events

```lua
-- Client-side events
AddEventHandler('as-fuel:refueling', function(vehicle, amount)
    -- Called during refueling
end)

AddEventHandler('as-fuel:refuelComplete', function(vehicle, totalCost)
    -- Called when refueling is complete
end)
```

## Dependencies

- [as-core](../as-core) - Framework core
- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)

## License

MIT License - See LICENSE file for details