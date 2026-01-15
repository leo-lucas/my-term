#!/bin/bash

# OpenCode Installation Script
# This script installs OpenCode configuration on macOS and Linux

set -e  # Exit on any error

echo "Starting OpenCode installation..."

# Check if OpenCode is installed
if ! command -v opencode &> /dev/null; then
    echo "OpenCode is not installed. Installing via npm..."
    
    # Install via npm
    npm install -g opencode-ai
    
    # Verify installation
    if ! command -v opencode &> /dev/null; then
        echo "Failed to install OpenCode via npm"
        exit 1
    fi
fi

# Remove existing config if it exists
CONFIG_DIR="$HOME/.config/opencode"
if [ -d "$CONFIG_DIR" ]; then
    echo "Removing existing OpenCode configuration..."
    rm -rf "$CONFIG_DIR"
fi

# Clone the configuration
echo "Cloning OpenCode configuration from GitHub..."
git clone https://github.com/leo-lucas/my-opencode.git "$CONFIG_DIR"

# Install dependencies
echo "Installing dependencies..."
cd "$CONFIG_DIR" && npm install

echo "OpenCode installation completed successfully!"
echo "You can now start OpenCode with: opencode"