#!/bin/bash
set -e

echo "Installing Docker..."

for pkg in docker docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo pacman -Rns "$pkg" 2>/dev/null || true
done

sudo pacman -S --needed docker docker-compose-plugin

sudo systemctl enable docker
sudo systemctl start docker

sudo groupadd docker 2>/dev/null || true
sudo usermod -aG docker "$USER"
newgrp docker
