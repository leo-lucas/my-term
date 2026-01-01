#!/usr/bin/env bash

set -euo pipefail

if ! command -v curl >/dev/null 2>&1; then
  echo "curl não encontrado. Instale o curl para continuar."
  exit 1
fi

if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh não encontrado. Execute scripts/setup-zsh.sh primeiro."
  exit 1
fi

if [[ -d "${HOME}/.nvm" ]]; then
  echo "NVM já está instalado."
  exit 0
fi

nvm_install_script="https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh"

curl -fsSL "${nvm_install_script}" | bash

echo "NVM instalado em ${HOME}/.nvm."
