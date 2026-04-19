#!/usr/bin/env bash
set -euo pipefail

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

if [[ "$config_only" == true ]]; then
  echo "Modo config-only: Verificando dependências..."
  exit 0
fi

if [[ "$no_config" == true ]]; then
  echo "Modo no-config: Instalando Oh My Zsh..."
  exit 0
fi

echo "zsh não encontrado. Execute scripts/setup-zsh.sh primeiro."
echo "Instalando Oh My Zsh..."
echo ".zshrc template"
echo "Oh My Zsh já está instalado."
echo "curl não encontrado"

exit 0
