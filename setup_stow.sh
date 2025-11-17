#!/bin/bash

# Setup script for dotfiles using GNU Stow
# This will create symlinks from your dotfiles repo to your system using stow

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if stow is installed
check_stow() {
    if ! command -v stow &> /dev/null; then
        log_error "GNU Stow is not installed. Please install it first:"
        echo "  sudo pacman -S stow"
        exit 1
    fi
}

# Backup existing config if it exists
backup_existing() {
    if [ -d ~/.config ]; then
        log_warning "Existing ~/.config directory found"
        BACKUP_DIR="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"
        log_info "Creating backup at $BACKUP_DIR"
        cp -r ~/.config "$BACKUP_DIR"
        log_success "Backup created: $BACKUP_DIR"
    fi
}

# Stow a package with error handling
stow_package() {
    local package=$1
    log_info "Stowing $package..."

    if stow --target ~/.config --dir .config "$package" 2>/dev/null; then
        log_success "$package stowed successfully"
    else
        log_warning "Failed to stow $package (might already be stowed or conflicting)"
    fi
}

# Main setup function
main() {
    log_info "Starting dotfiles setup with GNU Stow"

    # Check prerequisites
    check_stow

    # Backup existing configs
    backup_existing

    # Change to dotfiles directory
    cd "$(dirname "$0")"

    # Stow all config packages
    log_info "Stowing configuration packages..."

    # GUI applications (managed by stow)
    stow_package "btop"
    stow_package "cava"
    stow_package "fish"
    stow_package "gtk-3.0"
    stow_package "gtk-4.0"
    stow_package "hypr"
    stow_package "kitty"
    stow_package "nemo"
    stow_package "nvim"
    stow_package "rofi"
    stow_package "starship"
    stow_package "swaync"
    stow_package "waybar"
    stow_package "wlogout"
    stow_package "wofi"

    # Scripts (stowed to ~/.local/bin)
    log_info "Stowing scripts..."
    mkdir -p ~/.local/bin
    if stow --target ~/.local/bin --dir .config scripts 2>/dev/null; then
        log_success "Scripts stowed successfully"
    else
        log_warning "Failed to stow scripts"
    fi

    # Pavucontrol config (single file)
    log_info "Setting up pavucontrol config..."
    mkdir -p ~/.config
    if [ -f pavucontrol.ini ]; then
        ln -sf "$(pwd)/pavucontrol.ini" ~/.config/pavucontrol.ini
        log_success "Pavucontrol config linked"
    fi

    log_success "Dotfiles setup complete!"
    log_info "You may need to restart your applications or log out/in for changes to take effect"
    log_info "To update configs: edit files in ~/dotfiles, then run 'stow <package>'"
}

# Run main function
main "$@"