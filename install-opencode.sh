#!/bin/bash

# OpenCode Installation Script
# This script installs OpenCode configuration on macOS and Linux

set -euo pipefail

CONFIG_DIR="$HOME/.config/opencode"

echo "Starting OpenCode installation..."

# Check if OpenCode is installed
if ! command -v opencode &> /dev/null; then
  echo "OpenCode is not installed. Installing via npm..."
  npm install -g opencode-ai
  if ! command -v opencode &> /dev/null; then
    echo "Failed to install OpenCode via npm"
    exit 1
  fi
fi

# Check if config directory exists
if [[ -d "$CONFIG_DIR" ]]; then
  echo "OpenCode configuration already exists. Updating..."
  cd "$CONFIG_DIR"
  git pull origin main
else
  # Clone the configuration
  echo "Cloning OpenCode configuration from GitHub..."
  git clone https://github.com/leo-lucas/my-opencode.git "$CONFIG_DIR"
fi

echo "OpenCode installation completed successfully!"
echo "You can now start OpenCode with: opencode"
