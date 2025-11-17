#!/bin/bash
# Update starship palette
# Usage: update_starship_palette.sh <palette_name>

PALETTE_NAME="$1"
CONFIG_FILE="$HOME/.config/starship/starship.toml"

if [[ -z "$PALETTE_NAME" ]]; then
    echo "Usage: $0 <palette_name>"
    exit 1
fi

# Update the palette in starship config
sed -i "s/palette = '[^']*'/palette = '$PALETTE_NAME'/" "$CONFIG_FILE"

echo "Starship palette updated to: $PALETTE_NAME"