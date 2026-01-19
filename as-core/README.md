# AS-Core

**AS Framework Core** - The foundation of the AS server framework for FiveM.

## Features

- **Player Management** - Complete player data handling with automatic database integration
- **Money System** - Multiple account types (cash, bank) with transaction support
- **Job System** - Job management with grades and permissions
- **Callback System** - ox_lib based server/client callbacks
- **Optimized** - Built with ox_lib and oxmysql for performance
- **Auto-save** - Automatic player data persistence every 5 minutes
- **Centralized Config** - All framework settings in convars.cfg

## Installation

1. Add `as-core` to your resources folder
2. Import `database.sql` into your MySQL database
3. Add to `server.cfg`:
   ```cfg
   ensure oxmysql
   ensure ox_lib
   ensure as-core
   
   # Load centralized configuration
   exec @as-core/convars.cfg
   ```

## Configuration

All settings are managed through `convars.cfg`. Key settings:

```cfg
# Debug mode
set as_core_debug 0

# Default spawn location
set as_default_spawn_x -269.4
set as_default_spawn_y -955.3
set as_default_spawn_z 31.2
set as_default_spawn_h 206.0

# Enable target system
set as_use_target 1
```

## Usage

### Get Core Object

```lua
local AS = exports['as-core']:GetCoreObject()
```

### Server-Side Functions

```lua
-- Get player object
local player = AS.Server.GetPlayer(source)

-- Player money
local cash = player.getMoney('cash')
player.addMoney('bank', 1000)
player.removeMoney('cash', 500)

-- Player job
local job = player.getJob()
player.setJob('police', 2)

-- Player data
local identifier = player.getIdentifier()
local name = player.getName()
```

### Callbacks

```lua
-- Server callback
AS.Server.RegisterCallback('as-core:getData', function(source, cb)
    cb({data = 'example'})
end)

-- Client trigger
AS.Client.TriggerCallback('as-core:getData', function(data)
    print(data.data)
end)
```

## Ace Permissions

Add admins to `convars.cfg`:

```cfg
# Admin permissions
add_principal identifier.license:YOUR_LICENSE group.admin

# Superadmin permissions
add_principal identifier.license:YOUR_LICENSE group.superadmin
```

## Dependencies

- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)

## Support

For issues or questions, please create an issue on GitHub.

## License

MIT License - See LICENSE file for details
| `player.getCoords()` | Get position |
| `player.save()` | Save player |
| `player.showNotification(data)` | Show notification |

## Support

For issues and suggestions, please open an issue on GitHub.

## License

MIT License - Feel free to use and modify as needed.
