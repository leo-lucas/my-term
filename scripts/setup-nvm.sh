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

nvm_latest_version="$(curl -fsSL https://api.github.com/repos/nvm-sh/nvm/releases/latest | \
  sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p')"

if [[ -z "${nvm_latest_version}" ]]; then
  nvm_latest_version="v0.39.7"
  echo "Não foi possível identificar a versão mais recente do NVM. Usando ${nvm_latest_version}."
fi

nvm_install_script="https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_latest_version}/install.sh"

if [[ -d "${HOME}/.nvm" ]]; then
  current_version="$(grep -m1 '^NVM_VERSION=' "${HOME}/.nvm/nvm.sh" | cut -d'"' -f2 || true)"
  if [[ -z "${current_version}" || "${current_version}" != "${nvm_latest_version}" ]]; then
    echo "Atualizando NVM de ${current_version:-desconhecida} para ${nvm_latest_version}."
    curl -fsSL "${nvm_install_script}" | bash
  else
    echo "NVM já está na versão mais recente (${current_version})."
  fi
  exit 0
fi

curl -fsSL "${nvm_install_script}" | bash

echo "NVM instalado em ${HOME}/.nvm."
