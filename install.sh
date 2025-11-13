#!/bin/bash
# Install script for dotfiles
set -e

echo "Backing up existing configs..."
mkdir -p ~/config_backup
cp -r ~/.config/* ~/config_backup/ 2>/dev/null || true

echo "Installing yay (AUR helper)..."
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay && makepkg -si --noconfirm
cd ~ && rm -rf ~/yay

echo "Installing required packages..."
sudo pacman -S --needed hyprland waybar kitty fish starship rofi nemo nvim cava swaync wlogout wofi gtk3 gtk4 pavucontrol btop ollama git nodejs npm python

echo "Installing AMD gaming packages..."
yay -S --noconfirm proton-ge-custom mangohud vkbasalt lutris wine dxvk lib32-vulkan-mesa-layers

echo "Installing OpenCode..."
curl -fsSL https://opencode.ai/install | bash

echo "Running symlink setup..."
bash setup_symlinks.sh

echo "Verifying symlinks..."
if [ -L ~/.config/hypr/hyprland.conf ]; then
    echo "Symlinks created successfully!"
else
    echo "Warning: Symlinks may not have been created properly."
fi

echo "Installation complete! Reboot to apply changes."