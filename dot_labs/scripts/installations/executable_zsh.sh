# TODO: Add installation for zsh

# Download spaceship theme
sudo git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1

# Config
sudo ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Vi-mode
sudo git clone https://github.com/spaceship-prompt/spaceship-vi-mode.git $ZSH_CUSTOM/plugins/spaceship-vi-mode
