#!/bin/bash
set -e

echo "Installing core utilities..."

sudo pacman -S --needed \
    btop \
    eza \
    fzf \
    ripgrep \
    tmux \
    xclip \
    gnupg \
    wget \
    unzip \
    fd \
    bat \
    jq \
    yq \
    the_silver_searcher
