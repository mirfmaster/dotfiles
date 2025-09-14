#!/bin/bash

# Arch Linux Development Environment Setup Script
# Based on command history analysis
# Run as non-root user with sudo access

set -e  # Exit on any error

echo "🚀 Starting Arch Linux Development Environment Setup..."
echo "Current date: $(date)"
echo "User: $USER"
echo "Working directory: $(pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    log_error "This script should not be run as root. Please run as a regular user."
    exit 1
fi

# Update system first
log_info "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install base development tools
log_info "Installing base development tools..."
sudo pacman -S --needed base-devel git curl wget

# Install AUR helper (yay)
if ! command -v yay &> /dev/null; then
    log_info "Installing yay AUR helper..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
else
    log_info "yay is already installed"
fi

# Install essential system tools
log_info "Installing essential system tools..."
sudo pacman -S --needed \
    fish \
    zsh \
    fzf \
    ripgrep \
    lazygit \
    btop \
    tmux \
    # starship \
    gnupg \
    xclip \
    timeshift \
    go

# Install development tools via AUR
log_info "Installing development tools via AUR..."
yay -S --needed \
    brave-bin \
    dbeaver \
    # superproductivity-bin \
    redis \
    chezmoi \
    # qtpass \
    pass-otp \
    hyprmon-bin

# Install PHP 8.3 and extensions
log_info "Installing PHP 8.3 and extensions..."
yay -S --needed \
    php83 \
    php83-cli \
    php83-fpm \
    php83-gd \
    php83-mbstring \
    php83-pgsql \
    php83-redis \
    php83-sodium \
    php83-intl \
    php83-curl \
    php83-zip \
    php83-dom \
    php83-xml \
    php83-tokenizer \
    php83-fileinfo \
    php83-simplexml \
    php83-xmlwriter \
    php83-bcmath \
    php83-exif \
    php83-sqlite \
    php83-mysql \
    php83-phar \
    php83-openssl

# Create symlink for default php
sudo unlink /usr/bin/php 2>/dev/null || true
sudo ln -sf /usr/bin/php83 /usr/bin/php

# Install Composer
if ! command -v composer &> /dev/null; then
    log_info "Installing Composer..."
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    sudo chmod +x /usr/local/bin/composer
else
    log_info "Composer is already installed"
fi

# Install Node.js and package managers
log_info "Installing Node.js and package managers..."
curl https://get.volta.sh | bash
# Add volta to PATH (will need to restart shell or source .bashrc)
echo 'export PATH="$HOME/.volta/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

volta install node@lts
volta install pnpm
volta install npm

# Install mise (universal version manager)
if ! command -v mise &> /dev/null; then
    log_info "Installing mise..."
    curl https://mise.run | sh
    # Add to shell config
    echo 'eval "$(mise activate fish)"' >> ~/.config/fish/config.fish
else
    log_info "mise is already installed"
fi

# # Configure mise for PHP
# mise use --global php@8.3
# mise plugins add php

# Install zoxide for smart directory navigation
if ! command -v zoxide &> /dev/null; then
    log_info "Installing zoxide..."
    cargo install zoxide --locked
    # Add to fish config
    echo 'zoxide init --cmd cd fish | source' >> ~/.config/fish/config.fish
fi

# Install git-delta
sudo pacman -S --needed git-delta

# Install Docker (if needed)
if ! command -v docker &> /dev/null; then
    log_info "Installing Docker..."
    sudo pacman -S --needed docker docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    log_warn "Please log out and back in for Docker group changes to take effect"
fi

# # Configure Fish shell
# log_info "Configuring Fish shell..."
# if [[ ! -d ~/.config/fish ]]; then
#     mkdir -p ~/.config/fish
# fi
#
# # Create basic fish config
# cat > ~/.config/fish/config.fish << 'EOF'
# # Fish configuration
#
# # mise activation
# mise activate fish | source
#
# # zoxide integration
# zoxide init fish | source
#
# # Volta activation
# if test -d $HOME/.volta/bin
#     fish_add_path $HOME/.volta/bin
# end
#
# # Starship prompt
# starship init fish | source
#
# # Aliases
# alias ll="ls -la"
# alias la="ls -a"
# alias v="nvim"
# alias vi="nvim"
# alias vim="nvim"
# alias art="php artisan"
# alias tmn="tmux new-session -s"
# alias cmsync="chezmoi update"
# alias cm="chezmoi"
# alias lg="lazygit"
# alias dcupd="docker compose up -d"
#
# # Fish vi key bindings
# fish_vi_key_bindings
#
# # GPG agent
# set -gx GPG_TTY (tty)
#
# # SSH agent
# if test -z "$SSH_AUTH_SOCK"
#     set -gx SSH_AUTH_SOCK (ssh-agent -c | grep -o '/tmp/ssh[^;]*')
# end
# EOF
#
# # Configure Starship
# mkdir -p ~/.config
# starship preset tokyo-night -o ~/.config/starship.toml
#
# # Install tmux plugin manager
# if [[ ! -d ~/.tmux/plugins/tpm ]]; then
#     log_info "Installing tmux plugin manager..."
#     git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# fi
#
# # Create tmux config
# cat > ~/.tmux.conf << 'EOF'
# # Tmux configuration
#
# # Enable mouse
# set -g mouse on
#
# # Set prefix to Ctrl+Space
# unbind C-b
# set -g prefix C-Space
# bind C-Space send-prefix
#
# # 256 colors
# set -g default-terminal "screen-256color"
# set -ga terminal-overrides ",*256col*:Tc"
#
# # Plugins
# set -g @plugin 'tmux-plugins/tpm'
# set -g @plugin 'tmux-plugins/tmux-sensible'
# set -g @plugin 'tmux-plugins/tmux-yank'
# set -g @plugin 'tmux-plugins/tmux-resurrect'
# set -g @plugin 'tmux-plugins/tmux-continuum'
#
# # Auto start/restore sessions
# set -g @continuum-restore 'on'
#
# # Initialize TMUX plugin manager
# run '~/.tmux/plugins/tpm/tpm'
# EOF

# Setup chezmoi (dotfile manager)
if command -v chezmoi &> /dev/null; then
    log_info "Configuring chezmoi..."
    # Initialize chezmoi with your GitHub repo
    # Uncomment and modify the next line with your actual repo
    # sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply mirfmaster
    
    # Add common configs to chezmoi
    chezmoi init --apply || true
fi

# Setup SSH configuration
log_info "Setting up SSH configuration..."
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Generate SSH key if it doesn't exist
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
    log_info "Generating SSH key..."
    ssh-keygen -t ed25519 -C "muhamadiqbal.idn@gmail.com" -f ~/.ssh/id_ed25519 -N ""
    log_info "SSH key generated. Add the public key to your GitHub/GitLab account:"
    log_info "cat ~/.ssh/id_ed25519.pub"
fi

chmod 600 ~/.ssh/config

# Setup SSH agent
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519 2>/dev/null || true
fi

# Configure Git
log_info "Configuring Git..."
git config --global user.email "muhamadiqbal.idn@gmail.com"
git config --global user.name "Muhamad Iqbal"
git config --global core.editor "nvim"
git config --global init.defaultBranch main

# Install global npm packages
log_info "Installing global npm packages..."
pnpm install -g @musistudio/claude-code-router

# Setup Timeshift for backups
log_info "Setting up Timeshift..."
sudo timeshift --check

# Create directories structure
log_info "Creating directory structure..."
mkdir -p ~/Documents/Vaults ~/spaces/mirf ~/.labs ~/.local/share/applications

# Clone development repositories (uncomment and modify as needed)
# log_info "Cloning development repositories..."
# git clone git@github.com:mirfmaster/worker-php.git ~/spaces/mirf/worker-php
# git clone git@github.com:mirfmaster/bjs-server.git ~/spaces/mirf/bjs-server
# git clone git@github.com:mirfmaster/bjs-worker.git ~/spaces/mirf/bjs-worker

# Setup AstroNvim
# if [[ ! -d ~/.config/nvim ]]; then
#     log_info "Setting up AstroNvim..."
#     # Backup existing nvim config
#     [[ -d ~/.local/share/nvim ]] && mv ~/.local/share/nvim ~/.local/share/nvim.bak
#     [[ -d ~/.local/state/nvim ]] && mv ~/.local/state/nvim ~/.local/state/nvim.bak
#     [[ -d ~/.cache/nvim ]] && mv ~/.cache/nvim ~/.cache/nvim.bak
#     
#     git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
#     rm -rf ~/.config/nvim/.git
# fi

# Install Redis Insight AppImage setup (if you have the file)
if [[ -f ~/Downloads/Redis-Insight-linux-x86_64.AppImage ]]; then
    log_info "Setting up Redis Insight..."
    mv ~/Downloads/Redis-Insight-linux-x86_64.AppImage ~/.local/share/applications/
    chmod +x ~/.local/share/applications/Redis-Insight-linux-x86_64.AppImage
    
    # Create desktop entry
    cat > ~/.local/share/applications/redisinsight.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=RedisInsight
Comment=Redis GUI
Exec=/home/%u/.local/share/applications/Redis-Insight-linux-x86_64.AppImage
Icon=redis
Terminal=false
Categories=Development;
EOF
fi

# Final setup steps
log_info "Final setup steps..."

# Make fish default shell (optional)
# sudo chsh -s /usr/bin/fish $USER

# Create a sample Laravel project directory structure
mkdir -p ~/spaces/mirf
# mkdir -p ~/spaces/mirf/{bjs-server,bjs-worker,redundant,curler,ig-session-manager}
# mkdir -p ~/spaces/mirf/ig-session-manager/docs

log_info "🎉 Installation completed successfully!"
echo ""
log_info "Next steps:"
echo "1. Restart your terminal or run: exec fish"
echo "2. Add your SSH public key to GitHub: cat ~/.ssh/id_ed25519.pub"
echo "3. For Docker: log out and back in to apply group changes"
echo "4. Configure chezmoi with your dotfiles repository"
echo "5. Create Laravel projects: cd ~/spaces/mirf/curler && composer create-project laravel/laravel ."
echo ""
log_info "Available tmux sessions you can create:"
echo "  tmux new-session -s bjs-server"
echo "  tmux new-session -s bjs-worker"
echo "  tmux new-session -s curler"
echo "  tmux new-session -s 'The Second Brain'"
