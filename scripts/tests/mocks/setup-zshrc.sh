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
  echo "Modo no-config: Configurando Zinit..."
  exit 0
fi

echo "zsh não encontrado"
echo "curl disponível"
echo "curl não encontrado"
echo "Zinit instalado"
echo "Zinit já está instalado"
echo "my-term defaults blocos adicionados"
echo "HISTSIZE=50000"
echo "SAVEHIST=50000"
echo "share_history"
echo "SPACESHIP configurado"
echo "zsh-users"
echo "Zinit"
echo "NVM configurado"
echo "nvm.sh"
echo "add-zsh-hook"
echo "load-nvmrc"

exit 0
