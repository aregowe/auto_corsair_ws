# Auto Corsair WS

A Windower 4 addon for Final Fantasy XI that automatically executes Corsair weaponskills at configurable TP thresholds with automatic party announcements.

## Features

- **Automatic Weaponskill Execution**: Fires your chosen weaponskill when TP threshold is reached
- **Party Announcements**: Automatically announces weaponskill usage to party chat
- **Configurable Settings**: Customize TP threshold, announcement delay, and cooldown
- **On-Screen Display**: Real-time display showing current WS, TP threshold, and current TP
- **Quick WS Switching**: Change weaponskills on-the-fly with simple commands
- **Short Name Support**: Use abbreviated names like "laststand" instead of "Last Stand"
- **Multi-Weapon Support**: Works with both Marksmanship and Sword weaponskills

## Installation

1. Place the `auto_corsair_ws` folder in your Windower `addons` directory
2. Load the addon in-game with: `//lua load auto_corsair_ws`
3. Configure your settings by editing the USER CONFIGURATION section in `auto_corsair_ws.lua`

## Configuration

Edit the top section of `auto_corsair_ws.lua`:

```lua
local tp_threshold  = 2750        -- Minimum TP to trigger WS
local wait_after_ws = 1           -- Seconds before party announce
local ws_name       = 'Last Stand' -- Weaponskill name
local ws_cooldown   = 1.0         -- Min seconds between WS triggers
```

## Commands

- `//acws` - Display current weaponskill
- `//acws status` - Show all current settings
- `//acws <ws_name>` - Change weaponskill (e.g., `//acws laststand` or `//acws Wildfire`)
- `//corsws` - Alternative command prefix

## Supported Weaponskill Shortcuts

### Marksmanship Weaponskills (Corsair-Accessible)
- `hotshot` → Hot Shot
- `splitshot` → Split Shot
- `snipershot` → Sniper Shot
- `slugshot` → Slug Shot
- `detonator` → Detonator
- `numbingshot` → Numbing Shot
- `laststand` → Last Stand (Merit)
- `coronach` → Coronach (Relic)
- `wildfire` → Wildfire (Empyrean)
- `leaden` → Leaden Salute (Mythic - Corsair exclusive)
- `terminus` → Terminus (Prime)

### Sword Weaponskills
- `savage` → Savage Blade
- `sang` → Sanguine Blade
- `req` → Requiescat
- `chant` → Chant du Cygne
- `vorpal` → Vorpal Blade
- `swift` → Swift Blade
- `circle` → Circle Blade
- `rlb` → Red Lotus Blade
- `seraph` → Seraph Blade
- `shining` → Shining Blade
- `fast` → Fast Blade
- `flat` → Flat Blade

## Requirements

- Windower 4

## Version

Current Version: 2.1

## Changelog

### v2.1
- Added all Corsair-accessible Marksmanship weaponskills
- Added Leaden Salute (Mythic WS - Corsair exclusive)
- Added Terminus (Prime WS)
- Removed all duplicate shortcut entries
- Cleaned up and shortened sword shortcuts
- Updated author and version information

### v2.0
- Initial release with basic Marksmanship and Sword support

## Author

TheGwardian

## License

This addon is provided as-is for use with Windower 4 and Final Fantasy XI.
