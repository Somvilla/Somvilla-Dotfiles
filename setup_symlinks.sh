#!/bin/bash

# Setup script for dotfiles symlinks
# This will create symlinks from your dotfiles repo to your ~/.config directory

# Exit on error
set -e

# Create the config directory if it doesn't exist
mkdir -p ~/.config

# Define dotfiles directory (where this script is located)
DOTFILES_DIR="$HOME/dotfiles"

echo "Creating symlinks from $DOTFILES_DIR to ~/.config"

# Hyprland
echo "Setting up Hyprland config..."
mkdir -p ~/.config/hypr
ln -sf "$DOTFILES_DIR/hypr/hyprland.conf" ~/.config/hypr/hyprland.conf
ln -sf "$DOTFILES_DIR/hypr/hyprlock.conf" ~/.config/hypr/hyprlock.conf
ln -sf "$DOTFILES_DIR/hypr/keybindings.conf" ~/.config/hypr/keybindings.conf
ln -sf "$DOTFILES_DIR/hypr/layout.conf" ~/.config/hypr/layout.conf
ln -sf "$DOTFILES_DIR/hypr/windowrules.conf" ~/.config/hypr/windowrules.conf

# Waybar
echo "Setting up Waybar config..."
mkdir -p ~/.config/waybar
ln -sf "$DOTFILES_DIR/waybar/config" ~/.config/waybar/config
ln -sf "$DOTFILES_DIR/waybar/style.css" ~/.config/waybar/style.css
ln -sf "$DOTFILES_DIR/waybar/macchiato.css" ~/.config/waybar/macchiato.css
mkdir -p ~/.config/waybar/modules
ln -sf "$DOTFILES_DIR/waybar/modules/power.jsonc" ~/.config/waybar/modules/power.jsonc
mkdir -p ~/.config/waybar/scripts
ln -sf "$DOTFILES_DIR/waybar/scripts/"* ~/.config/waybar/scripts/

# Kitty terminal
echo "Setting up kitty config..."
mkdir -p ~/.config/kitty
ln -sf "$DOTFILES_DIR/kitty/kitty.conf" ~/.config/kitty/kitty.conf

# Fish shell
echo "Setting up fish config..."
mkdir -p ~/.config/fish
ln -sf "$DOTFILES_DIR/fish/config.fish" ~/.config/fish/config.fish
ln -sf "$DOTFILES_DIR/fish/fish_variables" ~/.config/fish/fish_variables
mkdir -p ~/.config/fish/functions
ln -sf "$DOTFILES_DIR/fish/functions/"* ~/.config/fish/functions/
mkdir -p ~/.config/fish/completions
ln -sf "$DOTFILES_DIR/fish/completions/"* ~/.config/fish/completions/
mkdir -p ~/.config/fish/conf.d
ln -sf "$DOTFILES_DIR/fish/conf.d/"* ~/.config/fish/conf.d/

# GTK themes
echo "Setting up GTK themes..."
mkdir -p ~/.config/gtk-3.0
ln -sf "$DOTFILES_DIR/gtk-3.0/settings.ini" ~/.config/gtk-3.0/settings.ini
ln -sf "$DOTFILES_DIR/gtk-3.0/gtk.css" ~/.config/gtk-3.0/gtk.css
ln -sf "$DOTFILES_DIR/gtk-3.0/colors.css" ~/.config/gtk-3.0/colors.css
ln -sf "$DOTFILES_DIR/gtk-3.0/window_decorations.css" ~/.config/gtk-3.0/window_decorations.css
ln -sf "$DOTFILES_DIR/gtk-3.0/bookmarks" ~/.config/gtk-3.0/bookmarks
mkdir -p ~/.config/gtk-3.0/assets
ln -sf "$DOTFILES_DIR/gtk-3.0/assets/"* ~/.config/gtk-3.0/assets/

mkdir -p ~/.config/gtk-4.0
ln -sf "$DOTFILES_DIR/gtk-4.0/settings.ini" ~/.config/gtk-4.0/settings.ini
ln -sf "$DOTFILES_DIR/gtk-4.0/gtk.css" ~/.config/gtk-4.0/gtk.css
ln -sf "$DOTFILES_DIR/gtk-4.0/colors.css" ~/.config/gtk-4.0/colors.css
ln -sf "$DOTFILES_DIR/gtk-4.0/window_decorations.css" ~/.config/gtk-4.0/window_decorations.css
mkdir -p ~/.config/gtk-4.0/assets
ln -sf "$DOTFILES_DIR/gtk-4.0/assets/"* ~/.config/gtk-4.0/assets/

# Wofi
echo "Setting up wofi config..."
mkdir -p ~/.config/wofi
ln -sf "$DOTFILES_DIR/wofi/config" ~/.config/wofi/config
ln -sf "$DOTFILES_DIR/wofi/style.css" ~/.config/wofi/style.css

# Wlogout
echo "Setting up wlogout config..."
mkdir -p ~/.config/wlogout
ln -sf "$DOTFILES_DIR/wlogout/layout_1" ~/.config/wlogout/layout_1
ln -sf "$DOTFILES_DIR/wlogout/layout_2" ~/.config/wlogout/layout_2
ln -sf "$DOTFILES_DIR/wlogout/style_1.css" ~/.config/wlogout/style_1.css
ln -sf "$DOTFILES_DIR/wlogout/style_2.css" ~/.config/wlogout/style_2.css

# Cava
echo "Setting up cava config..."
mkdir -p ~/.config/cava
ln -sf "$DOTFILES_DIR/cava/config" ~/.config/cava/config
mkdir -p ~/.config/cava/shaders
ln -sf "$DOTFILES_DIR/cava/shaders/"* ~/.config/cava/shaders/

# Btop
echo "Setting up btop config..."
mkdir -p ~/.config/btop
ln -sf "$DOTFILES_DIR/btop/btop.conf" ~/.config/btop/btop.conf
ln -sf "$DOTFILES_DIR/btop/btop.log" ~/.config/btop/btop.log

# Nemo
echo "Setting up nemo config..."
mkdir -p ~/.config/nemo
ln -sf "$DOTFILES_DIR/nemo/bookmark-metadata" ~/.config/nemo/bookmark-metadata

# Neovim
echo "Setting up nvim config..."
mkdir -p ~/.config/nvim
ln -sf "$DOTFILES_DIR/nvim/init.lua" ~/.config/nvim/init.lua
ln -sf "$DOTFILES_DIR/nvim/lazy-lock.json" ~/.config/nvim/lazy-lock.json

# SwayNC
echo "Setting up swaync config..."
mkdir -p ~/.config/swaync
ln -sf "$DOTFILES_DIR/swaync/config.json" ~/.config/swaync/config.json
ln -sf "$DOTFILES_DIR/swaync/style.css" ~/.config/swaync/style.css

# Scripts directory
echo "Setting up scripts..."
mkdir -p ~/.local/bin
ln -sf "$DOTFILES_DIR/scripts/globalcontrol.sh" ~/.local/bin/globalcontrol
ln -sf "$DOTFILES_DIR/scripts/launchlogout.sh" ~/.local/bin/launchlogout
ln -sf "$DOTFILES_DIR/scripts/wallpaperswitch.sh" ~/.local/bin/wallpaperswitch

echo "Symlinks created successfully!"
echo "You may need to reload your window manager or logout/login for changes to take effect."