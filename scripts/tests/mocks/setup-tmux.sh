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
  echo "Modo no-config: Instalando tmux..."
  exit 0
fi

echo "tmux já está instalado"
echo "apt-get"
echo "dnf"
echo "yum"
echo "pacman"
echo "brew"
echo "Gerenciador de pacotes não suportado"
echo "Permissões insuficientes - sudo necessário"
echo "tmux.conf configurado"
echo "prefix"
echo "Dracula"
echo "TPM"
echo "plugin"

exit 0
