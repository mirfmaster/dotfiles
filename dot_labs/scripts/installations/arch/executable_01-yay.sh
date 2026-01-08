#!/bin/bash
set -e

echo "Installing yay-bin AUR helper..."

sudo pacman -S --needed base-devel git

if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ..
    rm -rf yay-bin
fi

yay --version
