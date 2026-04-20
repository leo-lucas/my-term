#!/usr/bin/env bash

# OpenCode Installation Script
# This script installs OpenCode configuration on macOS and Linux

set -euo pipefail

# Set default config directory
CONFIG_DIR="$HOME/.config/opencode"

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

echo "Starting OpenCode installation..."

# If config-only mode, skip installation steps
if [[ "$config_only" == true ]]; then
  echo "Modo config-only: Apenas configurando OpenCode..."
else
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
fi

# Check if config directory exists
if [[ -d "$CONFIG_DIR" ]]; then
  echo "OpenCode configuration already exists. Updating..."
  cd "$CONFIG_DIR"
  current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
  if [[ "$current_branch" != "main" ]]; then
    echo "Switching to main branch..."
<<<<<<< HEAD
    git checkout main
  fi
=======
    echo "Nota: Este comando pode solicitar sua senha SSH se autenticacao for necessaria."
    git checkout main
  fi
  echo "Nota: Este comando pode solicitar sua senha SSH se autenticacao for necessaria."
>>>>>>> feat/improve-qa
  git pull origin main
else
  # Clone the configuration
  echo "Cloning OpenCode configuration from GitHub..."
  echo "Nota: Este comando pode solicitar sua senha SSH ou do GitHub."
  echo "     Se estiver usando chave SSH, ela será usada automaticamente."
  echo "     Se estiver usando senha do GitHub, insira sua senha (não sua chave SSH)."
  git clone https://github.com/leo-lucas/my-opencode.git "$CONFIG_DIR"
fi

echo "OpenCode installation completed successfully!"
echo "You can now start OpenCode with: opencode"
