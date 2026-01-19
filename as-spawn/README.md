# AS Spawn System

Complete spawn and multicharacter system for AS Framework with ox_lib integration.

## Features

- 🎮 **Multicharacter System** - Create and manage up to 5 characters per account
- 📍 **Spawn Selection** - Choose from multiple spawn locations using ox_lib context menu
- 🏢 **Job Spawns** - Special spawn locations for specific jobs
- 💾 **Last Location** - Option to spawn at your last logged position
- 🎨 **Beautiful UI** - Clean ox_lib context menus for character and spawn selection
- ⚙️ **Highly Configurable** - Easy configuration for spawn locations and settings

## Dependencies

Required resources:
- [as-core](../as-core) - AS Framework Core
- [ox_lib](https://github.com/overextended/ox_lib)
- [oxmysql](https://github.com/overextended/oxmysql)

## Installation

1. Ensure you have `as-core`, `ox_lib`, and `oxmysql` installed
2. Place `as-spawn` in your resources folder
3. Add to your `server.cfg`:
   ```
   ensure as-core
   ensure ox_lib
   ensure oxmysql
   ensure as-spawn
   ```
4. Configure spawn locations in `config.lua`
5. Restart your server

## Configuration

### Spawn Locations

Edit `config.lua` to add/modify spawn locations:

```lua
Config.Spawn.Locations = {
    {
        id = 'airport',
        label = 'Los Santos Airport',
        coords = vector4(-1035.71, -2731.87, 12.86, 0.0),
        icon = 'plane',
        public = true
    },
    -- Add more locations...
}
```

### Job-Specific Spawns

Add job-specific spawn locations:

```lua
Config.Spawn.JobLocations = {
    police = {
        {
            id = 'mrpd',
            label = 'Mission Row PD',
            coords = vector4(441.07, -981.82, 30.68, 180.0),
            icon = 'building-shield',
            minGrade = 0
        }
    }
}
```

## Usage

### Player Experience

1. **Character Selection**
   - Join server
   - Select existing character or create new one
   - Fill out character details (name, DOB, gender, height)

2. **Spawn Selection**
   - After character selection, choose spawn location
   - Options include:
     - Public spawn locations
     - Job-specific spawns (if employed)
     - Last location (if available)

### Exports

```lua
-- Initialize spawn selection manually
exports['as-spawn']:InitializeSpawnSelection()

-- Spawn player at specific location
exports['as-spawn']:SpawnPlayer({
    coords = vector4(x, y, z, heading),
    label = 'Location Name'
})
```

### Events

#### Client Events
- `as-spawn:client:playerSpawned` - Triggered when player spawns

#### Server Events
- `as-spawn:server:selectCharacter` - Select a character
- `as-spawn:server:saveSpawn` - Save spawn location

### Callbacks

#### Server Callbacks
- `as-spawn:server:getCharacters` - Get player's characters
- `as-spawn:server:createCharacter` - Create new character
- `as-spawn:server:deleteCharacter` - Delete a character
- `as-spawn:server:getSpawnLocation` - Get player's last location

## Character Data Structure

Characters are stored with the following fields:
- `identifier` - Player license
- `char_id` - Character slot (1-5)
- `firstname` - Character's first name
- `lastname` - Character's last name
- `dateofbirth` - Date of birth
- `sex` - Gender (M/F)
- `height` - Height in cm

## Customization

### Camera Settings

Adjust character selection camera in `config.lua`:

```lua
Config.Spawn.Camera = {
    coords = vector3(-1355.89, -1487.78, 520.0),
    rotation = vector3(-10.0, 0.0, 230.0),
    fov = 30.0
}
```

### Spawn Settings

```lua
Config.Spawn.FadeInTime = 2000 -- Fade in duration (ms)
Config.Spawn.FreezeOnSpawn = 3000 -- Freeze duration after spawn (ms)
```

## Support

For issues and suggestions, please open an issue on GitHub.

## License

MIT License - Use freely with AS Framework
