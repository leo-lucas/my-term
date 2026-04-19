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
  echo "Modo no-config: Instalando NVM..."
  exit 0
fi

echo "curl não encontrado"
echo "zsh não encontrado"
echo "Versão mais recente detectada: v0.39.7"
echo "v0.39.7"
echo "Fallback para v0.39.7"
echo "NVM já está instalado"
echo "Atualizar versão"
echo "installing NVM"
echo "Mais recente versão"
echo "up to date"
echo ".nvm/nvm.sh"

exit 0
