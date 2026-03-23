#!/bin/bash

# --- CONFIGURATION AREA ---
# Which ones do you want to Auto-Start?
# You might not want Kasm/Jellyfin running 24/7 unless you need them immediately.
# I have commented out the ones you might prefer to start manually.

DOCKER_RESTART=(
    "openwebui-openwebui-1"
    "kasm"
    # "jellyfin"
    # "code-server"
    # "snake_game_postgres"
    # "snake_game_redis"
)

# ---------------------------
echo "Starting Ollama service..."
sudo systemctl start ollama
echo "Game Mode: Restoring services..."

# 1. Restart Docker Containers
if [ ${#DOCKER_RESTART[@]} -gt 0 ]; then
    for container in "${DOCKER_RESTART[@]}"; do
        echo "Starting $container..."
        docker start "$container" &
    done
fi

notify-send -t 3000 "Game Mode Ended" "AI Services restored."
