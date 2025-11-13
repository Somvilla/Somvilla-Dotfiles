#!/bin/bash
# Install script for dotfiles
set -e

echo "Installing required packages..."
sudo pacman -S --needed hyprland waybar kitty fish starship rofi nemo nvim cava swaync wlogout wofi gtk3 gtk4 pavucontrol btop ollama

echo "Running symlink setup..."
bash setup_symlinks.sh

echo "Installation complete! Reboot to apply changes."