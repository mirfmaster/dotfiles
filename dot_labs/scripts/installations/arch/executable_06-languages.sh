#!/bin/bash
set -e

echo "Installing languages and runtime managers..."

# Pacman packages
sudo pacman -S --needed \
    go \
    nodejs \
    npm \
    php${PHP_VERSION} \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-sqlite \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-zip

# Yay packages
yay -S --needed \
    composer \
    pnpm
