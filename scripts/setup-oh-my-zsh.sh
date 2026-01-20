#!/usr/bin/env bash

set -euo pipefail

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

if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh não encontrado. Execute scripts/setup-zsh.sh primeiro."
  exit 1
fi

# If config-only mode, skip installation
if [[ "$config_only" == true ]]; then
  echo "Modo config-only: Apenas configurando Oh My Zsh..."
else
  zsh_dir="${ZSH:-${HOME}/.oh-my-zsh}"

  if [[ ! -d "${zsh_dir}" ]]; then
    if ! command -v curl >/dev/null 2>&1; then
      echo "curl não encontrado. Instale o curl para continuar."
      exit 1
    fi
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Oh My Zsh instalado em ${zsh_dir}."
  else
    echo "Oh My Zsh já está instalado."
  fi

  zshrc_path="${HOME}/.zshrc"
  if [[ ! -f "${zshrc_path}" && -f "${zsh_dir}/templates/zshrc.zsh-template" ]]; then
    cp "${zsh_dir}/templates/zshrc.zsh-template" "${zshrc_path}"
    echo "Arquivo .zshrc criado a partir do template."
  fi
fi
