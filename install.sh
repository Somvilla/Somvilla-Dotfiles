#!/bin/bash
# Install script for dotfiles
set -e

echo "Backing up existing configs..."
mkdir -p ~/config_backup
cp -r ~/.config/* ~/config_backup/ 2>/dev/null || true

echo "Installing base system packages..."
sudo pacman -S --needed git base-devel xorg-xwayland xorg-server mesa vulkan-icd-loader

echo "Installing display manager..."
sudo pacman -S --needed sddm

echo "Installing yay (AUR helper)..."
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay && makepkg -si --noconfirm
cd ~ && rm -rf ~/yay

echo "Installing Hyprland and desktop packages..."
sudo pacman -S --needed stow hyprland waybar kitty fish starship rofi nemo nvim cava swaync wofi gtk3 gtk4 pavucontrol btop ollama git nodejs npm python swww ulauncher

echo "Installing AMD gaming packages..."
yay -S --noconfirm proton-ge-custom mangohud vkbasalt lutris wine dxvk lib32-vulkan-mesa-layers wlogout

echo "Installing OpenCode..."
curl -fsSL https://opencode.ai/install | bash

echo "Creating Hyprland session file..."
sudo tee /usr/share/wayland-sessions/hyprland.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=/home/$USER/dotfiles/scripts/start-hyprland.sh
Type=Application
EOF

echo "Creating Hyprland startup script..."
cat > ~/dotfiles/scripts/start-hyprland.sh <<EOF
#!/bin/bash
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_CONFIG_HOME=\$HOME/.config
export PATH=\$HOME/.local/bin:\$PATH
exec Hyprland
EOF
chmod +x ~/dotfiles/scripts/start-hyprland.sh

echo "Enabling display manager..."
sudo systemctl enable sddm

echo "Running stow setup..."
bash setup_stow.sh

echo "Installation complete! Reboot to start your Hyprland desktop environment."
