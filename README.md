# Somvilla-Dotfiles

A collection of my personal Linux dotfiles for Hyprland and related tools. Easily restore your setup on a fresh Arch/EndeavourOS install.

## Quick Start

1. **Clone the repo**:
   ```bash
   git clone <your-repo-url> ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installer**:
   ```bash
   ./install.sh
   ```
   This backs up existing configs, installs packages (including OpenCode via curl), and sets up symlinks.

3. **Reboot**:
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

## Manual Setup

If you prefer not to use the install script:

1. Install packages manually:
   ```bash
   sudo pacman -S hyprland waybar kitty fish starship rofi nemo nvim cava swaync wlogout wofi gtk3 gtk4 pavucontrol btop opencode ollama
   ```

2. Run the symlink script:
   ```bash
   ./setup_symlinks.sh
   ```

## Dependencies

- **OS**: Arch Linux or EndeavourOS
- **Package Manager**: pacman
- **Required Packages**: See `install.sh` for the full list (includes yay AUR helper and dev tools like git, nodejs, npm, python)
- **Optional**: Additional AUR packages can be installed with yay

## Customization

- Edit configs in `~/.config` (they're symlinked here)
- Add new configs: Backup to dotfiles, update `setup_symlinks.sh`
- Test changes: `hyprctl reload` for Hyprland

## Notes

- Symlinks are created from `~/dotfiles` to `~/.config`
- Sensitive data (API keys, etc.) should be in a separate `secrets/` dir (ignored by git)
- Commit changes regularly: `git add . && git commit -m "Update"`

## Troubleshooting

- If symlinks fail, check if target files exist
- For Hyprland issues, check `hyprland.conf` syntax and run `journalctl -xe`
- Missing packages? Add to `install.sh`
- OpenCode install fails? Check internet and run `curl -fsSL https://opencode.ai/install | bash` manually
- Restore backups: Configs are backed up to `~/config_backup`

## VM Testing

To test on a fresh Arch VM:
1. Install base Arch: `pacman -S git`
2. Clone: `git clone <your-repo-url> ~/dotfiles`
3. Run: `cd ~/dotfiles && ./install.sh`
4. Reboot and verify Hyprland starts

Enjoy your customized Hyprland setup!
