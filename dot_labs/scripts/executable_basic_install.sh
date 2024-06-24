#!/bin/bash

set -e

# NOTE: Required to using config from the chezmoi!

sudo apt update -y && sudo apt upgrade -y && sudo apt install -y \
  git\
  ranger\
  ripgrep\
  xmodmap\
  tree\
  wget\

## ZSH INSTALLATION
sudo apt install -y zsh
chsh -s $(which zsh)

source ~/.zshrc

. installations/kitty.sh
. installations/lazygit.sh
. installations/go.sh
. installations/docker.sh

# NOTE: One-line command installer
# LAZYDOCKER
go install github.com/jesseduffield/lazydocker@latest


# #TODO:
# - github installer
#   - dbeaver
#   - vscode
#   - super productivity
#   - git delta
#   - code
# https://github.com/reactiveui/ReactiveUI/releases/latest
