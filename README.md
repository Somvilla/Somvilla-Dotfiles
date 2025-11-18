# Somvilla-Dotfiles

A collection of my personal Linux dotfiles for Hyprland and related tools. Uses GNU Stow for clean, maintainable configuration management. Easily restore your setup on a fresh Arch/EndeavourOS install.

## Quick Start

1. **Install GNU Stow**:
   ```bash
   sudo pacman -S stow
   ```

2. **Clone the repo**:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

3. **Run the stow setup**:
   ```bash
   ./setup_stow.sh
   ```
   This backs up existing configs and creates symlinks using GNU Stow.

4. **Reboot**:
   ```bash
   sudo reboot
   ```
   Your Hyprland environment should be ready!

## What's Included

- **Window Manager**: Hyprland with custom keybindings, layouts, and rules
- **Status Bar**: Waybar with modules for workspaces, clock, CPU, etc.
- **Terminal**: Kitty with custom themes and keymaps
- **Shell**: Fish with aliases and functions
- **Launcher**: Rofi with Tokyo theme
- **File Manager**: Nemo
- **Editor**: Neovim with Lazy plugin manager
- **Audio Visualizer**: Cava with shaders
- **Notifications**: SwayNC
- **Logout Menu**: Wlogout
- **App Launcher**: Wofi
- **Themes**: GTK 3/4 themes and decorations
- **Scripts**: Automation scripts for wallpapers, global control, etc.
- **Wallpapers**: Custom background images
- **Other**: Pavucontrol settings, btop config, bashrc
- **Gaming**: AMD GPU support with Proton, MangoHud, Lutris, Wine, DXVK

## Stow Workflow

This repository uses GNU Stow for configuration management:

### Basic Usage
- **Edit configs**: Modify files in `~/dotfiles/.config/`
- **Deploy changes**: Run `stow <package>` (e.g., `stow kitty`)
- **Update all**: `stow */` deploys all packages
- **Remove package**: `stow -D <package>` unstows a package

### Adding New Configs
1. Create directory: `mkdir ~/dotfiles/.config/newapp`
2. Add config files to that directory
3. Deploy: `stow newapp`

### Package List
- `btop`, `cava`, `fish`, `gtk-3.0`, `gtk-4.0`, `hypr`, `kitty`, `nemo`, `nvim`, `rofi`, `swaync`, `waybar`, `wlogout`, `wofi`
- `scripts` (deploys to `~/.local/bin`)

## Manual Setup

If you prefer manual setup:

1. Install GNU Stow and required packages:
   ```bash
   sudo pacman -S stow hyprland waybar kitty fish starship rofi nemo nvim cava swaync wlogout wofi gtk3 gtk4 pavucontrol btop opencode ollama
   ```

2. Run the stow setup script:
   ```bash
   ./setup_stow.sh
   ```

## Dependencies

- **OS**: Arch Linux or EndeavourOS
- **Package Manager**: pacman
- **Required Packages**: See `install.sh` for the full list (includes yay AUR helper and dev tools like git, nodejs, npm, python)
- **Optional**: Additional AUR packages can be installed with yay

## Customization

- **Edit configs in `~/dotfiles/.config/`** (this is the source of truth)
- **Deploy changes**: Run `stow <package>` after editing (e.g., `stow kitty`)
- **Add new configs**: Create directory in `~/dotfiles/.config/`, then run `stow <new-package>`
- **Test changes**: `hyprctl reload` for Hyprland

## Notes

- Configurations are managed using GNU Stow - edit in `~/dotfiles/.config/`, deploy with `stow <package>`
- Sensitive data (API keys, etc.) should be in a separate `secrets/` dir (ignored by git)
- Commit changes regularly: `git add . && git commit -m "Update"`
- To update all configs: `stow */` (from dotfiles directory)

## Troubleshooting

- **Stow conflicts**: If stow reports conflicts, existing files may need to be removed first
- **Stow not found**: Install with `sudo pacman -S stow`
- **Config not loading**: Run `stow <package>` after editing configs
- **Hyprland issues**: Check `hyprland.conf` syntax and run `journalctl -xe`
- **Missing packages**: Add to package installation commands
- **OpenCode install fails**: Check internet and run `curl -fsSL https://opencode.ai/install | bash` manually
- **Restore backups**: Configs are backed up to `~/config_backup_*` directories

## VM Testing

To test on a fresh Arch VM:
1. Install base packages: `pacman -S git stow`
2. Clone: `git clone <your-repo-url> ~/dotfiles`
3. Run: `cd ~/dotfiles && ./install.sh`
4. Reboot and verify Hyprland starts with SDDM login screen

**VM Graphics Setup:**
- **Virt-Manager/virt-manager**: Enable SPICE display in VM settings
- **VirtualBox**: Enable VRDP server or use GUI mode
- **VMware**: Use VM console with graphics enabled
- **Generic**: Ensure VM has graphics acceleration and sufficient VRAM

Enjoy your customized Hyprland setup!
