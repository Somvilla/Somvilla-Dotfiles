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

# Get all wallpapers from organized folders
get_wallpapers() {
    # Find all image files in wallpaper subdirectories
    find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | sort
}

get_theme_for_wallpaper() {
    local wallpaper="$1"
    local filename=$(basename "$wallpaper" .png)
    filename=$(basename "$filename" .jpg)
    filename=$(basename "$filename" .jpeg)

    # Smart pattern-based theme assignment (order matters - more specific first)
    if [[ "$filename" =~ (dragon|lair) ]]; then
        echo "gruvbox"
    elif [[ "$filename" =~ (fire|mythical) ]]; then
        echo "everforest"
    elif [[ "$filename" =~ (blood|vampire|gothic|castle) ]]; then
        echo "dracula"
    elif [[ "$filename" =~ (fantasy|magic|mystical|dream|forest) ]]; then
        echo "tokyo-night"
    elif [[ "$filename" =~ (winter|snow|cold|ice|arctic|frozen|polar) ]]; then
        echo "nord"
    elif [[ "$filename" =~ (retro|old|classic|vintage|pixel|8bit|game) ]]; then
        echo "gruvbox"
    elif [[ "$filename" =~ (neon|cyberpunk|cyber|synthwave) ]]; then
        echo "catppuccin-macchiato"
    elif [[ "$filename" =~ (night|dark|moon|space|midnight|evening|rainy|storm) ]]; then
        echo "catppuccin-mocha"
    elif [[ "$filename" =~ (day|sun|bright|light|morning|sunrise|sunset|dawn) ]]; then
        echo "catppuccin-latte"
    elif [[ "$filename" =~ (city|urban|street|building) ]]; then
        echo "catppuccin-frappe"
    else
        # Round-robin fallback for unmatched wallpapers
        local themes=("nord" "catppuccin-mocha" "catppuccin-macchiato" "catppuccin-frappe" "catppuccin-latte" "gruvbox" "tokyo-night" "dracula" "everforest")
        local index=$(( $(echo "$filename" | cksum | cut -d' ' -f1) % ${#themes[@]} ))
        echo "${themes[$index]}"
    fi
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
    local wallpaper_path="$1"

    if [[ ! -f "$wallpaper_path" ]]; then
        echo "Error: Wallpaper $wallpaper_path not found"
        return 1
    fi

    local wallpaper_name=$(basename "$wallpaper_path")
    echo "Applying wallpaper: $wallpaper_name"
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
        # Kill and restart Waybar for immediate theme update
        killall waybar 2>/dev/null || true
        sleep 0.1
        waybar &
    fi

    # GTK colors
    local gtk_css="$DOTFILES_DIR/.config/themes/gtk-$waybar_theme.css"
    if [[ -f "$gtk_css" ]]; then
        ln -sf "$gtk_css" "$DOTFILES_DIR/.config/gtk-3.0/theme-colors.css"
        ln -sf "$gtk_css" "$DOTFILES_DIR/.config/gtk-4.0/theme-colors.css"
    fi

    # Starship theme
    local starship_theme=$(get_theme_value "$theme_config" "starship")
    # Update starship palette using dedicated script
    if [[ -n "$starship_theme" ]]; then
        "$DOTFILES_DIR/scripts/update_starship_palette.sh" "$starship_theme" 2>/dev/null || true
    fi

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
    local wallpaper_path="${wallpapers[$next_index]}"
    local wallpaper_name=$(basename "$wallpaper_path")
    local theme=$(get_theme_for_wallpaper "$wallpaper_name")
    local theme_config=$(get_theme_config "$theme")

    echo "Switching to: $wallpaper_name ($theme)"

    # Apply wallpaper and theme
    apply_wallpaper "$wallpaper_path"
    apply_theme "$theme" "$theme_config"

    # Save state
    save_current_index "$next_index"

    # Send notification
    if command -v dunstify &> /dev/null; then
        dunstify -a "Rice Toggle" -u low "Theme Changed" "Wallpaper: $wallpaper_name\nTheme: $theme"
    fi
}

# Show current status
show_status() {
    local wallpapers=($(get_wallpapers))
    local current_index=$(get_current_index)
    local wallpaper_path="${wallpapers[$current_index]}"
    local wallpaper_name=$(basename "$wallpaper_path")
    local theme=$(get_theme_for_wallpaper "$wallpaper_name")

    echo "Current: $wallpaper_name ($theme)"
    echo "Available wallpapers:"
    for i in "${!wallpapers[@]}"; do
        local marker=" "
        [[ $i -eq $current_index ]] && marker=">"
        local name=$(basename "${wallpapers[$i]}")
        echo "  $marker $name"
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