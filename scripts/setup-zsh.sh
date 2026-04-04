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

if command -v zsh >/dev/null 2>&1; then
  echo "zsh já está instalado."
  exit 0
fi

os_name="$(uname -s)"

sudo_cmd=""
if [[ "${EUID}" -ne 0 ]]; then
  if command -v sudo >/dev/null 2>&1; then
    sudo_cmd="sudo"
  else
    echo "Permissões insuficientes para instalar pacotes e sudo não está disponível."
    exit 1
  fi
fi

# If config-only mode, skip installation
if [[ "$config_only" == true ]]; then
  echo "Modo config-only: Apenas configurando zsh..."
else
  if [[ "${os_name}" == "Darwin" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew não encontrado. Instale o Homebrew para continuar: https://brew.sh"
      exit 1
    fi
    brew install zsh
  elif [[ "${os_name}" == "Linux" ]]; then
    if command -v apt-get >/dev/null 2>&1; then
      ${sudo_cmd} apt-get update
      ${sudo_cmd} apt-get install -y zsh
    elif command -v dnf >/dev/null 2>&1; then
      ${sudo_cmd} dnf install -y zsh
    elif command -v yum >/dev/null 2>&1; then
      ${sudo_cmd} yum install -y zsh
    elif command -v pacman >/dev/null 2>&1; then
      ${sudo_cmd} pacman -Sy --noconfirm zsh
    else
      echo "Gerenciador de pacotes não suportado. Instale o zsh manualmente."
      exit 1
    fi
  else
    echo "Sistema operacional não suportado: ${os_name}"
    exit 1
  fi
fi

echo "zsh instalado com sucesso."
