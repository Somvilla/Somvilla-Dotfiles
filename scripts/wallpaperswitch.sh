#!/bin/bash

# Array of wallpapers
wallpapers=(
    "/usr/share/endeavouros/backgrounds/endeavouros-wallpaper.png"
    "/home/somvilla/Downloads/1348185.png"
    "/home/somvilla/Downloads/01.jpg"
)

# Time between transitions in seconds
interval=300  # 5 minutes

# Optional: transition effect using swww (if installed)
# You'll need to install swww first: https://github.com/Horus645/swww

while true; do
    for wallpaper in "${wallpapers[@]}"; do
        # If using swww for animations:
        swww img "$wallpaper" --transition-type grow --transition-duration 3
        
        # If using swaybg (no animations):
        # swaybg -i "$wallpaper" -m fill &
        # pkill -f "swaybg -i .* -m fill" > /dev/null
        
        sleep $interval
    done
done
