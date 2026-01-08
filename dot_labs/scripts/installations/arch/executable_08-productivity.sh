#!/bin/bash
set -e

echo "Installing productivity tools..."

curl -fsSL https://raw.githubusercontent.com/steveyegge/beads/main/scripts/install.sh | bash

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

echo "Atuin installed. To initialize: atuin init"

curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- -y

bash -c "$(curl -sLo- https://superfile.netlify.app/install.sh)"

yay -S --needed btop eza
