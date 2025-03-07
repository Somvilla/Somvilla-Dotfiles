# CLAUDE.md - Dotfiles Repository Guidelines

## Repository Information
- This repository contains dotfiles for Hyprland and other Linux configurations
- Main components: Hyprland, Waybar, kitty terminal, fish shell, GTK themes

## Commands
- No formal build/lint/test commands (dotfiles repository)
- To apply changes: symlink files to appropriate ~/.config locations
- To test Hyprland config changes: `hyprctl reload`
- To check syntax: `bash -n scripts/*.sh`

## Style Guidelines
- Shell scripts: use bash shebang, proper indentation (4 spaces)
- Config files: follow each tool's standard formatting 
- Comments: use ASCII art headers (see hyprland.conf)
- File organization: group related configs in directories
- Environment variables: use UPPERCASE with $mainMod pattern
- Naming: use descriptive names for scripts and config sections

## Code Standards
- Keep scripts simple and modular
- Document custom keybindings and shortcuts
- Prefer absolute paths for file references
- Organize related settings into separate files (e.g., keybindings.conf)
- Use proper error handling in shell scripts