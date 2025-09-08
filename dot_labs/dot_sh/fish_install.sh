#!/bin/bash

# Stop script on any error
set -e

echo "--- Starting Arch Linux Setup ---"

# -----------------------------------------------------------------------------
# 1. System Update and Core Dependencies
# -----------------------------------------------------------------------------
echo "--> Updating system and installing base-devel and git..."
sudo pacman -Syu --needed base-devel git

# -----------------------------------------------------------------------------
# 2. AUR Helper (yay)
# -----------------------------------------------------------------------------
# Check if yay is installed, if not, clone and build it.
if ! command -v yay &> /dev/null
then
    echo "--> yay not found. Installing..."
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
else
    echo "--> yay is already installed."
fi

# -----------------------------------------------------------------------------
# 3. Core Applications & Utilities (via pacman and yay)
# -----------------------------------------------------------------------------
echo "--> Installing core applications and utilities..."
yay -S --needed \
    brave-bin \
    btop \
    dbeaver \
    fish \
    fzf \
    git-delta \
    gnupg \
    lazygit \
    ripgrep \
    # superproductivity-bin \
    timeshift \
    tmux \
    warp-terminal \
    xclip \
    zsh

# -----------------------------------------------------------------------------
# 4. PHP Environment (using AUR packages for specific versions)
# -----------------------------------------------------------------------------
echo "--> Installing PHP 8.3 and common extensions..."
yay -S --needed \
    php83 \
    php83-cli \
    php83-curl \
    php83-gd \
    php83-intl \
    php83-mbstring \
    php83-pgsql \
    php83-redis \
    php83-zip

# -----------------------------------------------------------------------------
# 5. Tool & Version Managers (Volta, Mise, Zoxide)
# -----------------------------------------------------------------------------
echo "--> Installing Volta (for Node.js/pnpm)..."
curl https://get.volta.sh | bash

# Export Volta's path for the rest of this script to use
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

echo "--> Installing mise (for managing tool versions)..."
curl https://mise.run | sh

echo "--> Installing zoxide (smarter cd command)..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

echo "--> Installing superfile (file manager)..."
bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"

# -----------------------------------------------------------------------------
# 6. Development Tools Setup
# -----------------------------------------------------------------------------
echo "--> Installing Node.js (LTS) and pnpm via Volta..."
volta install node@lts
volta install pnpm

echo "--> Installing global npm packages..."
pnpm install -g @musistudio/claude-code-router

echo "--> Setting up AstroNvim..."
# Backup existing nvim config if it exists
if [ -d "$HOME/.config/nvim" ]; then
    echo "Backing up existing Neovim config..."
    mv ~/.config/nvim ~/.config/nvim.bak
    mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null || true
    mv ~/.local/state/nvim ~/.local/state/nvim.bak 2>/dev/null || true
    mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null || true
fi
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo "--> Setting up Tmux Plugin Manager (TPM)..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed."
fi

# -----------------------------------------------------------------------------
# 7. Shell Configuration
# -----------------------------------------------------------------------------
echo "--> Configuring Fish shell..."
# Create fish config directory if it doesn't exist
mkdir -p ~/.config/fish

# Add tool initializations to fish config
# Using a temp file to avoid multiple entries if script is re-run
CONFIG_FILE=~/.config/fish/config.fish
touch $CONFIG_FILE

if ! grep -q "zoxide init fish" "$CONFIG_FILE"; then
  echo "zoxide init fish | source" >> "$CONFIG_FILE"
fi

if ! grep -q "mise activate fish" "$CONFIG_FILE"; then
  echo "mise activate fish | source" >> "$CONFIG_FILE"
fi

if ! grep -q "set -U fish_user_paths" "$CONFIG_FILE"; then
  echo 'set -U fish_user_paths ~/.volta/bin $fish_user_paths' >> "$CONFIG_FILE"
fi

echo "--> Setting Fish as the default shell..."
# Add fish to /etc/shells if it's not already there
if ! grep -q "$(which fish)" /etc/shells; then
    which fish | sudo tee -a /etc/shells
fi
# Change the shell for the current user
sudo chsh -s $(which fish) $(whoami)

# -----------------------------------------------------------------------------
# 8. Final Steps
# -----------------------------------------------------------------------------
echo ""
echo "--- Setup Complete! ---"
echo "Please restart your terminal or log out and log back in for all changes to take effect."
echo "Don't forget to run 'nvim' to finalize the AstroNvim installation."
echo "In tmux, press 'prefix + I' (default is Ctrl+b I) to install the plugins."
