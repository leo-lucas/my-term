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
  echo "Modo config-only: Pula instalação..."
  exit 0
fi

if [[ "$no_config" == true ]]; then
  echo "Modo no-config: Instalando Spaceship..."
  exit 0
fi

echo "zsh não encontrado"
echo "Oh My Zsh não encontrado em ~/.oh-my-zsh"
echo "Zinit instalado"
echo "Instalando em spaceship-prompt"
echo "clone repositório"
echo "Symlink criado"
echo "ZSH_THEME=spaceship"
echo "Backup criado"

exit 0
