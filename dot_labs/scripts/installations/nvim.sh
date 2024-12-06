# Get latest version from GitHub API
LATEST_VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | grep -Po '"tag_name": "v\K[^"]*')

# Download latest appimage
curl -LO "https://github.com/neovim/neovim/releases/download/v${LATEST_VERSION}/nvim.appimage"
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# Verify installation
nvim --version
