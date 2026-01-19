// Documentation content for each resource
const docs = {
    'as-core': `
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

1. Add \`as-core\` to your resources folder
2. Import \`database.sql\` into your MySQL database
3. Add to \`server.cfg\`:

\`\`\`cfg
ensure oxmysql
ensure ox_lib
ensure as-core

# Load centralized configuration
exec @as-core/convars.cfg
\`\`\`

## Configuration

All settings are managed through \`convars.cfg\`:

\`\`\`cfg
# Debug mode
set as_core_debug 0

# Default spawn location
set as_default_spawn_x -269.4
set as_default_spawn_y -955.3
set as_default_spawn_z 31.2
set as_default_spawn_h 206.0

# Enable target system
set as_use_target 1
\`\`\`

## Usage

### Get Core Object

\`\`\`lua
local AS = exports['as-core']:GetCoreObject()
\`\`\`

### Server-Side Functions

\`\`\`lua
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
\`\`\`

### Callbacks

\`\`\`lua
-- Server callback
AS.Server.RegisterCallback('as-core:getData', function(source, cb)
    cb({data = 'example'})
end)

-- Client trigger
AS.Client.TriggerCallback('as-core:getData', function(data)
    print(data.data)
end)
\`\`\`

## Ace Permissions

Add admins to \`convars.cfg\`:

\`\`\`cfg
# Admin permissions
add_principal identifier.license:YOUR_LICENSE group.admin

# Superadmin permissions
add_principal identifier.license:YOUR_LICENSE group.superadmin
\`\`\`

## Dependencies

- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)
`,

    'as-spawn': `
# AS-Spawn

**AS Framework Spawn System** - Advanced multicharacter spawn selection with appearance integration.

## Features

- **Multicharacter Support** - Up to 5 characters per player (configurable)
- **Character Creation** - Full character customization on first spawn
- **Spawn Selection** - Choose from multiple spawn locations
- **Job-Based Spawns** - Automatic spawn points based on player job
- **Appearance Integration** - Auto-detects fivem-appearance or illenium-appearance
- **Modern UI** - Clean purple-themed NUI interface
- **Database Persistence** - Character data stored in MySQL

## Installation

1. Add \`as-spawn\` to your resources folder
2. Install appearance resource (fivem-appearance or illenium-appearance)
3. Add to \`server.cfg\`:

\`\`\`cfg
ensure as-core
ensure fivem-appearance  # or illenium-appearance
ensure as-spawn
\`\`\`

## Configuration

Settings are in \`as-core/convars.cfg\`:

\`\`\`cfg
# Maximum characters per player
set as_spawn_max_characters 5

# Enable multicharacter (0 = single character, 1 = multiple)
set as_spawn_multicharacter 1

# Starting money for new characters
set as_spawn_starting_money 5000
\`\`\`

Customize spawn points in \`config.lua\`:

\`\`\`lua
Config.SpawnPoints = {
    {
        name = 'Bus Station',
        coords = vector4(452.8, -662.3, 28.5, 180.0),
        icon = 'fa-bus'
    },
    -- Add more spawn points
}

Config.JobSpawns = {
    ['police'] = vector4(442.4, -981.9, 30.7, 180.0),
    ['ambulance'] = vector4(332.2, -595.3, 43.3, 70.0),
    -- Add more job spawns
}
\`\`\`

## Default Spawn Locations

- **Bus Station** - Downtown LS
- **Beach** - Vespucci Beach
- **Airport** - LSIA Terminal
- **Motel** - Pink Cage Motel
- **Last Position** - Where you logged out

## Dependencies

- as-core
- fivem-appearance OR illenium-appearance
- oxmysql
- ox_lib
`,

    'as-target': `
# AS-Target

**AS Framework Target System** - Custom raycast-based targeting with compatibility bridge.

## Features

- **Custom Target Eye** - Raycast-based entity targeting
- **Optimized Performance** - Efficient entity detection
- **Compatibility Bridge** - Converts ox_target/qb-target calls to AS-Target
- **Modern UI** - 35px purple eye icon positioned 120px right of center
- **Entity Types** - Support for entities, models, zones, and bones
- **Distance Detection** - Configurable interaction distance (3.0m default)

## Installation

\`\`\`cfg
ensure as-core
ensure as-target
\`\`\`

## Configuration

\`\`\`lua
Config.MaxDistance = 3.0  -- Maximum interaction distance
Config.DebugPoly = false  -- Show debug boxes
\`\`\`

## Usage

### Add Entity Target

\`\`\`lua
exports['as-target']:AddEntity(entity, {
    {
        name = 'interact',
        icon = 'fas fa-hand',
        label = 'Interact',
        onSelect = function(data)
            print('Interacted with entity')
        end,
        canInteract = function(entity, distance)
            return distance < 2.0
        end
    }
})
\`\`\`

### Add Model Target

\`\`\`lua
exports['as-target']:AddModel({'prop_atm_01', 'prop_atm_02'}, {
    {
        name = 'use_atm',
        icon = 'fas fa-credit-card',
        label = 'Use ATM',
        onSelect = function(data)
            -- Open banking menu
        end
    }
})
\`\`\`

### Add Zone Target

\`\`\`lua
exports['as-target']:AddBoxZone('shop_entrance', vector3(25.0, -1347.0, 29.5), 2.0, 2.0, {
    name = 'shop_entrance',
    heading = 0.0,
    debugPoly = false,
    minZ = 28.5,
    maxZ = 30.5
}, {
    options = {
        {
            name = 'enter_shop',
            icon = 'fas fa-door-open',
            label = 'Enter Shop',
            onSelect = function()
                -- Enter shop
            end
        }
    },
    distance = 2.0
})
\`\`\`

## Compatibility Bridge

Automatically converts ox_target and qb-target calls to AS-Target format.

## Dependencies

- as-core (optional, for job/item checks)
`,

    'as-hud': `
# AS-HUD

**AS Framework HUD** - Modern purple-themed HUD with player stats and vehicle speedometer.

## Features

- **Compact Design** - 40px status bars positioned bottom-left
- **Player Stats** - Health, armor, hunger, thirst, stamina, oxygen
- **Vehicle Speedometer** - Semi-circular gauge with speed, RPM, and fuel
- **Color Themes** - 6 pre-defined themes (Purple, Blue, Green, Red, Orange, Pink)
- **Customizable Settings** - Position, scale, and visibility options
- **Conditional Display** - Stamina only shows when below 100%
- **Fuel Integration** - Reads from as-fuel if available
- **Settings Menu** - In-game configuration (F9 by default)

## Installation

\`\`\`cfg
ensure as-core
ensure as-fuel  # Optional but recommended
ensure as-hud
\`\`\`

## Configuration

Settings in \`as-core/convars.cfg\`:

\`\`\`cfg
# Update interval in milliseconds
set as_hud_update_interval 250

# Settings menu keybind
set as_hud_settings_key "F9"
\`\`\`

## HUD Elements

### Player HUD (Bottom-Left)

- **Health** - Red heart icon
- **Armor** - Blue shield icon
- **Hunger** - Orange utensils icon
- **Thirst** - Cyan droplet icon
- **Stamina** - Green person-running icon (hidden at 100%)
- **Oxygen** - Blue lungs icon (only when underwater)

### Vehicle HUD (Bottom-Center)

- **Speed Arc** - Outer arc showing speed (0-220 km/h or mph)
- **RPM Arc** - Middle arc showing engine RPM
- **Fuel Arc** - Inner arc showing fuel/battery level
- **Gear Display** - Current gear (R, N, 1-6)
- **Speed Display** - Digital speed readout

## Settings Menu

Press F9 to customize:

- Player HUD position, scale, offsets
- Vehicle HUD position, scale, offsets
- Speed unit (km/h or mph)
- Color theme
- Show/hide elements

## Exports

\`\`\`lua
-- Toggle HUD visibility
exports['as-hud']:ToggleHUD(show)

-- Update hunger/thirst
exports['as-hud']:SetHunger(value) -- 0-100
exports['as-hud']:SetThirst(value) -- 0-100
\`\`\`

## Dependencies

- as-core
- as-fuel (optional)
- ox_lib
`,

    'as-fuel': `
# AS-Fuel

**AS Framework Fuel System** - Comprehensive fuel and electric vehicle battery management.

## Features

- **Realistic Fuel Consumption** - Vehicle-specific consumption rates
- **Electric Vehicle Support** - Battery drain for electric vehicles
- **Fuel Stations** - 24 gas stations and 5 charging stations across the map
- **Station Blips** - Optional map markers for fuel/charging stations
- **Entity State Persistence** - Fuel levels persist across resource restarts
- **Export Integration** - Easy integration with other resources (HUD, etc.)

## Installation

\`\`\`cfg
ensure as-core
ensure as-fuel
\`\`\`

## Configuration

Settings in \`as-core/convars.cfg\`:

\`\`\`cfg
# Fuel consumption rate multiplier
set as_fuel_consumption_rate 1.0

# Electric vehicle battery drain multiplier
set as_fuel_electric_drain_rate 1.0

# Show fuel blips on map
set as_fuel_show_blips 1

# Fuel price per liter
set as_fuel_price_per_liter 5
\`\`\`

## Exports

\`\`\`lua
-- Get vehicle fuel level (0-100)
local fuel = exports['as-fuel']:GetVehicleFuel(vehicle)

-- Set vehicle fuel level
exports['as-fuel']:SetVehicleFuel(vehicle, 75.0)

-- Check if vehicle is electric
local isElectric = exports['as-fuel']:IsElectricVehicle(vehicle)
\`\`\`

## Vehicle Classes

Fuel consumption varies by vehicle class:
- **Compacts** - 0.8x consumption
- **Sedans** - 1.0x consumption
- **SUVs** - 1.3x consumption
- **Sports** - 1.5x consumption
- **Super** - 2.0x consumption
- **Motorcycles** - 0.6x consumption
- **Bicycles** - 0.0x (no fuel)

## Electric Vehicles

Pre-configured electric vehicles:
- voltic, raiden, cyclone, tezeract
- dilettante, surge, khamelion, neon

Add more in \`shared/config.lua\`:

\`\`\`lua
Config.ElectricVehicles = {
    ['model_name'] = true,
}
\`\`\`

## Fuel Stations

### Gas Stations (24 locations)
- Downtown Los Santos
- Vespucci Beach
- Del Perro
- Route 68
- And more...

### Charging Stations (5 locations)
- LifeInvader Parking
- Legion Square Parking
- Rockford Plaza
- Vinewood Hills
- Pacific Bluffs

## Dependencies

- as-core
- oxmysql
- ox_lib
`,

    'as-anticheat': `
# AS-AntiCheat

**AS Framework Anti-Cheat** - Comprehensive cheat detection and prevention system.

## Features

- **Weapon Detection** - Blacklisted and modded weapon removal
- **Speed Detection** - Speed hack and abnormal movement detection
- **Godmode Detection** - Invincibility and damage immunity detection
- **Noclip Detection** - Collision and physics state monitoring
- **Invisibility Detection** - Alpha channel and visibility checks
- **Teleport Detection** - Unauthorized position change prevention
- **Explosion Detection** - Mass explosion and spam prevention
- **Resource Injection** - Detects unauthorized resource starts
- **Progressive Punishment** - Warn → Kick → Ban system
- **Discord Logging** - Real-time violation notifications
- **Admin Bypass** - Automatic bypass for authorized admins

## Installation

\`\`\`cfg
ensure as-core
ensure as-anticheat
\`\`\`

## Configuration

All settings in \`as-core/convars.cfg\`:

\`\`\`cfg
# Enable/Disable individual checks
setr as_ac_weapon_check 1
setr as_ac_speed_check 1
setr as_ac_godmode_check 1
setr as_ac_noclip_check 1
setr as_ac_invisible_check 1
setr as_ac_teleport_check 1
setr as_ac_resource_check 1
setr as_ac_explosion_check 1

# Auto-ban on detection
setr as_ac_autoban 1

# Ban duration in days (0 = permanent)
setr as_ac_ban_duration 0

# Discord webhook URL
setr as_ac_webhook ""
\`\`\`

## Detection Systems

### Weapon Detection
Blacklisted weapons:
- WEAPON_RAILGUN
- WEAPON_RAYPISTOL
- WEAPON_RAYCARBINE
- Various explosion weapons

### Speed Detection
Monitors:
- Player velocity (threshold: 150 units/sec)
- Vehicle speed
- Rapid position changes

### Godmode Detection
Checks:
- Invincibility flags
- Damage immunity
- Health regeneration patterns

### Teleport Detection
Prevents:
- Instant position changes
- Long-distance warps
- Unauthorized spawning

Distance threshold configurable:
\`\`\`cfg
setr as_ac_teleport_distance 100.0
\`\`\`

## Punishment System

Violation tracking:
- **Warnings**: 1-2 violations
- **Kick**: 3 violations
- **Ban**: 5+ violations

## Admin Bypass

Ace permissions that bypass anti-cheat:
- \`as.admin\`
- \`as.moderator\`
- \`as.superadmin\`

Configure in \`as-core/convars.cfg\`:

\`\`\`cfg
add_ace group.admin as.admin allow
add_principal identifier.license:YOUR_LICENSE group.admin
\`\`\`

## Discord Logging

Set webhook URL:
\`\`\`cfg
setr as_ac_webhook "https://discord.com/api/webhooks/YOUR_WEBHOOK"
\`\`\`

Logs include:
- Player name and identifier
- Violation type and details
- Punishment action taken
- Timestamp

## Exports

\`\`\`lua
-- Check if player is admin
local isAdmin = exports['as-anticheat']:IsPlayerAdmin(source)

-- Add violation manually
exports['as-anticheat']:AddViolation(source, 'Custom violation')

-- Ban player
exports['as-anticheat']:BanPlayer(source, 'Reason', 7) -- 7 days
\`\`\`

## Dependencies

- as-core
- oxmysql
- ox_lib
`,

    'as-admin': `
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

## Installation

\`\`\`cfg
ensure as-core
ensure as-admin
\`\`\`

## Configuration

Settings in \`as-core/convars.cfg\`:

\`\`\`cfg
# Admin menu key
set as_admin_menu_key "F10"

# Discord webhook URL
setr as_admin_webhook "https://discord.com/api/webhooks/YOUR_WEBHOOK"
\`\`\`

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

## Admin Menu Tabs

### 1. Players Tab
View all online players with actions:
- Teleport To / Bring Player
- Spectate / Freeze
- Heal / Revive
- Give/Remove Money
- Set Job / Notify
- Warn / Kick / Ban

### 2. Teleport Tab
Quick locations:
- LSPD, Hospital, Garage
- Airport, Beach, LifeInvader
- Maze Bank, Casino

### 3. Vehicle Tab
- Spawn vehicle by model
- Quick spawn (Adder, T20, Zentorno, etc.)
- Repair current vehicle
- Delete nearby vehicle

### 4. Server Tab
- Weather control (Clear, Rain, Snow, etc.)
- Time control (Set hour and minute)
- Server announcements

### 5. Self Tab
- Toggle Noclip
- Toggle Godmode
- Toggle Invisible
- Heal Self
- Revive Self

## Commands

### Player Management
\`\`\`
/kick [id] [reason]
/ban [id] [days] [reason]
/spectate [id]
\`\`\`

### Teleportation
\`\`\`
/tp [id] or /tp [x] [y] [z]
/bring [id]
\`\`\`

### Vehicle
\`\`\`
/car [model]
/dv
/fix
\`\`\`

### Server
\`\`\`
/weather [type]
/time [hour] [minute]
/announce [message]
\`\`\`

### Self
\`\`\`
/noclip
/god
/invis
/heal [id]
/revive [id]
\`\`\`

## Noclip Controls

- **W/S** - Forward/Backward
- **A/D** - Left/Right
- **Shift** - Speed boost (5x)
- **Alt** - Slow mode (0.2x)

## Ace Permissions

Grant admin access in \`server.cfg\`:

\`\`\`cfg
# Moderators
add_ace group.moderator as.moderator allow
add_principal identifier.license:LICENSE1 group.moderator

# Admins
add_ace group.admin as.admin allow
add_principal identifier.license:LICENSE2 group.admin

# Superadmins
add_ace group.superadmin as.superadmin allow
add_principal identifier.license:LICENSE3 group.superadmin
\`\`\`

## Exports

\`\`\`lua
-- Server-side
local adminLevel = exports['as-admin']:GetAdminLevel(source)
local hasPerm = exports['as-admin']:HasPermission(source, 'kick')

-- Client-side
exports['as-admin']:OpenAdminMenu()
exports['as-admin']:CloseAdminMenu()
\`\`\`

## Dependencies

- as-core
- oxmysql
- ox_lib
`,

    'as-ambulance': `
# AS-Ambulance

**EMS/Ambulance Job System** - Complete emergency medical services with death mechanics, revive system, and hospital management.

## Features

- **💀 Death System** - Realistic death mechanics with last stand and timer
- **🏥 Revive System** - EMS can revive downed players with roleplay animations
- **🚑 Hospital Respawn** - Automatic hospital respawn when timer expires
- **💊 Medical Items** - Bandages, medkits, and advanced medical supplies
- **🎒 On-Duty Armory** - Medical supplies storage at hospital
- **🚗 EMS Vehicles** - Ambulance vehicle spawning system
- **💰 Payment System** - Get paid for reviving citizens
- **📱 Dispatch Integration** - Receive emergency calls (with as-police)
- **🎨 Modern UI** - Death screen with timer and visual effects

## Installation

1. Add **as-ambulance** to your resources folder
2. Ensure **ox_inventory** is installed
3. Add ambulance job items to ox_inventory (see items section)
4. Add to **server.cfg**:

\`\`\`cfg
ensure as-core
ensure ox_inventory
ensure as-ambulance
\`\`\`

## Configuration

Edit \`shared/config.lua\`:

\`\`\`lua
Config.Job = 'ambulance' -- Job name
Config.MinimumEMSOnline = 0 -- Minimum EMS for auto-respawn
Config.DeathTime = 300 -- Death timer in seconds (5 minutes)
Config.LastStandTime = 30 -- Last stand timer in seconds
Config.ReviveReward = 500 -- Money given to EMS for reviving

Config.RespawnPoint = {
    coords = vector3(311.0, -595.0, 43.3),
    heading = 340.0
}

Config.Hospital = {
    Armory = vector3(306.0, -601.0, 43.3),
    VehicleSpawn = vector3(294.0, -574.0, 43.2),
    VehicleHeading = 70.0
}
\`\`\`

## ox_inventory Items

Add to \`ox_inventory/data/items.lua\`:

\`\`\`lua
['bandage'] = {
    label = 'Bandage',
    weight = 50,
    stack = true,
    close = true,
    description = 'Basic medical bandage'
},

['medkit'] = {
    label = 'Medkit',
    weight = 500,
    stack = true,
    close = true,
    description = 'Advanced medical kit'
}
\`\`\`

## How to Use

### For EMS Players

1. **Get the Job** - Be assigned the ambulance/EMS job
2. **Access Armory** - Go to hospital armory point for medical supplies
3. **Spawn Vehicle** - Use vehicle spawn point to get ambulance
4. **Respond to Calls** - Check for downed players on map
5. **Revive Players** - Approach downed player and use revive action

### For Injured Players

1. **Last Stand** - When health reaches 0, you enter last stand for 30 seconds
2. **Death State** - After last stand expires, death screen appears
3. **Wait for EMS** - EMS can revive you during death timer
4. **Respawn** - Press E when timer expires to respawn at hospital

## Events

### Client Events

\`\`\`lua
-- Trigger death state
TriggerEvent('as-ambulance:client:onPlayerDeath')

-- Revive player
TriggerEvent('as-ambulance:client:revive')

-- Open armory
TriggerEvent('as-ambulance:client:openArmory')
\`\`\`

### Server Events

\`\`\`lua
-- Revive player (server-side)
TriggerEvent('as-ambulance:server:revivePlayer', targetId)
\`\`\`

## Exports

### Client Exports

\`\`\`lua
-- Check if player is dead
local isDead = exports['as-ambulance']:IsDead()

-- Get last stand status
local inLastStand = exports['as-ambulance']:IsInLastStand()

-- Force revive player
exports['as-ambulance']:RevivePlayer()
\`\`\`

## Commands

\`\`\`
/revive [id] - Revive a player (admin only)
/kill [id] - Kill a player (admin only)
/heal [id] - Heal a player (admin only)
\`\`\`

## Dependencies

- as-core
- ox_lib
- ox_inventory
`,

    'as-police': `
# AS-Police

**Police Job System** - Comprehensive law enforcement system with MDT, evidence, armory, vehicles, warrants, and dispatch.

## Features

- **🖥️ MDT (Mobile Data Terminal)** - Complete police computer with search, warrants, evidence
- **📋 Evidence System** - Collect, store, and manage crime scene evidence
- **🔫 Armory System** - Weapon and equipment storage with rank restrictions
- **🚓 Vehicle System** - Police vehicle spawning with garage management
- **📜 Warrant System** - Create and manage arrest warrants
- **🚨 Dispatch Alerts** - Receive 911 calls and crime alerts
- **👮 Rank System** - Different ranks with varying permissions
- **💰 Fine System** - Issue fines and manage payments
- **🏢 Police Stations** - Multiple station support with different zones

## Installation

1. Add **as-police** to your resources folder
2. Import **database.sql** to create police tables
3. Ensure **ox_inventory** is installed
4. Add police items to ox_inventory
5. Add to **server.cfg**:

\`\`\`cfg
ensure as-core
ensure ox_inventory
ensure as-police
\`\`\`

## Database Tables

The resource creates these tables:
- **police_evidence** - Crime scene evidence storage
- **police_warrants** - Active arrest warrants
- **police_reports** - Incident reports
- **police_convictions** - Criminal records

## Configuration

Edit \`shared/config.lua\`:

\`\`\`lua
Config.Job = 'police' -- Job name
Config.MinimumPolice = 0 -- Minimum cops required

Config.Stations = {
    LSPD = {
        label = 'Los Santos Police Department',
        blip = vector3(425.1, -979.5, 30.7),
        armory = vector3(452.6, -980.0, 30.7),
        vehicles = vector3(438.4, -1018.3, 28.5),
        mdt = vector3(441.0, -982.0, 30.7)
    }
}

Config.Vehicles = {
    {model = 'police', label = 'Police Cruiser', rank = 0},
    {model = 'police2', label = 'Police Buffalo', rank = 2},
    {model = 'policeb', label = 'Police Bike', rank = 1}
}
\`\`\`

## MDT Features

### Citizen Search
- Search by name or state ID
- View criminal history
- See active warrants
- Check convictions

### Evidence Management
- View all collected evidence
- Filter by type, date, officer
- Attach evidence to cases
- Evidence photos and descriptions

### Warrant System
- Create new warrants
- Search active warrants
- Warrant types: Arrest, Search, Bench
- Expiration dates

### Reports
- Create incident reports
- Link evidence to reports
- Officer notes and narratives
- Case management

## Dispatch Alerts

Police receive alerts for:
- **drugActivity** - Drug sales and production
- **shooting** - Gunfire detected
- **robbery** - Store robberies
- **carjacking** - Vehicle theft
- **speeding** - Excessive speeding
- **vehicleTheft** - Stolen vehicles
- **assault** - Physical altercations

### Custom Alert Integration

\`\`\`lua
-- From any resource
TriggerEvent('as-police:server:sendAlert', 'robbery', coords, 'Store robbery in progress', {
    store = '24/7 Supermarket',
    suspect = 'Armed'
})
\`\`\`

## Armory System

### Weapon Categories
- **Pistols** - Rank 0+
- **Shotguns** - Rank 1+
- **Rifles** - Rank 2+
- **Equipment** - Flashbangs, spike strips, etc.

### Access Control
\`\`\`lua
Config.ArmoryItems = {
    {item = 'weapon_pistol', label = 'Pistol', rank = 0},
    {item = 'weapon_carbinerifle', label = 'Carbine', rank = 2},
    {item = 'armor', label = 'Body Armor', rank = 0}
}
\`\`\`

## Evidence System

### Evidence Types
- Fingerprints
- DNA samples
- Bullet casings
- Photos
- Documents
- Physical evidence

### Collecting Evidence

\`\`\`lua
-- Trigger evidence collection
TriggerEvent('as-police:client:collectEvidence', evidenceType)
\`\`\`

## Commands

\`\`\`
/mdt - Open MDT (police only)
/cuff - Cuff nearest player
/escort - Escort cuffed player
/drag - Drag cuffed player
/jail [id] [time] - Send to jail
/fine [id] [amount] - Issue fine
/seize - Seize illegal items
\`\`\`

## Exports

### Client Exports

\`\`\`lua
-- Check if player is police
local isCop = exports['as-police']:IsPolice()

-- Open MDT
exports['as-police']:OpenMDT()

-- Check if player is cuffed
local isCuffed = exports['as-police']:IsCuffed()
\`\`\`

### Server Exports

\`\`\`lua
-- Send dispatch alert
exports['as-police']:SendAlert(alertType, coords, message, data)

-- Get online officers
local officers = exports['as-police']:GetOnlineOfficers()
\`\`\`

## Integration with Other Resources

The police system integrates with:
- **as-drugs** - Receives drug activity alerts
- **as-ambulance** - Can be called to medical scenes
- **as-radio** - Police frequencies (100-199.9)

## Dependencies

- as-core
- ox_lib
- ox_inventory
- oxmysql
`,

    'as-drugs': `
# AS-Drugs

**Drug Economy System** - Complete drug production, distribution, and consumption system with police integration.

## Features

- **🏭 Drug Labs** - Hidden labs for processing and crafting drugs
- **💊 Drug Types** - Weed, cocaine, meth with unique effects
- **🤝 Drug Dealers** - NPC dealers for buying/selling
- **👤 Street Selling** - Sell to random NPCs on the street
- **⚗️ Crafting System** - Process raw materials into sellable drugs
- **🌿 Drug Effects** - Visual effects and stat changes when using
- **🚨 Police Integration** - Alerts police when selling or crafting
- **💰 Economy** - Dynamic pricing based on demand
- **📊 Reputation** - Build reputation with dealers

## Installation

1. Add **as-drugs** to your resources folder
2. Ensure **ox_inventory** and **as-police** are installed
3. Add drug items to ox_inventory
4. Add to **server.cfg**:

\`\`\`cfg
ensure as-core
ensure ox_inventory
ensure as-police  # Optional but recommended
ensure as-drugs
\`\`\`

## Drug Types

### Cannabis (Weed)
- **Raw**: \`weed_leaf\`
- **Processed**: \`weed_baggy\`
- **Effects**: Relaxation, altered vision
- **Base Price**: $50-80

### Cocaine
- **Raw**: \`coca_leaf\`
- **Processed**: \`cocaine_baggy\`
- **Effects**: Speed boost, stamina increase
- **Base Price**: $150-200

### Methamphetamine
- **Raw**: \`ephedrine\`
- **Processed**: \`meth_baggy\`
- **Effects**: Extreme speed, aggression
- **Base Price**: $250-350

## Configuration

Edit \`shared/config.lua\`:

\`\`\`lua
Config.PoliceCallChance = 30 -- % chance police called when selling
Config.MinimumPolice = 0 -- Minimum cops required
Config.SellTimeout = 5 -- Minutes between sells to same NPC

Config.DrugLabs = {
    {
        coords = vector3(1005.0, -3200.0, -38.5),
        name = 'Underground Lab',
        drugs = {'weed', 'cocaine'}
    }
}

Config.Dealers = {
    {
        coords = vector3(144.0, -1734.0, 29.3),
        ped = 'a_m_y_mexthug_01',
        drugs = {'weed_leaf', 'coca_leaf'}
    }
}
\`\`\`

## ox_inventory Items

Add to \`ox_inventory/data/items.lua\`:

\`\`\`lua
-- Raw materials
['weed_leaf'] = {
    label = 'Cannabis Leaf',
    weight = 100,
    stack = true,
    close = true,
    description = 'Raw cannabis plant material'
},

-- Processed drugs
['weed_baggy'] = {
    label = 'Weed Baggy',
    weight = 50,
    stack = true,
    close = true,
    description = 'Packaged cannabis',
    client = {
        export = 'as-drugs.UseWeed'
    }
}
\`\`\`

## How to Use

### Buying from Dealers
1. Find a dealer on the map (blip)
2. Approach the dealer NPC
3. Use interaction (target/ox_target)
4. Purchase raw materials

### Processing Drugs
1. Obtain raw materials
2. Go to a drug lab location
3. Use crafting menu
4. Process materials into sellable drugs

### Selling to NPCs
1. Have processed drugs in inventory
2. Approach random pedestrians
3. Use sell action
4. Complete the deal (or get rejected)

### Using Drugs
Use items from inventory to experience effects:
- Visual screen effects
- Stat modifications
- Duration-based buffs/debuffs

## Drug Effects

### Weed Effects
- Screen blur and color shift
- Slight speed reduction
- Relaxation animation
- Duration: 60 seconds

### Cocaine Effects
- Increased movement speed (+20%)
- Stamina boost
- Screen shake
- Duration: 90 seconds

### Meth Effects
- Major speed increase (+40%)
- Aggression mode
- Screen distortion
- Duration: 120 seconds

## Police Integration

Drug activities trigger dispatch alerts:

\`\`\`lua
-- Automatic police notification
- Drug sales to NPCs
- Drug production at labs
- Rejected sales (NPC calls police)
\`\`\`

Police see:
- Alert type: "Drug Activity"
- Location coordinates
- Description of activity
- Suspect information

## Events

### Client Events

\`\`\`lua
-- Start selling
TriggerEvent('as-drugs:client:startSelling', drugType)

-- Open lab crafting
TriggerEvent('as-drugs:client:openLab')

-- Use drug
TriggerEvent('as-drugs:client:useDrug', drugType)
\`\`\`

### Server Events

\`\`\`lua
-- Process drug
TriggerEvent('as-drugs:server:processDrug', drugType, amount)

-- Complete sale
TriggerEvent('as-drugs:server:completeSale', npcId, drugType, amount)
\`\`\`

## Exports

### Client Exports

\`\`\`lua
-- Check if player is in drug lab
local inLab = exports['as-drugs']:IsInDrugLab()

-- Get current drug effects
local effects = exports['as-drugs']:GetActiveDrugEffects()
\`\`\`

### Server Exports

\`\`\`lua
-- Add drug to economy
exports['as-drugs']:RegisterDrug(drugData)

-- Get drug price
local price = exports['as-drugs']:GetDrugPrice(drugType)
\`\`\`

## Reputation System

- Build reputation by successful sales
- Higher reputation = better prices
- Unlock new dealers and labs
- Reputation decreases if caught by police

## Anti-Spam Protection

- Cooldown between sells
- Can't sell to same NPC twice
- Detection radius to prevent farm-spam
- Configurable timeouts

## Dependencies

- as-core
- ox_lib
- ox_inventory
- as-police (optional, for dispatch)
`,

    'as-loading': `
# AS-Loading

**AS Framework Loading Screen** - Modern video background loading screen with media player controls, track information, and FiveM integration.

## Features

- **🎬 Video Background** - Multiple WebM video playlist support with built-in audio
- **🎵 Track Information** - Album artwork, song name, and artist display
- **🎮 Media Controls** - Play/pause, previous/next video, time scrubber, volume control, mute
- **📊 Loading Progress** - Real-time progress bar in bottom-right corner
- **💬 Loading Messages** - Dynamic messages at bottom-center
- **⚙️ Highly Configurable** - Centralized config.js with 9 configuration sections
- **🖱️ Cursor Support** - Enable cursor during loading
- **🔌 AS Framework Integration** - Auto-shutdown on player loaded event
- **🎨 Modern Layout** - Controls bottom-left, progress bottom-right, messages bottom-center

## Installation

1. Add **as-loading** to your resources folder
2. Add videos and album artwork to \`html/videos/\` folder
3. Add to **server.cfg**:

\`\`\`cfg
loadscreen 'as-loading'
ensure as-loading
\`\`\`

## File Structure

\`\`\`
as-loading/
├── fxmanifest.lua
├── client.lua
├── html/
│   ├── index.html
│   ├── style.css
│   ├── script.js
│   ├── config.js
│   └── videos/
│       ├── background.webm
│       ├── album1.jpg
│       └── ...
└── preview.html
\`\`\`

## Configuration

All settings in \`html/config.js\`:

### Branding
\`\`\`javascript
branding: {
    serverName: 'YOUR SERVER NAME',
    tagline: 'Your Server Tagline',
    logoPath: 'logo.png',
    showLogo: false, // Logo hidden by default
}
\`\`\`

### Video Playlist
\`\`\`javascript
videos: {
    playlist: [
        {
            url: 'videos/background1.webm',
            artist: 'Artist Name',
            song: 'Song Title',
            album: 'videos/album1.jpg'
        },
        {
            url: 'videos/background2.webm',
            artist: 'Another Artist',
            song: 'Another Song',
            album: 'videos/album2.jpg'
        },
    ],
    muted: false, // Use video's built-in audio
    autoPlay: true,
    loop: true,
}
\`\`\`

### Audio Settings
\`\`\`javascript
audio: {
    enabled: false, // Separate audio disabled (using video audio)
    defaultVolume: 30, // 0-100
}
\`\`\`

### Control Colors
\`\`\`javascript
controls: {
    show: true,
    colors: {
        primary: '#8B5CF6',
        secondary: '#10B981',
    }
}
\`\`\`

### Progress Messages
\`\`\`javascript
progress: {
    show: true,
    messages: [
        'Connecting to server...',
        'Loading game assets...',
        'Preparing your experience...',
        'Syncing with server...',
        'Loading player data...',
        'Almost ready...',
        'Welcome to AS Framework!'
    ],
    colors: {
        bar: '#8B5CF6',
        fill: 'linear-gradient(90deg, #8B5CF6, #10B981)',
    },
    shimmer: true,
}
\`\`\`

### Layout Positioning
\`\`\`javascript
layout: {
    logoTopPosition: 15, // % from top
    progressBottomPosition: 20, // px from bottom (bottom-right)
    progressRightPosition: 20, // px from right
    progressWidth: 300, // px
    controlsBottomPosition: 30, // px from bottom (250px from left)
}
\`\`\`

### Loading Behavior
\`\`\`javascript
behavior: {
    maxLoadTime: 300000, // 5 minutes in milliseconds
    shutdownDelay: 1000, // Delay before shutdown
    simulateProgress: true, // Simulate loading progress
}
\`\`\`

## Media Requirements

### WebM Videos with Audio
- **Format**: WebM (VP8/VP9 with Vorbis/Opus audio)
- **Resolution**: 1920x1080 recommended
- **Duration**: 2-5 minutes recommended
- **File Size**: Keep under 50MB for fast loading
- **Audio**: Include audio track in the video file

**Convert video to WebM with audio:**
\`\`\`bash
ffmpeg -i input.mp4 -c:v libvpx-vp9 -b:v 2M -c:a libvorbis background.webm
\`\`\`

### Album Artwork
- **Format**: JPG or PNG
- **Size**: 500x500px recommended (displayed at 45x45px)
- **File Size**: Keep under 200KB

## Controls Guide

| Control | Function |
|---------|----------|
| ▶️ Play/Pause | Toggle video/audio playback |
| ⏪ Previous | Jump to previous video in playlist |
| ⏩ Next | Jump to next video in playlist |
| 🎚️ Time Slider | Scrub through current video timeline |
| 🔊 Volume Icon | Toggle mute on/off |
| 🎚️ Volume Slider | Adjust audio volume (0-100%) |

## Layout

- **Player Controls**: Bottom-left (250px from left, 30px from bottom)
- **Track Info**: In player controls (album art, song, artist)
- **Loading Progress**: Bottom-right corner (20px from edges, 300px wide)
- **Loading Messages**: Bottom-center (10px from bottom)

## AS Framework Integration

### Client-Side Event Handling

The loading screen listens for AS Framework player loaded events:

\`\`\`lua
-- client.lua
RegisterNetEvent('AS:Client:OnPlayerLoaded', function()
    Wait(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    SetNuiFocus(false, false)
end)

RegisterNetEvent('AS:Client:OnCharacterSelected', function()
    Wait(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    SetNuiFocus(false, false)
end)
\`\`\`

### Cursor Support

Cursor is enabled during loading and disabled on shutdown:

\`\`\`lua
CreateThread(function()
    Wait(1000)
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(false)
end)
\`\`\`

### Timeout Fallback

Automatically shuts down after 5 minutes if no event received:

\`\`\`lua
SetTimeout(300000, function() -- 5 minutes
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)
\`\`\`

## Preview Mode

Open \`preview.html\` in your browser to test the loading screen:

- Animated gradient background (fallback when video isn't loaded)
- All media controls functional (demo mode)
- Loading progress simulation
- Sample track information display

**Note**: Update video path to \`html/videos/background.webm\` in preview.html.

## Customization

### Change Control Position

Edit \`html/style.css\`:

\`\`\`css
.controls-container {
    left: 250px; /* Distance from left edge */
    bottom: 30px; /* Distance from bottom */
}
\`\`\`

### Change Progress Position

\`\`\`css
.loading-container {
    right: 20px; /* Distance from right */
    bottom: 20px; /* Distance from bottom */
    width: 300px; /* Width of container */
}
\`\`\`

### Hide Track Information

\`\`\`css
.track-info {
    display: none;
}
\`\`\`

### Change Colors

Edit \`config.js\`:

\`\`\`javascript
controls: {
    colors: {
        primary: '#YOUR_COLOR',
        secondary: '#YOUR_COLOR',
    }
}
\`\`\`

## Hosting Media Files

### Local Files (Current Setup)
Files stored in resource folder:

\`\`\`
as-loading/html/videos/
├── background1.webm
├── background2.webm
├── album1.jpg
├── album2.jpg
└── ...
\`\`\`

**Note**: Large files increase resource size and initial download time.

### CDN Option (Faster Loading)

1. Upload videos and album art to a CDN
2. Update paths in \`config.js\`:

\`\`\`javascript
videos: {
    playlist: [
        {
            url: 'https://your-cdn.com/background1.webm',
            artist: 'Artist Name',
            song: 'Song Title',
            album: 'https://your-cdn.com/album1.jpg'
        },
    ],
}
\`\`\`

3. Remove local files from \`fxmanifest.lua\`

## Troubleshooting

### Video not loading
- Check file path is correct (\`html/videos/\` folder)
- Ensure WebM format with audio track
- Check browser console for errors (F12)
- Verify video file exists and isn't corrupted

### Audio not playing
- Make sure \`videos.muted: false\` in config.js
- Check volume isn't at 0
- Ensure video has audio track

### Track info not updating
- Verify playlist uses object format with artist/song/album
- Check album artwork paths are correct
- Ensure images exist in videos folder

### Controls not visible
- Check z-index values (controls should be 10+)
- Verify \`controls.show: true\` in config.js
- Clear browser cache

### Loading screen won't close
- Ensure AS Framework is triggering events
- Check client.lua event listeners
- Verify \`loadscreen_manual_shutdown 'yes'\` in fxmanifest.lua

## Performance Tips

1. **Optimize video file size** - Smaller = faster loading
2. **Use CDN** - Better delivery speeds for players
3. **Compress assets** - Reduce file sizes without quality loss
4. **Test on slow connections** - Ensure acceptable load times

## Dependencies

- AS Framework (for auto-shutdown events)
- Modern web browser (HTML5 video support)

---

**Part of AS Framework** - See main framework documentation for integration details.
`,

    'as-radio': `
# AS-Radio

**Radio Communication System** - Advanced radio with PMA Voice integration, restricted frequencies, and real-time user tracking.

## Features

- **🎙️ PMA Voice Integration** - Crystal-clear voice communication
- **🔒 Restricted Frequencies** - Job-locked frequency ranges
- **👥 Active Users List** - See who's on your frequency in real-time
- **🎚️ Volume Control** - Independent radio volume adjustment
- **⚡ Quick Access** - One-click common frequency buttons
- **🎨 Modern UI** - Beautiful interface with animations
- **📱 Inventory Integration** - Requires radio item from ox_inventory
- **🔊 Sound Effects** - Radio click sounds and animations

## Installation

1. Add **as-radio** to your resources folder
2. Ensure **pma-voice** and **ox_inventory** are installed
3. Add radio item to ox_inventory
4. Add to **server.cfg**:

\`\`\`cfg
ensure pma-voice
ensure as-core
ensure ox_inventory
ensure as-radio
\`\`\`

## Frequency Ranges

| Range | Jobs | Description |
|-------|------|-------------|
| **100.0 - 199.9** | Police, Sheriff | Law enforcement only |
| **200.0 - 299.9** | Ambulance, EMS | Emergency medical |
| **300.0 - 399.9** | Mechanic | Mechanic services |
| **400.0 - 499.9** | Taxi | Taxi services |
| **1.0 - 99.9** | Public | Open to everyone |

## Configuration

Edit \`shared/config.lua\`:

\`\`\`lua
Config.RadioItem = 'radio' -- ox_inventory item
Config.RadioKey = 'Z' -- Key to open radio

Config.RestrictedFrequencies = {
    {min = 100.0, max = 199.9, jobs = {'police', 'sheriff'}},
    {min = 200.0, max = 299.9, jobs = {'ambulance', 'ems'}},
    {min = 300.0, max = 399.9, jobs = {'mechanic'}},
    {min = 400.0, max = 499.9, jobs = {'taxi'}}
}

Config.Radio = {
    defaultVolume = 50,
    enableClicks = true,
    enableAnimation = true
}
\`\`\`

## ox_inventory Item

Add to \`ox_inventory/data/items.lua\`:

\`\`\`lua
['radio'] = {
    label = 'Radio',
    weight = 220,
    stack = false,
    close = true,
    description = 'Portable radio for communication',
    client = {
        export = 'as-radio.UseRadio'
    }
}
\`\`\`

## How to Use

### Opening Radio
- Press **Z** (default) to open radio
- Must have radio item in inventory

### Connecting to Frequency
1. Enter frequency (1.0 - 999.9)
2. Click **CONNECT** button
3. Or use quick access buttons

### Talking on Radio
- Use **PMA Voice push-to-talk** key
- All users on same frequency hear you
- Click sounds when transmitting

### Volume Control
- Adjust slider (0-100%)
- Independent from game volume
- Real-time adjustment

### Active Users
- Center-right panel shows active users
- Displays name and job
- Auto-updates when users join/leave

## UI Features

### Main Interface
- Large frequency display
- Status indicator (online/offline)
- Frequency input with validation
- Quick access buttons
- Volume slider
- Connect/disconnect buttons

### Active Users Panel
- Real-time user list
- User avatars (initials)
- Name and job display
- Center-right positioning
- Auto-scroll for many users

## Events

### Client Events

\`\`\`lua
-- Open radio interface
TriggerEvent('as-radio:client:openRadio')

-- Leave current channel
TriggerEvent('as-radio:client:leaveChannel')
\`\`\`

## Exports

### Client Exports

\`\`\`lua
-- Check if radio is on
local isOn = exports['as-radio']:IsRadioOn()

-- Get current frequency
local freq = exports['as-radio']:GetRadioChannel()

-- Force leave radio
exports['as-radio']:LeaveRadio()
\`\`\`

### Server Exports

\`\`\`lua
-- Get users on frequency
local users = exports['as-radio']:GetChannelUsers(frequency)
-- Returns: {{id, name, job}, ...}
\`\`\`

## PMA Voice Integration

Automatic integration with PMA Voice:
- \`setRadioChannel(frequency)\` - Join voice channel
- \`setRadioVolume(volume)\` - Set voice volume
- \`removePlayerFromRadio()\` - Leave channel

## Animations

When talking on radio:
- Cellphone animation plays
- Character holds hand to ear
- Configurable in config

## Sound Effects

Radio click sounds:
- On connect
- On disconnect
- On transmission (optional)
- Volume adjustable

## Job Restrictions

Server-side validation:
- Checks player job before allowing connection
- Returns error if unauthorized
- Configurable per frequency range

## Automatic Cleanup

- Players removed on disconnect
- Channel cleanup on player drop
- Radio state cleared on resource restart

## Commands

\`\`\`
/radio - Open radio interface (if have item)
\`\`\`

## Keybinds

Default keybinds (remappable):
- **Z** - Open radio
- **ESC** - Close radio
- **PMA Voice PTT** - Talk on radio

## Troubleshooting

### Radio won't open
- Ensure you have radio item
- Check as-radio started after as-core
- Verify keybind not conflicting

### Can't connect to frequency
- Check if frequency is restricted
- Verify you have required job
- Ensure frequency in valid range

### Voice not working
- Ensure PMA Voice is running
- Check push-to-talk key is set
- Verify pma-voice starts before as-radio

## Dependencies

- as-core
- pma-voice
- ox_lib
- ox_inventory
`
};

// Parse markdown to HTML
function parseMarkdown(markdown) {
    let html = markdown;

    // Code blocks
    html = html.replace(/```(\w+)?\n([\s\S]*?)```/g, (match, lang, code) => {
        return `<pre><code class="language-${lang || 'text'}">${escapeHtml(code.trim())}</code></pre>`;
    });

    // Inline code
    html = html.replace(/`([^`]+)`/g, '<code>$1</code>');

    // Headers
    html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>');
    html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>');
    html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>');

    // Bold
    html = html.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');

    // Lists
    html = html.replace(/^\- (.*$)/gim, '<li>$1</li>');
    html = html.replace(/(<li>.*<\/li>)/s, '<ul>$1</ul>');

    // Paragraphs
    html = html.split('\n\n').map(para => {
        if (para.startsWith('<h') || para.startsWith('<ul') || 
            para.startsWith('<pre') || para.startsWith('<li')) {
            return para;
        }
        if (para.trim()) {
            return `<p>${para.trim()}</p>`;
        }
        return '';
    }).join('\n');

    // Links
    html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2" target="_blank">$1</a>');

    return html;
}

function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, m => map[m]);
}

// Load documentation
function loadDoc(resourceName) {
    const content = document.getElementById('doc-content');
    const markdown = docs[resourceName];
    
    if (markdown) {
        content.innerHTML = parseMarkdown(markdown);
    }

    // Update active sidebar item
    document.querySelectorAll('.sidebar-item').forEach(item => {
        item.classList.remove('active');
        if (item.dataset.resource === resourceName) {
            item.classList.add('active');
        }
    });
}

// Event listeners
document.addEventListener('DOMContentLoaded', () => {
    // Load initial documentation
    loadDoc('as-core');

    // Mobile menu toggle
    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
    const mainNav = document.getElementById('mainNav');
    
    if (mobileMenuToggle) {
        mobileMenuToggle.addEventListener('click', () => {
            mainNav.classList.toggle('active');
            const icon = mobileMenuToggle.querySelector('i');
            icon.classList.toggle('fa-bars');
            icon.classList.toggle('fa-times');
        });
    }

    // Close mobile menu when clicking nav links
    document.querySelectorAll('.nav a').forEach(link => {
        link.addEventListener('click', () => {
            mainNav.classList.remove('active');
            const icon = mobileMenuToggle.querySelector('i');
            icon.classList.add('fa-bars');
            icon.classList.remove('fa-times');
        });
    });

    // Sidebar click events (Desktop)
    document.querySelectorAll('.sidebar-item').forEach(item => {
        item.addEventListener('click', () => {
            loadDoc(item.dataset.resource);
        });
    });

    // Resource tab click events (Mobile)
    document.querySelectorAll('.resource-tab').forEach(tab => {
        tab.addEventListener('click', () => {
            loadDoc(tab.dataset.resource);
            
            // Update active tab
            document.querySelectorAll('.resource-tab').forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            
            // Scroll to content on mobile
            if (window.innerWidth <= 968) {
                document.getElementById('doc-content').scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });

    // Smooth scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
});
