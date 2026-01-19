Config = Config or {}

Config.Target = {}

-- Use custom target system (true) or bridge to ox_target/qb-target (false)
Config.Target.UseCustomTarget = true

-- If using bridge mode, force a specific target system (set to nil for auto-detect)
-- Options: 'ox_target', 'qb-target', nil
Config.Target.ForceSystem = nil

-- Keybind to open target eye (default: Left Alt)
Config.Target.Keybind = 'LMENU'

-- Close target after selecting an option
Config.Target.CloseOnSelect = true

-- Default targeting distance
Config.Target.DefaultDistance = 5.0

-- Enable debug mode
Config.Target.Debug = false

-- Default target options
Config.Target.DefaultOptions = {
    distance = 5.0,
    icon = 'fa-solid fa-eye'
}
