# AS-Admin

**AS Framework Admin Menu** - Comprehensive server administration and player management system.

## Features

- **Modern UI** - Purple-themed admin interface with tabbed navigation
- **Player Management** - View, manage, and moderate all online players
- **Teleportation** - Quick teleport to locations, players, or coordinates
- **Vehicle Management** - Spawn, repair, and delete vehicles
- **Server Controls** - Weather, time, and server announcements
- **Self Actions** - Noclip, godmode, invisibility, heal, revive
- **Permission System** - 3-tier access control (Moderator/Admin/Superadmin)
- **Discord Logging** - All admin actions logged to webhook
- **Command Integration** - Both menu and commands available
- **Database Integration** - Ban system with as-anticheat integration

## Installation

1. Add `as-admin` to your resources folder
2. Add to `server.cfg`:
   ```cfg
   ensure as-core
   ensure as-admin
   ```

## Configuration

Settings in `as-core/convars.cfg`:

```cfg
# Admin menu key (default: F10)
set as_admin_menu_key "F10"

# Discord webhook URL for admin action logging
setr as_admin_webhook "https://discord.com/api/webhooks/YOUR_WEBHOOK"
```

Permissions in `shared/config.lua`:

```lua
Config.Admin = {
    Permissions = {
        moderator = {
            level = 1,
            ace = 'as.moderator',
            jobs = {'police', 'sheriff'}
        },
        admin = {
            level = 2,
            ace = 'as.admin',
            jobs = {}
        },
        superadmin = {
            level = 3,
            ace = 'as.superadmin',
            jobs = {}
        }
    },
    Features = {
        -- Feature: Required Level
        ['kick'] = 1,        -- Moderator
        ['ban'] = 2,         -- Admin
        ['teleport'] = 1,    -- Moderator
        ['vehicle'] = 2,     -- Admin
        ['weather'] = 2,     -- Admin
        ['noclip'] = 1,      -- Moderator
        -- etc.
    }
}
```

## Permission Levels

### Moderator (Level 1)
- Kick players
- Warn players
- Notify players
- Freeze players
- Teleport to/bring players
- Spectate players
- Heal/revive players
- Noclip, godmode, invisibility
- View player information

### Admin (Level 2)
- All Moderator permissions
- Ban players
- Spawn/delete/repair vehicles
- Give/remove money
- Set player jobs
- Control weather
- Control time
- Server announcements

### Superadmin (Level 3)
- All Admin permissions
- Full access to all features
- Cannot be moderated by lower ranks

## Admin Menu

### Opening Menu

Press **F10** (or configured key) to open admin menu.

### Tabs

#### 1. Players Tab
- View all online players
- Search/filter players
- Click player for actions:
  - Teleport To
  - Bring Player
  - Spectate
  - Freeze/Unfreeze
  - Heal
  - Revive
  - Give Money
  - Remove Money
  - Set Job
  - Notify
  - Warn
  - Kick
  - Ban

#### 2. Teleport Tab
Quick teleport locations:
- LSPD
- Hospital
- Garage
- Airport
- Beach
- LifeInvader
- Maze Bank
- Casino

Customize in `shared/config.lua`:

```lua
Config.Admin.TeleportLocations = {
    ['LSPD'] = vector3(425.1, -979.5, 30.7),
    ['Custom'] = vector3(x, y, z),
}
```

#### 3. Vehicle Tab
- Spawn vehicle by model
- Quick spawn (Adder, T20, Zentorno, etc.)
- Repair current vehicle
- Delete nearby vehicle

Customize quick spawn in `shared/config.lua`:

```lua
Config.Admin.VehicleSpawning = {
    spawnInside = true,
    deleteOld = true,
    quickSpawn = {'adder', 't20', 'zentorno'}
}
```

#### 4. Server Tab

**Weather Control:**
- Clear, Extra Sunny, Clouds, Overcast
- Rain, Thunder, Snow, Blizzard
- Foggy, Clearing, Neutral, etc.

**Time Control:**
- Set specific hour and minute
- Synced to all players

**Announcements:**
- Send server-wide messages
- 15-second duration
- Emoji support

#### 5. Self Tab
- Toggle Noclip
- Toggle Godmode
- Toggle Invisible
- Heal Self
- Revive Self

## Commands

All admin actions available via commands:

### Player Management
```
/kick [id] [reason]       - Kick player
/ban [id] [days] [reason] - Ban player (0 = permanent)
/spectate [id]            - Spectate player
```

### Teleportation
```
/tp [id]                  - Teleport to player
/tp [x] [y] [z]          - Teleport to coordinates
/bring [id]              - Bring player to you
```

### Vehicle
```
/car [model]             - Spawn vehicle
/dv                      - Delete vehicle
/fix                     - Repair vehicle
```

### Server
```
/weather [type]          - Set weather
/time [hour] [minute]    - Set time
/announce [message]      - Server announcement
```

### Self
```
/noclip                  - Toggle noclip
/god                     - Toggle godmode
/invis                   - Toggle invisibility
/heal [id]               - Heal player (or self)
/revive [id]             - Revive player (or self)
```

## Noclip Controls

When noclip is enabled:
- **W/S** - Forward/Backward
- **A/D** - Left/Right
- **Shift** - Speed boost (5x)
- **Alt** - Slow mode (0.2x)
- **Mouse** - Look direction

Speed: 1.0 units/frame (default)

## Discord Logging

All admin actions logged to Discord webhook:

```json
{
  "embeds": [{
    "title": "🛡️ Admin Action",
    "color": 9055494,
    "fields": [
      {"name": "Action", "value": "Kick"},
      {"name": "Admin", "value": "AdminName"},
      {"name": "Target", "value": "PlayerName"},
      {"name": "Details", "value": "Reason"}
    ],
    "timestamp": "2026-01-16T12:00:00Z"
  }]
}
```

Actions logged:
- Kick, Ban, Warn, Notify
- Teleport, Bring, Freeze
- Vehicle spawn/delete/repair
- Money give/remove
- Job changes
- Weather/time changes
- Announcements
- Heal/revive

## Ban System

Integrated with as-anticheat ban table:

```sql
INSERT INTO as_bans (identifier, reason, banned_by, banned_until)
VALUES (?, ?, ?, ?)
```

### Ban Duration
- **0 days** - Permanent ban
- **1-365 days** - Temporary ban (expires automatically)

Banned players cannot join server.

## Events

```lua
-- Server-side
AddEventHandler('as-admin:playerKicked', function(targetId, admin, reason)
    -- Called when player is kicked
end)

AddEventHandler('as-admin:playerBanned', function(targetId, admin, reason, duration)
    -- Called when player is banned
end)

AddEventHandler('as-admin:adminAction', function(admin, action, target, details)
    -- Called on any admin action
end)
```

## Exports

```lua
-- Server-side
local adminLevel = exports['as-admin']:GetAdminLevel(source)
local hasPerm = exports['as-admin']:HasPermission(source, 'kick')

-- Client-side
exports['as-admin']:OpenAdminMenu()
exports['as-admin']:CloseAdminMenu()
```

## Ace Permissions

Grant admin access in `server.cfg`:

```cfg
# Moderators
add_ace group.moderator as.moderator allow
add_principal identifier.license:LICENSE1 group.moderator

# Admins
add_ace group.admin as.admin allow
add_principal identifier.license:LICENSE2 group.admin

# Superadmins
add_ace group.superadmin as.superadmin allow
add_principal identifier.license:LICENSE3 group.superadmin
```

## Job-Based Permissions

Alternatively, grant by job:

```lua
Config.Admin.Permissions.moderator.jobs = {'police', 'sheriff'}
```

Players with these jobs get moderator access.

## Preview

Open `html/preview.html` in browser to preview admin menu UI.

## Security

- All actions validated server-side
- Permission checks on every action
- Lower ranks cannot affect higher ranks
- Commands restricted by ace permissions
- Ban system prevents rejoining

## Performance

- Efficient player list updates
- Minimal network traffic
- Optimized raycast for noclip
- Client-side UI rendering

Typical resource usage: 0.00ms (idle), 0.05ms (menu open)

## Customization

Edit `html/style.css` for UI theming:

```css
:root {
    --purple: #8B5CF6;
    --purple-dark: #7C3AED;
    --purple-light: #A78BFA;
}
```

Edit `shared/config.lua` for features and locations.

## Dependencies

- [as-core](../as-core) - Framework core
- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)

## License

MIT License - See LICENSE file for details