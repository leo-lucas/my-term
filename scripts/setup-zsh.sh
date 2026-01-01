#!/usr/bin/env bash

set -euo pipefail

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

echo "zsh instalado com sucesso."
