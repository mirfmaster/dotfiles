#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "Arch Linux Installation Script"
echo "=========================================="
echo ""
echo "Feature flags:"
echo "  INSTALL_ZSH=true   - Install Zsh + Oh My Zsh"
echo ""
echo "Example: INSTALL_ZSH=true ./install.sh"
echo "=========================================="
echo ""

# Run config backup FIRST
source "$SCRIPT_DIR/11-config-backup.sh"

# Load variables
source "$SCRIPT_DIR/00-vars.sh"

# Run installations in order (skip 11-config-backup.sh - already ran)
for script in 01-yay.sh 02-core-utils.sh 03-shells-starship.sh 04-dev-tools.sh 05-kitty.sh 06-languages.sh 07-gui-apps.sh 08-productivity.sh 09-tmux.sh 10-docker.sh 12-neovim-setup.sh; do
    echo ""
    echo "=========================================="
    echo "Running: $script"
    echo "=========================================="
    source "$SCRIPT_DIR/$script"
done

echo ""
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo ""
echo "Post-install steps:"
echo "1. Restart terminal or log out/in"
echo "2. Run 'nvim' to finalize Neovim setup"
echo "3. In tmux: Ctrl+b I to install plugins"
echo "4. Atuin: run 'atuin init' to configure"
echo "5. Zsh (if installed): chsh -s \$(which zsh)"
echo "6. Chezmoi: Run 'chezmoi init mirfmaster' to sync dotfiles"
echo "=========================================="
