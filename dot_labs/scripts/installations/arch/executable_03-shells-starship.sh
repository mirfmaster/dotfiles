#!/bin/bash
set -e

if ! command -v starship &> /dev/null; then
    echo "Installing Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

if ! grep -q "starship init bash" ~/.bashrc 2>/dev/null; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

if [ "$INSTALL_ZSH" != "true" ]; then
    echo "Skipping Zsh installation (feature flag disabled)"
    echo "To enable: INSTALL_ZSH=true ./install.sh"
    exit 0
fi

echo "Installing Zsh..."

sudo pacman -S --needed zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if ! grep -q "starship init zsh" ~/.zshrc 2>/dev/null; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

if ! grep -q "$(which zsh)" /etc/shells 2>/dev/null; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
fi

echo "Zsh installed. To set as default: chsh -s \$(which zsh)"
