# Ultimate Rice Wallpaper-Theme Toggle System

This system replaces the old automatic wallpaper switching with a manual toggle that changes both wallpapers and themes simultaneously for a cohesive desktop experience.

## Features

- **Wallpaper + Theme Sync**: Each wallpaper is paired with a complete theme
- **Manual Control**: Press `Super+W` to cycle through themes instead of automatic switching
- **Multi-App Support**: Updates themes for WezTerm, GTK, Waybar, Starship, and Kitty
- **Waybar Integration**: Click the theme indicator in Waybar to toggle themes
- **State Persistence**: Remembers your current theme across sessions

## Organized Wallpaper Folders

Wallpapers are now organized in themed folders for better management:

```
wallpapers/
├── winter/     # Snow, ice, cold themes → Nord
├── night/      # Dark, moon, evening themes → Catppuccin Mocha
├── day/        # Bright, sun, light themes → Catppuccin Latte
├── retro/      # Classic, vintage themes → Gruvbox
└── special/    # Custom overrides
```

## Smart Pattern-Based Theming

The system now automatically assigns themes based on filename patterns:

| Pattern | Theme | Example |
|---------|-------|---------|
| `winter`, `snow`, `cold`, `ice` | Nord | `winter-landscape.png` |
| `night`, `dark`, `moon`, `space` | Catppuccin Mocha | `night-city.png` |
| `day`, `sun`, `bright`, `light` | Catppuccin Latte | `sunny-day.jpg` |
| `retro`, `old`, `classic` | Gruvbox | `retro-game.png` |
| `city`, `urban`, `neon` | Catppuccin Macchiato | `cyberpunk-city.png` |
| `fantasy`, `magic` | Tokyo Night | `magical-forest.jpg` |
| `dragon`, `mythical` | Everforest | `dragon-lair.png` |
| `blood`, `gothic` | Dracula | `vampire-castle.jpg` |
| `frappe`, `cool` | Catppuccin Frappe | `modern-frappe.png` |

**Fallback**: Unmatched wallpapers get themes via round-robin assignment.

## Available Themes

| Theme | Description | Apps Supported |
|-------|-------------|----------------|
| Nord | Arctic blue theme | All |
| Catppuccin Mocha | Warm dark theme | All |
| Catppuccin Macchiato | Ocean-inspired | All |
| Catppuccin Frappe | Cool modern | All |
| Catppuccin Latte | Light & bright | All |
| Gruvbox | Retro green | All |
| Tokyo Night | Night-inspired | All |
| Dracula | Gothic purple | All |
| Everforest | Forest green | All |

## Usage

### Keybindings
- `Super+W`: Toggle to next wallpaper/theme
- Waybar theme indicator: Left-click for next, right-click for previous

### Command Line
```bash
# Toggle to next wallpaper/theme combo
./scripts/wallpaper-toggle.sh toggle

# Go to previous wallpaper/theme combo
./scripts/wallpaper-toggle.sh prev

# Show current status and all available wallpapers
./scripts/wallpaper-toggle.sh status
```

### Adding New Wallpapers

1. **Drop wallpapers** into appropriate folders:
   - `wallpapers/winter/` for cold/snow themes
   - `wallpapers/night/` for dark/night themes
   - `wallpapers/day/` for bright/light themes
   - `wallpapers/retro/` for classic themes
   - `wallpapers/special/` for custom overrides

2. **Themes are assigned automatically** based on filename patterns

3. **No manual configuration needed** - the system handles everything!

### Examples
```bash
# Add winter wallpapers
cp ~/Downloads/snow-mountain.jpg wallpapers/winter/
cp ~/Downloads/ice-lake.png wallpapers/winter/

# Add night wallpapers
cp ~/Downloads/cyberpunk-night.jpg wallpapers/night/
cp ~/Downloads/moonlight.png wallpapers/night/

# System automatically assigns Nord theme to winter images
# and Catppuccin Mocha to night images
v```

## How It Works

1. **Wallpaper Change**: Uses `swww` to change the desktop wallpaper
2. **Theme Application**:
   - **WezTerm**: Sets `WEZTERM_THEME` environment variable and triggers reload
   - **GTK**: Updates GTK theme via `gsettings` and color scheme files
   - **Waybar**: Switches CSS theme files and sends reload signal
   - **Starship**: Updates `STARSHIP_THEME` environment variable
   - **Kitty**: Ready for theme switching (requires additional setup)

## Customization

### Adding New Themes

1. Add theme definition to `.config/themes/themes.json`
2. Create corresponding CSS files:
   - `.config/themes/waybar-[theme].css` for Waybar
   - `.config/themes/gtk-[theme].css` for GTK colors
3. Update wallpaper mappings in the JSON config
4. Update the `get_wallpapers()` and `get_theme_for_wallpaper()` functions in the script

### Theme Files Structure

```
.config/themes/
├── themes.json          # Main configuration
├── waybar-nord.css      # Waybar Nord theme
├── waybar-gruvbox.css   # Waybar Gruvbox theme
├── gtk-nord.css         # GTK Nord colors
└── gtk-gruvbox.css      # GTK Gruvbox colors
```

## Dependencies

- `swww`: Wallpaper switching
- `jq`: JSON parsing (optional - script works without it now)
- `gsettings`: GTK theme switching
- `dunstify`: Notifications (optional)

## Migration from Old System

The old `wallpaperswitch.sh` has been removed. The new system:
- Removes automatic wallpaper cycling
- Adds manual control via `Super+W`
- Syncs themes with wallpapers
- Provides Waybar integration

Your Hyprland config has been updated to remove the old script and add the new keybinding.