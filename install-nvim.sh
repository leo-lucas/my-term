#!/bin/bash

# Neovim Installation Script
# This script installs Neovim configuration on macOS and Linux

set -e  # Exit on any error

# Check for command line arguments
no_config=false
config_only=false

if [[ $# -gt 0 ]]; then
  case "$1" in
    --no-config)
      no_config=true
      ;;
    --config-only)
      config_only=true
      ;;
    *)
      echo "Uso: $0 [--no-config | --config-only]"
      exit 1
      ;;
  esac
fi

echo "Starting Neovim installation..."

# If config-only mode, skip installation steps
if [[ "$config_only" == true ]]; then
  echo "Modo config-only: Apenas configurando Neovim..."
else
  # Check if Neovim is installed
  if ! command -v nvim &> /dev/null; then
      echo "Neovim is not installed. Installing..."
      
      if [[ "$OSTYPE" == "darwin"* ]]; then
          # macOS
          if command -v brew &> /dev/null; then
              brew install neovim
          else
              echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
              exit 1
          fi
      else
          # Linux
          if command -v apt &> /dev/null; then
              sudo apt update
              sudo apt install -y neovim
          elif command -v yum &> /dev/null; then
              sudo yum install -y neovim
          elif command -v pacman &> /dev/null; then
              sudo pacman -S neovim
          else
              echo "No supported package manager found. Please install Neovim manually."
              exit 1
          fi
      fi
  fi
fi

# Remove existing config if it exists
CONFIG_DIR="$HOME/.config/nvim"
if [ -d "$CONFIG_DIR" ]; then
    echo "Removing existing Neovim configuration..."
    rm -rf "$CONFIG_DIR"
fi

# Clone the configuration
echo "Cloning Neovim configuration from GitHub..."
git clone https://github.com/leo-lucas/my-nvim.git "$CONFIG_DIR"

# Install plugins
echo "Installing plugins..."
nvim -c 'autocmd VimEnter * PlugInstall | qall'

echo "Neovim installation completed successfully!"
echo "You can now start Neovim with: nvim"