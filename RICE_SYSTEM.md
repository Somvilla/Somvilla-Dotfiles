# Ultimate Rice Wallpaper-Theme Toggle System

This system replaces the old automatic wallpaper switching with a manual toggle that changes both wallpapers and themes simultaneously for a cohesive desktop experience.

## Features

- **Wallpaper + Theme Sync**: Each wallpaper is paired with a complete theme
- **Manual Control**: Press `Super+W` to cycle through themes instead of automatic switching
- **Multi-App Support**: Updates themes for WezTerm, GTK, Waybar, Starship, and Kitty
- **Waybar Integration**: Click the theme indicator in Waybar to toggle themes
- **State Persistence**: Remembers your current theme across sessions

## Current Wallpaper-Theme Mappings

| Wallpaper | Theme | Description |
|-----------|-------|-------------|
| `winter-is-coming-1.png` | Nord | Cool blue theme |
| `winter-is-coming-2.png` | Catppuccin Mocha | Warm mocha theme |
| `City-Night.png` | Catppuccin Macchiato | Ocean-inspired theme |
| `City-Rainy-Night.png` | Gruvbox | Retro green theme |
| `Clearnight.jpg` | Nord | Cool blue theme |
| `Cloudsnight.jpg` | Catppuccin Mocha | Warm mocha theme |
| `dragon.png` | Gruvbox | Retro green theme |
| `Fantasy-Lanscape-Night.png` | Catppuccin Macchiato | Ocean-inspired theme |
| `Neon_Cities_4-C0750.jpg` | Catppuccin Mocha | Warm mocha theme |

## Usage

### Keybindings
- `Super+W`: Toggle to next wallpaper/theme
- Waybar theme indicator: Left-click for next, right-click for previous

### Command Line
```bash
# Toggle to next theme
./scripts/wallpaper-toggle.sh toggle

# Go to previous theme
./scripts/wallpaper-toggle.sh prev

# Show current theme and available options
./scripts/wallpaper-toggle.sh status
```

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