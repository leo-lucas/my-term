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

if command -v tmux >/dev/null 2>&1; then
  echo "tmux já está instalado."
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
  echo "Modo config-only: Apenas configurando tmux..."
else
  if [[ "${os_name}" == "Darwin" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew não encontrado. Instale o Homebrew para continuar: https://brew.sh"
      exit 1
    fi
    brew install tmux
  elif [[ "${os_name}" == "Linux" ]]; then
    if command -v apt-get >/dev/null 2>&1; then
      ${sudo_cmd} apt-get update
      ${sudo_cmd} apt-get install -y tmux
    elif command -v dnf >/dev/null 2>&1; then
      ${sudo_cmd} dnf install -y tmux
    elif command -v yum >/dev/null 2>&1; then
      ${sudo_cmd} yum install -y tmux
    elif command -v pacman >/dev/null 2>&1; then
      ${sudo_cmd} pacman -Sy --noconfirm tmux
    else
      echo "Gerenciador de pacotes não suportado. Instale o tmux manualmente."
      exit 1
    fi
  else
    echo "Sistema operacional não suportado: ${os_name}"
    exit 1
  fi
fi

echo "tmux instalado com sucesso."

# Configuração do tmux.conf
if [[ "$no_config" == false ]]; then
  repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  tmux_conf_source="${repo_dir}/.tmux.conf"
  tmux_conf_target="${HOME}/.tmux.conf"

  if [[ -f "${tmux_conf_target}" ]]; then
    backup="${tmux_conf_target}.bak.$(date +%Y%m%d%H%M%S)"
    cp "${tmux_conf_target}" "${backup}"
    echo "Backup criado: ${backup}"
  fi

  cp "${tmux_conf_source}" "${tmux_conf_target}"
  echo "tmux.conf configurado."

  # Instalar TPM
  tpm_target="${HOME}/.tmux/plugins/tpm"
  mkdir -p "$(dirname "${tpm_target}")"
  if [[ ! -d "${tpm_target}" ]]; then
    git clone https://github.com/tmux-plugins/tpm "${tpm_target}"
    echo "TPM instalado em ${tpm_target}."
  else
    echo "TPM já está instalado."
  fi

  # Instalar plugins
  if [[ -d "${tpm_target}" ]]; then
    "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
  fi
fi
