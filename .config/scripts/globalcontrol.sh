#!/usr/bin/env sh

# Only the essential variables needed for wlogout
export confDir="${XDG_CONFIG_HOME:-$HOME/.config}"
export hypr_border=2  # Adjust this value as needed

# Not using hyde theme, so we don't need these checks
export enableWallDcol=0
export dcol_mode="dark"
