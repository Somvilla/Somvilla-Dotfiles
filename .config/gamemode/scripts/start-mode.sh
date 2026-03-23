#!/bin/bash

# --- CONFIGURATION AREA ---

# Your specific heavy containers
# I included the DB/Redis containers for kasm/snake_game to free up RAM
DOCKER_TARGETS=(
    "openwebui-openwebui-1"
    "kasm"
    "jellyfin"
    "code-server"
    "snake_game_postgres"
    "snake_game_redis"
)

echo "Stopping Ollama service..."
sudo systemctl stop ollama
# Kasm often runs aggressive specialized services.
# If Kasm was installed via standard script, stopping the docker container
# usually pauses the heavy lifting, but we can also be safe:
# SERVICE_TARGETS=("kasm-workspaces.service")

# ---------------------------
# Close memory-heavy apps (optional - adjust to your needs)
echo "Closing heavy desktop apps..."

# Close VS Code
pkill -f "visual-studio-code"

# Close Spotify
pkill -f spotify

# Close Discord (Flatpak)
#flatpak kill com.discordapp.Discord 2>/dev/null

# Close Obsidian
pkill -f obsidian

# Close Proton Mail
pkill -f "Proton Mail"

# Optional: Close Firefox if you don't need it while gaming
# pkill -f firefox
echo "Game Mode: Purging AI and Server tasks..."

# 1. Stop Docker Containers
if [ ${#DOCKER_TARGETS[@]} -gt 0 ]; then
    for container in "${DOCKER_TARGETS[@]}"; do
        # Only stop if it is actually running
        if docker ps -q -f name="^${container}$" | grep -q .; then
            echo "Stopping $container..."
            docker stop "$container" &
        fi
    done
fi

# 2. Force sync memory buffers to disk to free RAM immediately
sync
echo 3 >/proc/sys/vm/drop_caches

# Wait for stop commands to finish
wait

notify-send -t 3000 "Game Mode Active" "OpenWebUI, Kasm & Jellyfin stopped."
