#!/bin/bash
# Category cycling script for Waybar
# Cycles through available wallpaper categories

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CACHE_DIR="$HOME/.cache"
CURRENT_CATEGORY_FILE="$CACHE_DIR/current_wallpaper_category"

# Get available categories (excluding 'all')
get_categories() {
    find "$SCRIPT_DIR/../wallpapers" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | grep -v '^$' | sort
}

# Get current category
get_current_category() {
    if [[ -f "$CURRENT_CATEGORY_FILE" ]]; then
        cat "$CURRENT_CATEGORY_FILE"
    else
        echo "all"
    fi
}

# Cycle to next category
next_category() {
    local categories=($(get_categories))
    categories+=("all")  # Add 'all' as the last option
    local current=$(get_current_category)

    # Find current index
    local current_index=-1
    for i in "${!categories[@]}"; do
        if [[ "${categories[$i]}" == "$current" ]]; then
            current_index=$i
            break
        fi
    done

    # Calculate next index
    local next_index=$(( (current_index + 1) % ${#categories[@]} ))
    local next_category="${categories[$next_index]}"

    # Set new category
    "$SCRIPT_DIR/wallpaper-toggle.sh" set-category "$next_category" > /dev/null 2>&1
    echo "$next_category"
}

# Handle different actions
case "${1:-current}" in
    "current")
        get_current_category
        ;;
    "next")
        next_category
        ;;
    "list")
        get_categories
        ;;
    *)
        get_current_category
        ;;
esac