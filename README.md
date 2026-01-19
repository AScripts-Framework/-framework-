# AS Framework

<div align="center">

![AS Framework](https://img.shields.io/badge/AS%20Framework-v1.0.0-8B5CF6?style=for-the-badge)
![FiveM](https://img.shields.io/badge/FiveM-Ready-00D26A?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

**Modern, optimized FiveM server framework built with ox_lib integration**

[📚 Documentation](https://YOUR_USERNAME.github.io/as-framework) • [🚀 Installation](#installation) • [💬 Support](https://github.com/YOUR_USERNAME/as-framework/issues)

</div>

---

## 🌟 Features

- **🚀 Optimized Performance** - Built with ox_lib and oxmysql for maximum efficiency
- **🎨 Modern UI** - Purple-themed interface across all resources
- **🔧 Modular Design** - 12 integrated resources working seamlessly together
- **⚙️ Centralized Config** - All settings managed through convars.cfg
- **🛡️ Built-in Security** - Comprehensive anti-cheat system
- **📱 Responsive HUD** - Modern HUD with customizable settings
- **👥 Multicharacter** - Advanced spawn system with character selection
- **🔐 Permission System** - 3-tier admin access control
- **⛽ Fuel System** - Realistic fuel consumption with electric vehicle support
- **🎯 Target System** - Custom raycast-based targeting
- **🚑 EMS System** - Complete ambulance job with death mechanics
- **💊 Drug Economy** - Full drug system with labs, dealers, and effects
- **👮 Police System** - Comprehensive law enforcement with MDT and evidence
- **📻 Radio System** - PMA Voice integration with restricted frequencies

## 📦 What's Included

### Core Resources

| Resource | Description | Status |
|----------|-------------|--------|
| **as-core** | Framework foundation with player management, money system, jobs | ✅ Ready |
| **as-spawn** | Multicharacter spawn system with appearance integration | ✅ Ready |
| **as-target** | Custom target eye system with ox_target/qb-target bridge | ✅ Ready |
| **as-hud** | Modern HUD with player stats and vehicle speedometer | ✅ Ready |
| **as-fuel** | Fuel and electric vehicle battery management | ✅ Ready |
| **as-anticheat** | Comprehensive cheat detection and prevention | ✅ Ready |
| **as-admin** | Full admin menu with player management | ✅ Ready |

### Job Resources

| Resource | Description | Status |
|----------|-------------|--------|
| **as-ambulance** | EMS job with death system, last stand, revive mechanics | ✅ Ready |
| **as-police** | Police job with MDT, evidence, armory, vehicles, warrants | ✅ Ready |

### Economy Resources

| Resource | Description | Status |
|----------|-------------|--------|
| **as-drugs** | Drug economy with labs, dealers, selling, crafting, effects | ✅ Ready |

### Communication Resources

| Resource | Description | Status |
|----------|-------------|--------|
| **as-radio** | Radio communication with PMA Voice, restricted frequencies, active users | ✅ Ready |

## 🚀 Installation

### Prerequisites

- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory) - For ambulance, police, drugs, and radio
- [fivem-appearance](https://github.com/pedr0fontoura/fivem-appearance) or [illenium-appearance](https://github.com/iLLeniumStudios/illenium-appearance)
- [pma-voice](https://github.com/AvarianKnight/pma-voice) - For radio communication

### Quick Start

1. **Download** the latest release
2. **Extract** all resources to your `resources` folder
3. **Import** `as-core/database.sql` into your MySQL database
4. **Add** to your `server.cfg`:
```cfg
# Dependencies
ensure oxmysql
ensure ox_lib
ensure ox_inventory
ensure fivem-appearance  # or illenium-appearance
ensure pma-voice

# AS Framework - Core
ensure as-core
exec @as-core/convars.cfg
ensure as-spawn
ensure as-target
ensure as-hud
ensure as-fuel
ensure as-anticheat
ensure as-admin

# AS Framework - Jobs
ensure as-ambulance
ensure as-police

# AS Framework - Economy
ensure as-drugs

# AS Framework - Communication
ensure as-radio
```ure as-admin
```

5. **Configure** settings in `as-core/convars.cfg`
- [AS-Core Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Spawn Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Target Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-HUD Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Fuel Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-AntiCheat Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Admin Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Ambulance Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Police Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Drugs Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)

- [AS-Core Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Spawn Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Target Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-HUD Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Fuel Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-AntiCheat Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)
- [AS-Admin Documentation](https://YOUR_USERNAME.github.io/as-framework#resources)

## ⚙️ Configuration

All framework settings are centralized in `as-core/convars.cfg`:

```cfg
# Core Settings
set as_core_debug 0
set as_use_target 1

# Spawn Settings
set as_spawn_max_characters 5
set as_spawn_multicharacter 1
set as_spawn_starting_money 5000

# HUD Settings
set as_hud_update_interval 250
set as_hud_settings_key "F9"

# Fuel Settings
set as_fuel_consumption_rate 1.0
set as_fuel_show_blips 1
set as_fuel_price_per_liter 5

# Anti-Cheat Settings
setr as_ac_autoban 1
setr as_ac_ban_duration 0
setr as_ac_webhook ""

# Admin Settings
set as_admin_menu_key "F10"
setr as_admin_webhook ""
```

## 🎮 Usage Examples

### Player Management (Server-Side)

```lua
local AS = exports['as-core']:GetCoreObject()

-- Get player
local player = AS.Server.GetPlayer(source)

-- Manage money
player.addMoney('bank', 1000)
player.removeMoney('cash', 500)

-- Manage job
player.setJob('police', 2)
```

### Target System (Client-Side)

```lua
exports['as-target']:AddModel({'prop_atm_01'}, {
    {
        name = 'use_atm',
        icon = 'fas fa-credit-card',
        label = 'Use ATM',
        onSelect = function()
            -- Open banking menu
        end
    }
})
```

### Fuel System

```lua
-- Get vehicle fuel
local fuel = exports['as-fuel']:GetVehicleFuel(vehicle)

-- Set vehicle fuel
exports['as-fuel']:SetVehicleFuel(vehicle, 75.0)

-- Check if electric
local isElectric = exports['as-fuel']:IsElectricVehicle(vehicle)
```

## 🛡️ Admin System

### Permission Levels

- **Moderator** (Level 1) - Kick, warn, teleport, spectate
- **Admin** (Level 2) - All moderator + ban, vehicle spawn, weather control
- **Superadmin** (Level 3) - Full access to all features

### Admin Commands

```bash
# Player Management
/kick [id] [reason]
/ban [id] [days] [reason]
/spectate [id]

# Teleportation
/tp [id] or /tp [x] [y] [z]
/bring [id]

# Vehicle
/car [model]
/dv
/fix

# Self
/noclip
/god
/heal
/revive
```

## 🎨 Customization

### HUD Themes

Press `F9` in-game to access HUD settings:
- 6 color themes (Purple, Blue, Green, Red, Orange, Pink)
- Customizable position and scale
- Independent player and vehicle HUD settings

### Admin Menu

Press `F10` to open the admin menu:
- Player management
- Teleportation
- Vehicle spawning
- Weather/time control
- Self actions

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

- Built with [ox_lib](https://github.com/overextended/ox_lib)
- Database integration via [oxmysql](https://github.com/overextended/oxmysql)
- Appearance system support for [fivem-appearance](https://github.com/pedr0fontoura/fivem-appearance) and [illenium-appearance](https://github.com/iLLeniumStudios/illenium-appearance)

## 📞 Support

- 📖 [Documentation](https://YOUR_USERNAME.github.io/as-framework)
- 🐛 [Report a Bug](https://github.com/YOUR_USERNAME/as-framework/issues)
- 💡 [Request a Feature](https://github.com/YOUR_USERNAME/as-framework/issues)

---

<div align="center">

**Made with ❤️ for the FiveM community**

⭐ Star this repo if you found it helpful!

</div>
