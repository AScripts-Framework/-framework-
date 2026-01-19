# AS-Ambulance

Complete EMS/Medical system for AS Framework with death mechanics, last stand, hospital interactions, and ambulance job features.

## 🚑 Features

### Death System
- **Last Stand Mechanic** - Players enter critical condition before death, giving EMS time to respond
- **Customizable Timers** - Configure last stand duration (60s default) and respawn time (300s default)
- **Death Screen UI** - Modern purple-themed death screen with circular timer
- **Hospital Respawn** - Automatically respawn at nearest hospital
- **Death Logging** - Discord webhook integration for tracking deaths and causes

### EMS Job
- **On-Duty System** - Clock in/out at hospital duty points
- **Revive Players** - Use defibrillator to revive critically injured or dead players
- **Heal Players** - Treat injuries and restore health
- **Check Vitals** - Examine patient health and armor levels
- **Salary System** - Earn money for reviving players ($500 default)
- **Emergency Notifications** - EMS notified when players enter last stand

### Hospital Locations
- **Pillbox Hill Medical Center** (Los Santos)
- **Sandy Shores Medical Center** (Sandy Shores)
- **Paleto Bay Medical Center** (Paleto Bay)

Each hospital features:
- Check-in counter for civilian treatment
- Duty toggle point for EMS
- Vehicle garage with ambulance fleet
- Medical supplies stash

### Ambulance Features
- **Vehicle Spawning** - Spawn ambulances, fire trucks, and EMS bikes
- **Medical Trunk** - Access medical supplies from ambulance trunk
- **Auto-Setup** - Interactions automatically added to ambulance vehicles
- **Easy Storage** - Store vehicles at any hospital garage

### EMS Menu (F6)
- **Patient Actions**
  - Revive Patient (defibrillator)
  - Heal Patient (bandages)
  - Check Vitals (health/armor)
  - Escort Patient
  - Stretcher (coming soon)
  - Diagnose (coming soon)
- **Quick Actions**
  - EMS Announcements
  - Set Callsign
- **Status Display**
  - Duty status
  - EMS online count
  - Active emergency calls

## 📦 Installation

### Prerequisites
- [as-core](https://github.com/YOUR_USERNAME/as-framework) - AS Framework Core
- [as-target](https://github.com/YOUR_USERNAME/as-framework) - Target system
- [ox_lib](https://github.com/overextended/ox_lib) - Required by AS Framework
- [ox_inventory](https://github.com/overextended/ox_inventory) - Inventory system
- [oxmysql](https://github.com/overextended/oxmysql) - Database

### Setup Steps

1. **Download** `as-ambulance` to your resources folder

2. **Import Database**
```sql
-- Run database.sql to create the ambulance_records table
-- Add ambulance job to your jobs table if not already present
```

3. **Add to server.cfg**
```cfg
ensure oxmysql
ensure ox_lib
ensure ox_inventory
ensure as-core
ensure as-target
ensure as-ambulance
```

4. **Configure** settings in `shared/config.lua`

5. **Restart** your server

## ⚙️ Configuration

All settings are in `shared/config.lua`:

### General Settings
```lua
Config.MenuKey = 'F6' -- Key to open EMS menu
Config.RespawnTime = 300 -- Respawn timer (5 minutes)
Config.LastStandTime = 60 -- Last stand timer (1 minute)
Config.EnableLastStand = true -- Enable last stand mechanic
Config.RespawnAtHospital = true -- Respawn at nearest hospital
```

### Job Settings
```lua
Config.JobName = 'ambulance' -- Job name in database
Config.ReviveReward = 500 -- Money for reviving players
Config.HealPrice = 100 -- Cost for civilian check-in
```

### Hospitals
Add or modify hospital locations:
```lua
Config.Hospitals = {
    {
        name = 'Hospital Name',
        coords = vector3(x, y, z),
        heading = 0.0,
        checkIn = vector3(x, y, z), -- Walk-in treatment
        duty = vector3(x, y, z), -- Clock in/out
        garage = vector3(x, y, z), -- Vehicle spawn
        stash = vector3(x, y, z), -- Medical supplies
    }
}
```

### Vehicles
```lua
Config.Vehicles = {
    {label = 'Ambulance', model = 'ambulance', price = 0},
    {label = 'Fire Truck', model = 'firetruk', price = 0},
}
```

### Discord Logging
```lua
Config.EnableLogging = true
Config.WebhookURL = 'YOUR_WEBHOOK_URL'
```

## 🎮 Usage

### For Civilians

**When Injured:**
1. You'll enter "Last Stand" when critically injured
2. EMS is automatically notified with your location
3. Wait for EMS to arrive and revive you
4. If no EMS responds, you'll die after 60 seconds

**When Dead:**
1. Death screen appears with respawn timer
2. Wait 5 minutes for respawn timer
3. Click "Respawn at Hospital" when available
4. You'll wake up at the nearest hospital

**Hospital Check-In:**
1. Go to any hospital check-in counter
2. Use target system (Eye icon)
3. Select "Get Treatment" ($100)
4. You'll be healed instantly

### For EMS

**Going On Duty:**
1. Go to hospital duty point (blue marker)
2. Use target system
3. Select "Toggle Duty"
4. You're now on duty and can use EMS features

**Opening EMS Menu:**
- Press `F6` while on duty
- Access all EMS actions and information

**Reviving Players:**
1. Approach critically injured or dead player
2. Press `F6` to open menu
3. Click "Revive Patient"
4. Wait 5 seconds while performing CPR
5. Player is revived, you earn $500

**Healing Players:**
1. Approach any player
2. Open EMS menu (`F6`)
3. Click "Heal Patient"
4. Wait 3 seconds
5. Player is fully healed

**Check Vitals:**
1. Stand near player
2. Open EMS menu
3. Click "Check Vitals"
4. See player's health and armor percentage

**Spawning Vehicles:**
1. Go to hospital garage
2. Use target system
3. Select "Vehicle Garage"
4. Choose your vehicle
5. Vehicle spawns immediately

**Storing Vehicles:**
1. Drive to hospital garage
2. Use target system while in vehicle
3. Select "Store Vehicle"
4. Vehicle is deleted

## 🎯 Exports

### Client Exports

```lua
-- Check if player is dead
local isDead = exports['as-ambulance']:IsDead()

-- Check if in last stand
local inLastStand = exports['as-ambulance']:IsInLastStand()

-- Revive player (admin/script use)
exports['as-ambulance']:Revive()

-- Check EMS duty status
local onDuty = exports['as-ambulance']:IsOnDuty()

-- Open EMS menu
exports['as-ambulance']:OpenMenu()

-- Revive nearby player (EMS)
exports['as-ambulance']:ReviveNearby()

-- Heal nearby player (EMS)
exports['as-ambulance']:HealNearby()
```

## 📋 Commands

No commands are included by default. The system uses menus and interactions for all actions.

You can add admin commands in your admin system:
```lua
-- Admin revive command
RegisterCommand('revive', function(source, args)
    local targetId = tonumber(args[1]) or source
    TriggerClientEvent('as-ambulance:client:revive', targetId)
end, true) -- Requires admin permission
```

## 🎨 Customization

### Death Screen Theme
Edit `html/death.css` to change colors:
```css
/* Last stand color */
.timer-progress {
    stroke: #8B5CF6; /* Purple */
}

/* Death screen color */
#deathScreen .timer-progress {
    stroke: #EF4444; /* Red */
}
```

### EMS Menu Theme
Edit `html/style.css`:
```css
/* Menu header gradient */
.menu-header {
    background: linear-gradient(135deg, #8B5CF6 0%, #7C3AED 100%);
}
```

### Animations
Modify animations in `shared/config.lua`:
```lua
Config.DeathAnimation = {
    dict = 'dead',
    anim = 'dead_a',
}

Config.ReviveAnimation = {
    dict = 'mini@cpr@char_a@cpr_str',
    anim = 'cpr_pumpchest',
    duration = 5000,
}
```

## 🔧 Integration

### With Inventory Systems

The resource uses **ox_inventory** for all medical items and storage:

**Medical Items:**
- `bandage` - Heal minor injuries
- `medkit` - Fully heal player
- `defib` - Revive dead/downed players

**Stash Access:**
```lua
-- Hospital stash (50 slots, 100kg)
exports.ox_inventory:openInventory('stash', 'ems_medical_supplies')

-- Ambulance trunk
local plate = GetVehicleNumberPlateText(vehicle)
exports.ox_inventory:openInventory('trunk', plate)
```

**Adding Medical Items to ox_inventory:**
Add to `ox_inventory/data/items.lua`:
```lua
['bandage'] = {
    label = 'Bandage',
    weight = 100,
    stack = true,
    close = true,
    description = 'Heal minor injuries'
},
['medkit'] = {
    label = 'Medical Kit',
    weight = 500,
    stack = true,
    close = true,
    description = 'Fully heal injuries'
},
['defib'] = {
    label = 'Defibrillator',
    weight = 2000,
    stack = false,
    close = true,
    description = 'Revive unconscious players'
}
```

### With Job Systems

The resource uses AS Framework's built-in job system. Players need:
- Job: `ambulance`
- Any grade (0-4)

### With Phone/Dispatch

Add emergency call integration:
```lua
-- When player enters last stand, trigger dispatch
TriggerEvent('dispatch:emergencyCall', {
    code = '10-52', -- Medical emergency
    message = 'Person down, needs immediate assistance',
    coords = coords
})
```

## 📊 Database

### ambulance_records Table
Tracks all medical events (optional logging):
- `id` - Record ID
- `identifier` - Player identifier
- `event_type` - death, revive, or heal
- `ems_identifier` - EMS who helped (if applicable)
- `cause` - Death cause or treatment type
- `location` - Coordinates as string
- `timestamp` - When event occurred

Query examples:
```sql
-- Get player's death count
SELECT COUNT(*) FROM ambulance_records 
WHERE identifier = 'license:xxx' AND event_type = 'death';

-- Get EMS revive stats
SELECT ems_identifier, COUNT(*) as revives 
FROM ambulance_records 
WHERE event_type = 'revive' 
GROUP BY ems_identifier;

-- Recent deaths
SELECT * FROM ambulance_records 
WHERE event_type = 'death' 
ORDER BY timestamp DESC 
LIMIT 10;
```

## 🐛 Troubleshooting

**Death screen not showing:**
- Check console for NUI errors
- Ensure `ui_page` is set correctly in fxmanifest.lua
- Verify all HTML files are in the `html/` folder

**Can't revive players:**
- Ensure you're on duty (`/duty` or at duty point)
- Check that you're within 3 meters of the player
- Player must be dead or in last stand

**Vehicles won't spawn:**
- Verify vehicle models exist in game
- Check garage coordinates are correct
- Ensure as-target is running

**Hospitals not showing:**
- Blips are created on resource start
- Check Config.Hospitals coordinates
- Restart resource if blips don't appear

## 📝 License

MIT License - See [LICENSE](../LICENSE) file for details

## 🤝 Credits

- Built for AS Framework
- Uses [ox_lib](https://github.com/overextended/ox_lib) for UI
- Integrates with [as-target](https://github.com/YOUR_USERNAME/as-framework)

## 📞 Support

- [Documentation](https://YOUR_USERNAME.github.io/as-framework)
- [Report Issues](https://github.com/YOUR_USERNAME/as-framework/issues)
- [Framework Discord](https://discord.gg/YOUR_SERVER)

---

**Built with ❤️ for the FiveM community**
