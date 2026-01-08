#!/bin/bash
set -e

echo "Setting up Neovim (AstroNvim)..."

if [ -d "$HOME/.config/nvim" ]; then
    rm -rf ~/.config/nvim
fi

git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git

echo "Neovim configured. Run 'nvim' to finalize plugin installation."
