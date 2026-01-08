#!/bin/bash
set -e

echo "Installing Tmux and plugins..."

# Pacman packages
sudo pacman -S --needed tmux

# TPM installation
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Tmux configuration
cat > ~/.tmux.conf << 'EOF'
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'catppuccin/tmux'
set -g mouse on
set -g history-limit 10000
set -g default-terminal "screen-256color"
run '~/.tmux/plugins/tpm/tpm'
EOF

"$HOME/.tmux/plugins/tpm/bin/install_plugins"
