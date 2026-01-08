#!/bin/bash
set -e

echo "Installing development tools..."

# Pacman packages
sudo pacman -S --needed \
    neovim \
    git-delta

# Yay packages
yay -S --needed lazygit

# Git delta config
git config --global core.pager "delta --git"
git config --global interactive.diffFilter "delta --optical-diff"
