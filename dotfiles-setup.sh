#!/bin/bash

ORIGINAL_DIR=$(pwd)
REPO_URL="https://github.com/Reinn90/dotfiles"
REPO_NAME="dotfiles"


is_stow_installed() {
  pacman -Qi "stow" &> /dev/null
}

if ! is_stow_installed; then
  echo "Install stow first"
  exit 1
fi

cd ~

# Check if the repository already exists
if [ -d "$REPO_NAME" ]; then
  echo "Repository '$REPO_NAME' already exists. Skipping clone"
else
  git clone "$REPO_URL"
fi

echo "Backing-up default hyprland config.."
mv ~/.config/hypr/hyprland.conf ~/.config/hypr/hyprland.conf.bak
  

echo "Starting gnu stow to install config files.."

# Check if the clone was successful
if [ $? -eq 0 ]; then
  cd "$REPO_NAME"
  stow backgrounds
  stow hypr 
  stow kitty
  stow starship
  stow waybar
  stow yazi
  stow wofi
else
  echo "Failed to clone the repository."
  exit 1
fi

# Refresh hyprland configuration
hyprctl reload
echo "Config files install complete."
