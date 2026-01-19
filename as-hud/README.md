# AS HUD

Modern, customizable purple-themed HUD for AS Framework with health, armor, and stamina indicators.

## Features

- 💜 **Modern Purple Design** - Beautiful gradient purple theme with smooth animations
- ⚙️ **Fully Customizable** - Change position, size, colors, and icon styles
- 🎨 **Multiple Themes** - Purple, Blue, Red, Green color themes
- 🗺️ **Smart Minimap** - Shows only when in vehicle
- 💪 **Performance Optimized** - Minimal resource usage
- 🎯 **Clean Interface** - Only shows what matters: health, armor (when equipped), stamina
- 📱 **Responsive** - Works at any resolution

## What's Shown

✅ **Health** - Always visible  
✅ **Armor** - Only shown when player has armor  
✅ **Stamina** - Always visible  
✅ **Minimap** - Only shown when in vehicle (configurable)

## What's Hidden

❌ Cash/Bank  
❌ Weapon display  
❌ Server name  
❌ Other default HUD elements

## Installation

1. Ensure you have `as-core` installed
2. Place `as-hud` in your resources folder
3. Add to your `server.cfg`:
   ```
   ensure as-core
   ensure as-hud
   ```
4. Restart your server

## Configuration

Edit `config.lua`:

```lua
Config.HUD.Defaults = {
    position = 'bottom-left',     -- bottom-left, bottom-right, top-left, top-right
    scale = 1.0,                   -- 0.5 to 2.0
    offsetX = 20,                  -- pixels from edge
    offsetY = 20,                  -- pixels from edge
    iconStyle = 'modern',          -- modern, classic, minimal
    colorTheme = 'purple'          -- purple, blue, red, green
}

Config.HUD.Minimap = {
    enableDynamicMinimap = true,   -- Show/hide based on vehicle
    roundedMinimap = true
}
```

## Usage

### Opening Settings Menu

- **Command**: `/hudsettings`
- **Default Keybind**: `F9` (configurable)

### Settings Options

#### Position
- Top Left
- Top Right
- Bottom Left
- Bottom Right

#### Size
- Slider from 50% to 200%

#### Icon Styles
- **Modern** - Clean, modern icons
- **Classic** - Traditional health/armor icons  
- **Minimal** - Simplified icons

#### Color Themes
- **Purple** (Default) - Modern purple gradient
- **Blue** - Cool blue theme
- **Red** - Warm red theme
- **Green** - Fresh green theme

#### Offsets
- **Horizontal Offset** - Distance from left/right edge (0-200px)
- **Vertical Offset** - Distance from top/bottom edge (0-200px)

### Exports

```lua
-- Show minimap manually
exports['as-hud']:ShowMinimap()

-- Hide minimap manually
exports['as-hud']:HideMinimap()
```

## Customization Examples

### Move HUD to Top Right
1. Press `F9` or use `/hudsettings`
2. Click "Top Right" under Position
3. Settings save automatically

### Make HUD Larger
1. Open settings (`F9`)
2. Drag the "Size" slider to 150%

### Change to Blue Theme
1. Open settings
2. Click "Blue" under Color Theme

### Adjust Position Fine-Tuning
1. Open settings
2. Use "Horizontal Offset" and "Vertical Offset" sliders
3. Perfect positioning for your screen

## Features Breakdown

### Health Bar
- Smooth gradient fill
- Real-time updates
- Shows percentage value
- Glow effect on low health

### Armor Bar
- Only visible when armor > 0
- Automatically hides when armor depleted
- Purple-themed protection indicator

### Stamina Bar
- Real-time stamina tracking
- Sprint stamina indicator
- Smooth animations

### Minimap
- Automatically shows when entering vehicle
- Hides when exiting vehicle
- Smooth fade animations
- Rounded corners (configurable)
- Custom positioning

### Settings Persistence
- All settings saved to client storage
- Persists across sessions
- Per-character settings
- Reset to defaults option

## Advanced Configuration

### Update Interval

Adjust how often the HUD updates in `config.lua`:

```lua
Config.HUD.UpdateInterval = 250 -- milliseconds (lower = more frequent updates)
```

### Change Settings Keybind

In `config.lua`:

```lua
Config.HUD.SettingsKey = 'F9' -- Any keyboard key
```

### Disable Dynamic Minimap

To always show the minimap:

```lua
Config.HUD.Minimap.enableDynamicMinimap = false
```

Then use:
```lua
exports['as-hud']:ShowMinimap()
```

## Troubleshooting

**HUD not showing:**
- Ensure as-core is started before as-hud
- Check that your character is loaded
- Try `/hudsettings` to verify the resource is running

**Settings not saving:**
- Settings are saved to client storage automatically
- Try using the "Reset to Default" button in settings

**Minimap not showing in vehicle:**
- Check `Config.HUD.Minimap.enableDynamicMinimap` is `true`
- Verify you're in a vehicle, not just near one

## Performance

- **Resmon**: ~0.01ms
- **Memory**: ~2-3MB
- Optimized update intervals
- Minimal NUI updates
- No unnecessary loops

## Screenshots

The HUD features:
- Smooth gradient bars with glow effects
- Modern purple theme by default
- Clean, minimalist design
- Responsive animations
- Glass-morphism effects
- Professional typography

## Support

For issues and suggestions, please open an issue on GitHub.

## License

MIT License - Use freely with AS Framework
