#!/bin/bash
set -e

BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Backing up existing configurations to $BACKUP_DIR..."

if [ -d "$HOME/.config/nvim" ]; then
    mv ~/.config/nvim "$BACKUP_DIR/nvim"
fi
if [ -d "$HOME/.local/share/nvim" ]; then
    mv ~/.local/share/nvim "$BACKUP_DIR/nvim-local-share"
fi
if [ -d "$HOME/.local/state/nvim" ]; then
    mv ~/.local/state/nvim "$BACKUP_DIR/nvim-local-state"
fi
if [ -d "$HOME/.cache/nvim" ]; then
    mv ~/.cache/nvim "$BACKUP_DIR/nvim-cache"
fi
if [ -f "$HOME/.tmux.conf" ]; then
    cp ~/.tmux.conf "$BACKUP_DIR/tmux.conf"
fi

echo "Backup complete: $BACKUP_DIR"
