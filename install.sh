#!/bin/bash
# Install script for dotfiles
set -e

echo "Backing up existing configs..."
mkdir -p ~/config_backup
cp -r ~/.config/* ~/config_backup/ 2>/dev/null || true

echo "Caching sudo credentials..."
sudo -v
# Keep sudo credentials alive in background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Installing base system packages and display manager..."
sudo pacman -S --needed git base-devel xorg-xwayland xorg-server mesa vulkan-icd-loader sddm

echo "Installing yay (AUR helper)..."
git clone https://aur.archlinux.org/yay.git ~/yay
cd ~/yay && makepkg -si --noconfirm
cd ~ && rm -rf ~/yay

echo "Installing Hyprland and desktop packages..."
sudo pacman -S --needed stow hyprland waybar kitty fish starship rofi nemo nvim cava swaync wofi gtk3 gtk4 pavucontrol btop ollama nodejs npm python swww ulauncher

echo "Installing AMD gaming packages..."
yay -S --noconfirm proton-ge-custom mangohud vkbasalt lutris wine dxvk lib32-vulkan-mesa-layers wlogout

echo "Installing OpenCode..."
curl -fsSL https://opencode.ai/install | bash

echo "Checking for VM environment and applying fixes..."
# Detect VM environment
if systemd-detect-virt | grep -q -E "(kvm|qemu|virtualbox|vmware)"; then
    echo "VM environment detected - installing session management and graphics fixes"

    # Install seatd for proper session management in VMs
    sudo pacman -S --needed seatd
    sudo systemctl enable --now seatd
    sudo usermod -a -G seat $USER

    # Install VM-specific graphics packages
    if systemd-detect-virt | grep -q qemu; then
        sudo pacman -S --needed qemu-guest-agent
        yay -S --noconfirm virtio-gpu-tools 2>/dev/null || true
    elif systemd-detect-virt | grep -q virtualbox; then
        sudo pacman -S --needed virtualbox-guest-utils
    fi

    # Create VM-safe startup script with software rendering
    echo "Creating VM-compatible startup script..."
    cat > ~/dotfiles/scripts/start-hyprland-vm.sh <<EOF
#!/bin/bash
# VM-safe Hyprland startup script

# Force software rendering to avoid GPU backend issues in VMs
export AQ_NO_GPU=1
export LIBGL_ALWAYS_SOFTWARE=1

# Set proper session environment
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_CONFIG_HOME=\$HOME/.config
export PATH=\$HOME/.local/bin:\$PATH

# Use logind backend for seat management
export LIBSEAT_BACKEND=logind

exec Hyprland
EOF
    chmod +x ~/dotfiles/scripts/start-hyprland-vm.sh

    # Use VM script for desktop file
    VM_STARTUP_SCRIPT="/home/$USER/dotfiles/scripts/start-hyprland-vm.sh"
else
    # Use regular script for physical hardware
    VM_STARTUP_SCRIPT="/home/$USER/dotfiles/scripts/start-hyprland.sh"
fi

echo "Creating Hyprland session file..."
sudo bash -c "cat > /usr/share/wayland-sessions/hyprland.desktop <<EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=$VM_STARTUP_SCRIPT
Type=Application
EOF"

# Create regular startup script (only if not VM - VM script created above)
if ! systemd-detect-virt | grep -q -E "(kvm|qemu|virtualbox|vmware)"; then
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
fi

echo "Enabling display manager..."
sudo systemctl enable sddm

echo "Running stow setup..."
bash setup_stow.sh

echo "Installation complete! Reboot to start your Hyprland desktop environment."
