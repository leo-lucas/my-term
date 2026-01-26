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
  echo "Modo config-only: Apenas configurando tema Spaceship..."
else
  if [[ -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
    echo "Zinit encontrado. O tema Spaceship será carregado via Zinit."
    exit 0
  fi

  zsh_dir="${ZSH:-${HOME}/.oh-my-zsh}"
  if [[ ! -d "${zsh_dir}" ]]; then
    echo "Oh My Zsh não encontrado em ${zsh_dir}. Execute scripts/setup-oh-my-zsh.sh primeiro."
    exit 1
  fi

  zsh_custom="${ZSH_CUSTOM:-${zsh_dir}/custom}"
  spaceship_dir="${zsh_custom}/themes/spaceship-prompt"

  mkdir -p "${zsh_custom}/themes"

  if [[ ! -d "${spaceship_dir}" ]]; then
    git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "${spaceship_dir}"
    echo "Tema Spaceship instalado em ${spaceship_dir}."
  else
    echo "Tema Spaceship já está instalado."
  fi

  ln -sf "${spaceship_dir}/spaceship.zsh-theme" "${zsh_custom}/themes/spaceship.zsh-theme"

  os_name="$(uname -s)"
  zshrc_path="${HOME}/.zshrc"
  if [[ -f "${zshrc_path}" ]]; then
    backup="${zshrc_path}.bak.$(date +%Y%m%d%H%M%S)"
    cp "${zshrc_path}" "${backup}"
    echo "Backup do .zshrc criado em: ${backup}"
  fi

  touch "${zshrc_path}"
  if grep -q "^ZSH_THEME=" "${zshrc_path}"; then
    if [[ "${os_name}" == "Darwin" ]]; then
      sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="spaceship"/' "${zshrc_path}"
    else
      sed -i 's/^ZSH_THEME=.*/ZSH_THEME="spaceship"/' "${zshrc_path}"
    fi
  else
    echo 'ZSH_THEME="spaceship"' >> "${zshrc_path}"
  fi

  echo "Tema Spaceship configurado no .zshrc."
fi
