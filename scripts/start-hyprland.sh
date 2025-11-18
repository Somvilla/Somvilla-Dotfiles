#!/bin/bash
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_CONFIG_HOME=$HOME/.config
export PATH=$HOME/.local/bin:$PATH
exec Hyprland