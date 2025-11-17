#!/bin/bash
# Ultimate Rice Wallpaper-Theme Toggle Script
# Cycles through wallpapers and applies corresponding themes

set -e

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEMES_CONFIG="$DOTFILES_DIR/.config/themes/themes.json"
CACHE_DIR="$HOME/.cache"
CURRENT_STATE_FILE="$CACHE_DIR/current_wallpaper_theme"
WALLPAPER_DIR="$DOTFILES_DIR/wallpapers"

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# Simple JSON parsing functions (no jq dependency)
get_wallpapers() {
    # Hardcoded list for now - matches the JSON config
    echo "winter-is-coming-1.png"
    echo "winter-is-coming-2.png"
    echo "City-Night.png"
    echo "City-Rainy-Night.png"
    echo "Clearnight.jpg"
    echo "Cloudsnight.jpg"
    echo "dragon.png"
    echo "Fantasy-Lanscape-Night.png"
    echo "Neon_Cities_4-C0750.jpg"
}

get_theme_for_wallpaper() {
    local wallpaper="$1"
    case "$wallpaper" in
        "winter-is-coming-1.png") echo "nord" ;;
        "winter-is-coming-2.png") echo "catppuccin-mocha" ;;
        "City-Night.png") echo "catppuccin-macchiato" ;;
        "City-Rainy-Night.png") echo "gruvbox" ;;
        "Clearnight.jpg") echo "nord" ;;
        "Cloudsnight.jpg") echo "catppuccin-mocha" ;;
        "dragon.png") echo "gruvbox" ;;
        "Fantasy-Lanscape-Night.png") echo "catppuccin-macchiato" ;;
        "Neon_Cities_4-C0750.jpg") echo "catppuccin-mocha" ;;
        *) echo "catppuccin-mocha" ;; # fallback
    esac
}

get_theme_config() {
    local theme="$1"
    case "$theme" in
        "nord")
            cat << 'EOF'
"name": "Nord",
"wezterm": "nord",
"gtk": "Nordic",
"waybar": "nord",
"starship": "nord",
"kitty": "Nord"
EOF
            ;;
        "catppuccin-mocha")
            cat << 'EOF'
"name": "Catppuccin Mocha",
"wezterm": "catppuccin",
"gtk": "Catppuccin-Mocha-Standard-Blue-Dark",
"waybar": "catppuccin-mocha",
"starship": "catppuccin_mocha",
"kitty": "Catppuccin Mocha"
EOF
            ;;
        "catppuccin-macchiato")
            cat << 'EOF'
"name": "Catppuccin Macchiato",
"wezterm": "catppuccin",
"gtk": "Catppuccin-Macchiato-Standard-Blue-Dark",
"waybar": "catppuccin-macchiato",
"starship": "catppuccin_mocha",
"kitty": "Catppuccin Macchiato"
EOF
            ;;
        "gruvbox")
            cat << 'EOF'
"name": "Gruvbox",
"wezterm": "onedark",
"gtk": "Gruvbox-Dark",
"waybar": "gruvbox",
"starship": "gruvbox_dark",
"kitty": "Gruvbox Dark"
EOF
            ;;
    esac
}

get_theme_value() {
    local theme_config="$1"
    local key="$2"
    echo "$theme_config" | grep "\"$key\":" | sed 's/.*: "\([^"]*\)",*/\1/' | sed 's/"//g'
}

# Get current wallpaper index
get_current_index() {
    if [[ -f "$CURRENT_STATE_FILE" ]]; then
        cat "$CURRENT_STATE_FILE"
    else
        echo "0"
    fi
}

# Save current wallpaper index
save_current_index() {
    echo "$1" > "$CURRENT_STATE_FILE"
}

# Apply wallpaper
apply_wallpaper() {
    local wallpaper="$1"
    local wallpaper_path="$WALLPAPER_DIR/$wallpaper"

    # Check if wallpaper exists directly, or in winter/ subdirectory
    if [[ ! -f "$wallpaper_path" ]]; then
        wallpaper_path="$WALLPAPER_DIR/winter/$wallpaper"
        if [[ ! -f "$wallpaper_path" ]]; then
            echo "Error: Wallpaper $wallpaper not found in $WALLPAPER_DIR or $WALLPAPER_DIR/winter/"
            return 1
        fi
    fi

    echo "Applying wallpaper: $wallpaper"
    swww img "$wallpaper_path" --transition-type grow --transition-duration 1

    # Trigger WezTerm reload
    touch "$HOME/.cache/wezterm-wallpaper-reload"
}

# Apply theme to applications
apply_theme() {
    local theme="$1"
    local theme_config="$2"

    echo "Applying theme: $theme"

    # WezTerm theme
    local wezterm_theme=$(get_theme_value "$theme_config" "wezterm")
    export WEZTERM_THEME="$wezterm_theme"

    # GTK theme
    local gtk_theme=$(get_theme_value "$theme_config" "gtk")
    if command -v gsettings &> /dev/null; then
        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null || true
    fi

    # Waybar theme
    local waybar_theme=$(get_theme_value "$theme_config" "waybar")
    local waybar_css="$DOTFILES_DIR/.config/themes/waybar-$waybar_theme.css"
    if [[ -f "$waybar_css" ]]; then
        ln -sf "$waybar_css" "$DOTFILES_DIR/.config/waybar/theme.css"
        pkill -RTMIN+1 waybar || true
    fi

    # GTK colors
    local gtk_css="$DOTFILES_DIR/.config/themes/gtk-$waybar_theme.css"
    if [[ -f "$gtk_css" ]]; then
        ln -sf "$gtk_css" "$DOTFILES_DIR/.config/gtk-3.0/theme-colors.css"
        ln -sf "$gtk_css" "$DOTFILES_DIR/.config/gtk-4.0/theme-colors.css"
    fi

    # Starship theme
    local starship_theme=$(get_theme_value "$theme_config" "starship")
    export STARSHIP_THEME="$starship_theme"

    # Kitty theme (reload via signal)
    local kitty_theme=$(get_theme_value "$theme_config" "kitty")
    # Kitty theme switching would require additional setup

    # Reload affected applications
    # WezTerm reloads automatically via file watch
    # Waybar reloads via signal above
}

# Main toggle function
toggle_wallpaper_theme() {
    local wallpapers=($(get_wallpapers))
    local current_index=$(get_current_index)
    local next_index=$(( (current_index + 1) % ${#wallpapers[@]} ))
    local wallpaper="${wallpapers[$next_index]}"
    local theme=$(get_theme_for_wallpaper "$wallpaper")
    local theme_config=$(get_theme_config "$theme")

    echo "Switching to: $wallpaper ($theme)"

    # Apply wallpaper and theme
    apply_wallpaper "$wallpaper"
    apply_theme "$theme" "$theme_config"

    # Save state
    save_current_index "$next_index"

    # Send notification
    if command -v dunstify &> /dev/null; then
        dunstify -a "Rice Toggle" -u low "Theme Changed" "Wallpaper: $wallpaper\nTheme: $theme"
    fi
}

# Show current status
show_status() {
    local wallpapers=($(get_wallpapers))
    local current_index=$(get_current_index)
    local wallpaper="${wallpapers[$current_index]}"
    local theme=$(get_theme_for_wallpaper "$wallpaper")

    echo "Current: $wallpaper ($theme)"
    echo "Available wallpapers:"
    for i in "${!wallpapers[@]}"; do
        local marker=" "
        [[ $i -eq $current_index ]] && marker=">"
        echo "  $marker ${wallpapers[$i]}"
    done
}

# Parse arguments
case "${1:-toggle}" in
    "toggle")
        toggle_wallpaper_theme
        ;;
    "status")
        show_status
        ;;
    "next")
        toggle_wallpaper_theme
        ;;
    "prev")
        # Go backwards
        local wallpapers=($(get_wallpapers))
        local current_index=$(get_current_index)
        local prev_index=$(( current_index == 0 ? ${#wallpapers[@]} - 1 : current_index - 1 ))
        save_current_index "$prev_index"
        toggle_wallpaper_theme
        ;;
    *)
        echo "Usage: $0 [toggle|status|next|prev]"
        echo "  toggle: Switch to next wallpaper/theme (default)"
        echo "  status: Show current wallpaper/theme"
        echo "  next: Same as toggle"
        echo "  prev: Switch to previous wallpaper/theme"
        exit 1
        ;;
esac