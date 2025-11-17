#!/bin/bash
# Wait for swww to be fully initialized
while ! swww query &>/dev/null; do
    echo "Waiting for swww to initialize..."
    sleep 1
done
# Path to wallpapers folder
WALLPAPER_DIR="/home/gary/dotfiles/wallpapers"
# Time between transitions in seconds
#interval=800 # 3 seconds
interval=15 # 3 seconds

# File to store previously displayed wallpapers
HISTORY_FILE="/tmp/wallpaper_history.txt"

# Create empty history file if it doesn't exist
if [ ! -f "$HISTORY_FILE" ]; then
    touch "$HISTORY_FILE"
fi

while true; do
    # Get a list of all image files in the wallpaper directory
    mapfile -t all_wallpapers < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \))

    # Check if any wallpapers were found
    if [ ${#all_wallpapers[@]} -eq 0 ]; then
        echo "No wallpapers found in $WALLPAPER_DIR"
        exit 1
    fi

    # Get previously displayed wallpapers
    mapfile -t displayed_wallpapers <"$HISTORY_FILE"

    # If all wallpapers have been displayed, clear the history
    if [ ${#displayed_wallpapers[@]} -ge ${#all_wallpapers[@]} ]; then
        >"$HISTORY_FILE"
        displayed_wallpapers=()
    fi

    # Create a list of wallpapers that haven't been displayed yet
    available_wallpapers=()
    for wp in "${all_wallpapers[@]}"; do
        # Check if the wallpaper is not in the displayed list
        if ! grep -q "^$wp$" "$HISTORY_FILE"; then
            available_wallpapers+=("$wp")
        fi
    done

    # Select a random wallpaper from available ones
    RANDOM=$$$(date +%s)
    random_index=$((RANDOM % ${#available_wallpapers[@]}))
    random_wallpaper="${available_wallpapers[$random_index]}"

    # Apply the wallpaper with swww
    swww img "$random_wallpaper" --transition-type grow --transition-duration 3
    # Nudge WezTerm to reload its config (so it picks up the new swww wallpaper)
    touch /home/gary/.cache/wezterm-wallpaper-reload
    # Add the wallpaper to the history
    echo "$random_wallpaper" >>"$HISTORY_FILE"

    sleep $interval
done
