# 🚔 AS-Police

A comprehensive police job system for FiveM featuring MDT, evidence collection, armory management, vehicle garage, and advanced player interactions.

## Features

### 👮 Duty System
- On/off duty toggle at police stations
- Automatic player relationship management
- Real-time on-duty officer count tracking
- Police ped relationship group assignment

### 🏢 Police Stations
Four fully-equipped stations across the map:
- **Mission Row PD** - Main Los Santos station
- **Vespucci PD** - Beach-side station
- **Sandy Shores Sheriff** - Desert county station
- **Paleto Bay Sheriff** - Northern county station

Each station includes:
- Duty toggle point
- Armory access
- Vehicle garage
- Helicopter pad
- Evidence locker

### 🔫 Armory System
Rank-based weapon access:
- **Recruit**: Nightstick, Flashlight, Taser, Pistol
- **Officer**: + Combat Pistol, Carbine Rifle
- **Sergeant**: + Pump Shotgun
- **Lieutenant**: + SMG
- **Chief**: + Sniper Rifle

**Equipment**:
- Handcuffs
- Radio
- Body Armor
- Medical supplies (Bandage, Medkit)
- Repair Kit
- Evidence Bags
- Battering Ram
- Spike Strips

### 🚗 Vehicle System
Rank-based vehicle access:
- **Recruit**: Police Cruiser
- **Officer**: + Police Cruiser 2
- **Sergeant**: + Police Cruiser 3, Police Bike
- **Lieutenant**: + Unmarked Cruiser
- **Chief**: + SWAT Van, Police Helicopter

**Features**:
- Spawn vehicles at garage points
- Store vehicles when done
- Automatic plate assignment (LSPD####)
- Livery and extras support

### 🔗 Player Interactions
Full interaction menu with:
- **Handcuff/Uncuff** - Restrain suspects
- **Drag** - Move handcuffed players
- **Put in Vehicle** - Place in nearest car
- **Remove from Vehicle** - Take out of car
- **Search** - Open player inventory
- **Fine** - Issue monetary fines
- **Jail** - Send to prison

### 🚨 Evidence System
Collect and analyze crime scene evidence:
- **Bullet Casings** - Auto-generated when firing
- **Blood Samples** - Created when players are shot
- **Fingerprints** - Manual collection
- **DNA Samples** - Manual collection
- **Photo Evidence** - Crime scene photos
- **Item Evidence** - Physical evidence

**Features**:
- Auto-despawn after 10 minutes
- Evidence markers for on-duty officers
- Requires evidence bags to collect
- Metadata tracking (who, when, where)

### ⚖️ Warrant System
Create and manage arrest warrants:
- Create warrants with expiration
- View all active warrants
- Execute warrants (arrest)
- Automatic expiration tracking

### 📡 Dispatch System
Real-time alert system:
- **Shots Fired** (10-71)
- **Speeding Vehicle** (10-40)
- **Robbery** (10-90)
- **Car Jacking** (10-35)
- **Assault** (10-10)
- **Kidnapping** (10-34)
- **Drug Activity** (10-31)

**Features**:
- Map blips with radius
- Auto-removal after duration
- MDT integration
- Only sent to on-duty officers

### 🖥️ MDT (Mobile Data Terminal)
Comprehensive in-vehicle computer:
- **Dispatch Tab** - View active calls
- **Warrants Tab** - Manage warrants
- **Reports Tab** - File police reports
- **Roster Tab** - On-duty officer list

### 📊 Radar System
In-vehicle speed radar:
- Front radar detection
- Rear radar detection
- Configurable speed limit
- Visual speeding alerts
- Auto-dispatch for speeders

### 🏛️ Jail System
Prison management:
- Send players to jail with time/reason
- Multiple jail cells
- Auto-release on timer
- Persistent across reconnects
- Manual release by officers

## Installation

### 1. Download & Extract
```bash
cd resources
git clone <repository-url> as-police
```

### 2. Database Setup
Run the SQL file to create required tables:
```bash
mysql -u username -p database_name < as-police/database.sql
```

### 3. ox_inventory Items
Add the items from `database.sql` to your `ox_inventory/data/items.lua` file.

### 4. Server Config
Add to your `server.cfg`:
```cfg
ensure as-core
ensure as-target
ensure ox_lib
ensure ox_inventory
ensure as-police
```

### 5. Job Configuration
Ensure your framework has `police` and/or `sheriff` jobs configured with grades:
- recruit (0)
- officer (1)
- sergeant (2)
- lieutenant (3)
- chief (4)

## Usage

### Commands
- **F6** - Open Police Menu (on duty only)
- `/radar` - Toggle speed radar (in vehicle)

### Duty
1. Go to any police station
2. Approach the duty point
3. Press **E** to toggle duty

### Armory
1. Be on duty
2. Go to armory location
3. Press **E** to open menu
4. Select weapons or equipment

### Vehicles
1. Be on duty
2. Go to vehicle garage
3. Press **E** to spawn vehicle
4. Enter vehicle and drive

To store:
1. Drive to garage
2. Press **E** while in vehicle

### Interactions
1. Be on duty
2. Stand near a player
3. Press **F6** → Interactions
4. Select action

### Evidence
1. Be on duty
2. Have evidence bags in inventory
3. Press **F6** → Evidence
4. Select nearby evidence to collect

### MDT
1. Be on duty
2. Press **F6** → MDT
3. Navigate tabs with buttons
4. Create warrants, view dispatch, etc.

## Configuration

All settings can be adjusted in `shared/config.lua`:

### Police Jobs
```lua
Config.PoliceJobs = {
    'police',
    'sheriff'
}
```

### Add New Station
```lua
Config.Stations.new_station = {
    name = 'New Station',
    blip = {coords = vector3(x, y, z), sprite = 60, color = 29, scale = 0.8},
    duty = {coords = vector3(x, y, z), heading = 0.0},
    armory = {coords = vector3(x, y, z), heading = 0.0},
    garage = {
        vehicle = vector4(x, y, z, heading),
        heli = vector4(x, y, z, heading)
    },
    evidence = {coords = vector3(x, y, z), heading = 0.0}
}
```

### Modify Weapons by Rank
```lua
Config.Weapons.officer = {
    {name = 'WEAPON_PISTOL', label = 'Pistol', price = 0, ammo = 'ammo-9'},
    -- Add more weapons
}
```

### Modify Vehicles by Rank
```lua
Config.Vehicles.sergeant = {
    {model = 'police3', label = 'Police Cruiser 3', livery = 0, extras = {}},
    -- Add more vehicles
}
```

### Radar Settings
```lua
Config.Radar = {
    maxDistance = 150.0, -- meters
    frontAngle = 45, -- degrees
    rearAngle = 45, -- degrees
    speedLimit = 80, -- mph
}
```

### Dispatch Alerts
```lua
Config.Dispatch.alerts.newAlert = {
    label = 'Alert Name',
    code = '10-XX',
    sprite = 1,
    color = 1,
    blipTime = 60
}
```

## Dependencies

### Required
- [as-core](https://github.com/yourusername/as-core) - Core framework
- [as-target](https://github.com/yourusername/as-target) - Targeting system
- [ox_lib](https://github.com/overextended/ox_lib) - UI library
- [ox_inventory](https://github.com/overextended/ox_inventory) - Inventory system
- [oxmysql](https://github.com/overextended/oxmysql) - Database connector

## Exports

### Client Exports

#### Check if on duty
```lua
local onDuty = exports['as-police']:IsOnDuty()
```

#### Get on-duty count
```lua
local count = exports['as-police']:GetOnDutyCount()
```

### Server Exports

#### Check if player is on duty
```lua
local onDuty = exports['as-police']:IsOnDuty(source)
```

#### Get on-duty count
```lua
local count = exports['as-police']:GetOnDutyCount()
```

#### Check if player has warrant
```lua
local hasWarrant = exports['as-police']:HasWarrant(identifier)
```

## Events

### Client Events

#### Toggle duty
```lua
TriggerEvent('as-police:client:toggleDuty')
```

#### Open MDT
```lua
TriggerEvent('as-police:client:openMDT')
```

#### Dispatch alert
```lua
TriggerEvent('as-police:client:dispatchAlert', alertData)
```

### Server Events

#### Send dispatch alert
```lua
TriggerEvent('as-police:server:sendAlert', alertType, coords, message, data)
```

#### Jail player
```lua
TriggerServerEvent('as-police:server:jailPlayer', targetId, time, reason)
```

#### Create warrant
```lua
TriggerServerEvent('as-police:server:createWarrant', identifier, reason, expiresIn)
```

## Integration Examples

### Trigger Dispatch from Other Resources

```lua
-- Robbery script
TriggerServerEvent('as-police:server:sendAlert', 'robbery', GetEntityCoords(PlayerPedId()), 'Store robbery in progress', {
    store = 'LTD Gasoline'
})

-- Drug script
TriggerServerEvent('as-police:server:sendAlert', 'drugActivity', coords, 'Suspicious drug activity', {
    drug = 'cocaine'
})
```

### Check Police Count

```lua
-- Heist script
local policeCount = exports['as-police']:GetOnDutyCount()
if policeCount < 3 then
    TriggerEvent('as-core:Notify', 'Not enough police online', 'error')
    return
end
```

## Troubleshooting

### Duty not working
- Ensure player has police/sheriff job
- Check job names match Config.PoliceJobs
- Verify as-core is running

### Weapons not appearing
- Ensure ox_inventory items are added
- Check weapon names are correct
- Verify player rank/grade

### Vehicles not spawning
- Ensure vehicle models exist
- Check spawn coordinates are valid
- Verify as-core vehicle spawner works

### MDT not opening
- Check NUI files are present
- Verify ui_page in fxmanifest
- Check console for errors

### Evidence not collecting
- Ensure evidence bags in inventory
- Check player is on duty
- Verify database tables exist

## Preview

Check `html/preview.html` for a visual preview of the police system.

## Support

For issues, questions, or feature requests, please open an issue on GitHub.

## Credits

**Author:** AS Framework  
**Version:** 1.0.0  
**License:** MIT

---

Made with 🚔 for the AS Framework
