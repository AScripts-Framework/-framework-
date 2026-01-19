# AS Target System

Universal target system bridge for AS Framework with support for ox_target and qb-target.

## Features

- 🎯 **Auto-Detection** - Automatically detects and uses ox_target or qb-target
- 🔄 **Universal API** - Single API works with both target systems
- 📦 **Entity Targeting** - Target entities, models, players, and zones
- 🗺️ **Zone Support** - Box zones and circle zones
- ⚙️ **Configurable** - Easy configuration and debug options

## Dependencies

Required:
- [as-core](../as-core) - AS Framework Core

Optional (at least one required):
- [ox_target](https://github.com/overextended/ox_target) (Recommended)
- [qb-target](https://github.com/qbcore-framework/qb-target)

## Installation

1. Ensure you have `as-core` and either `ox_target` or `qb-target` installed
2. Place `as-target` in your resources folder
3. Add to your `server.cfg`:
   ```
   ensure as-core
   ensure ox_target  # or qb-target
   ensure as-target
   ```
4. Configure options in `config.lua`
5. Restart your server

## Configuration

Edit `config.lua`:

```lua
Config.Target = {
    AutoDetect = true,           -- Auto-detect target system
    ForceSystem = nil,           -- Force specific system: 'ox_target' or 'qb-target'
    DefaultDistance = 2.5,       -- Default interaction distance
    Debug = false                -- Enable debug mode
}
```

## Usage

### Get Target Object

```lua
local ASTarget = exports['as-target']:GetTargetObject()
```

### Add Entity Target

Target a specific entity:

```lua
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

exports['as-target']:AddEntity(vehicle, {
    {
        name = 'open_trunk',
        label = 'Open Trunk',
        icon = 'fa-solid fa-box-open',
        onSelect = function()
            print('Opening trunk...')
        end,
        canInteract = function(entity)
            return true
        end,
        distance = 2.5
    }
})
```

### Add Model Target

Target all entities of specific model(s):

```lua
exports['as-target']:AddModel('prop_atm_01', {
    {
        name = 'use_atm',
        label = 'Use ATM',
        icon = 'fa-solid fa-credit-card',
        onSelect = function()
            print('Opening ATM...')
        end,
        distance = 2.0
    }
})

-- Multiple models
exports['as-target']:AddModel({'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}, options)
```

### Add Global Player Target

Target all players:

```lua
exports['as-target']:AddGlobalPlayer({
    {
        name = 'give_money',
        label = 'Give Money',
        icon = 'fa-solid fa-hand-holding-dollar',
        onSelect = function(data)
            local targetPlayer = data.entity
            print('Giving money to player...')
        end,
        distance = 2.5
    }
})
```

### Add Box Zone

Create a box-shaped target zone:

```lua
exports['as-target']:AddBoxZone('shop_counter', vector3(24.5, -1346.5, 29.5), vector3(2.0, 2.0, 2.0), {
    rotation = 0.0,
    targets = {
        {
            name = 'open_shop',
            label = 'Open Shop',
            icon = 'fa-solid fa-shopping-cart',
            onSelect = function()
                print('Opening shop...')
            end
        }
    }
})
```

### Add Circle Zone

Create a circular/spherical target zone:

```lua
exports['as-target']:AddCircleZone('gas_pump', vector3(265.0, -1261.0, 29.0), 2.0, {
    targets = {
        {
            name = 'refuel',
            label = 'Refuel Vehicle',
            icon = 'fa-solid fa-gas-pump',
            onSelect = function()
                print('Refueling...')
            end,
            canInteract = function()
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                return vehicle ~= 0
            end
        }
    }
})
```

### Remove Targets

```lua
-- Remove entity target
exports['as-target']:RemoveEntity(entity)

-- Remove zone
exports['as-target']:RemoveZone('shop_counter')
```

### Check System Status

```lua
-- Check if target system is available
local available = exports['as-target']:IsAvailable()

-- Get current target system name
local system = exports['as-target']:GetCurrentSystem()
print('Using: ' .. system) -- 'ox_target' or 'qb-target'
```

## API Reference

### Exports

| Export | Parameters | Description |
|--------|------------|-------------|
| `AddEntity` | `entity, options` | Add target to specific entity |
| `AddNetworkEntity` | `netId, options` | Add target to network entity |
| `AddModel` | `models, options` | Add target to model(s) |
| `AddGlobalPlayer` | `options` | Add target to all players |
| `AddBoxZone` | `name, coords, size, options` | Add box zone target |
| `AddCircleZone` | `name, coords, radius, options` | Add circle zone target |
| `RemoveEntity` | `entity` | Remove entity target |
| `RemoveZone` | `name` | Remove zone |
| `GetCurrentSystem` | - | Get current target system |
| `IsAvailable` | - | Check if system available |

### Option Structure

```lua
{
    name = 'unique_name',           -- Required: Unique identifier
    label = 'Display Text',         -- Required: Text shown to player
    icon = 'fa-solid fa-hand',      -- Optional: FontAwesome icon
    onSelect = function(data)       -- Required: Function called on interaction
        -- data.entity = target entity
    end,
    canInteract = function(entity)  -- Optional: Check if can interact
        return true
    end,
    distance = 2.5                  -- Optional: Interaction distance
}
```

## Examples

### ATM System

```lua
-- Add ATM targets
exports['as-target']:AddModel({'prop_atm_01', 'prop_atm_02', 'prop_atm_03'}, {
    {
        name = 'atm_withdraw',
        label = 'Withdraw Money',
        icon = 'fa-solid fa-money-bill-wave',
        onSelect = function()
            TriggerEvent('bank:client:openATM')
        end,
        distance = 2.0
    }
})
```

### Vehicle Interaction

```lua
-- Target any vehicle
local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

if vehicle ~= 0 then
    exports['as-target']:AddEntity(vehicle, {
        {
            name = 'flip_vehicle',
            label = 'Flip Vehicle',
            icon = 'fa-solid fa-rotate',
            onSelect = function()
                local coords = GetEntityCoords(vehicle)
                SetEntityCoords(vehicle, coords.x, coords.y, coords.z + 1.0)
                SetEntityRotation(vehicle, 0.0, 0.0, GetEntityHeading(vehicle))
            end
        }
    })
end
```

### Shop Zone

```lua
exports['as-target']:AddBoxZone('shop_24_7', vector3(24.5, -1346.5, 29.5), vector3(3.0, 3.0, 3.0), {
    rotation = 0.0,
    targets = {
        {
            name = 'open_shop',
            label = 'Open 24/7 Shop',
            icon = 'fa-solid fa-basket-shopping',
            onSelect = function()
                TriggerEvent('shop:client:open247')
            end
        }
    }
})
```

## Compatibility

- ✅ ox_target (Recommended)
- ✅ qb-target
- Auto-detects and adapts to available system

## Support

For issues and suggestions, please open an issue on GitHub.

## License

MIT License - Use freely with AS Framework
