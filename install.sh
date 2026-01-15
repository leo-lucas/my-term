#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux_conf_source="${repo_dir}/.tmux.conf"
zsh_setup_script="${repo_dir}/scripts/setup-zsh.sh"
oh_my_zsh_setup_script="${repo_dir}/scripts/setup-oh-my-zsh.sh"
zshrc_setup_script="${repo_dir}/scripts/setup-zshrc.sh"
spaceship_setup_script="${repo_dir}/scripts/setup-spaceship.sh"
nvm_setup_script="${repo_dir}/scripts/setup-nvm.sh"
nvim_setup_script="${repo_dir}/install-nvim.sh"
opencode_setup_script="${repo_dir}/install-opencode.sh"

tmux_conf_target="${HOME}/.tmux.conf"
tpm_target="${HOME}/.tmux/plugins/tpm"

steps=(
  "Configurar tmux"
  "Instalar TPM e plugins"
  "Configurar Zsh"
  "Instalar Oh My Zsh"
  "Configurar zshrc"
  "Instalar tema Spaceship"
  "Instalar NVM"
  "Instalar Neovim"
  "Instalar OpenCode"
)

echo "Selecione os passos da instalação (pressione Enter para todos):"
for i in "${!steps[@]}"; do
  printf "  %d) %s\n" "$((i + 1))" "${steps[$i]}"
done

selection=""
if [[ -t 0 ]]; then
  read -r -p "Números separados por espaço ou vírgula: " selection || true
fi
selection="${selection//,/ }"

selected_steps=()
if [[ -z "${selection}" ]]; then
  for i in "${!steps[@]}"; do
    selected_steps+=("$((i + 1))")
  done
else
  for item in ${selection}; do
    if [[ "${item}" =~ ^[0-9]+$ ]] && (( item >= 1 && item <= ${#steps[@]} )); then
      selected_steps+=("${item}")
    else
      echo "Entrada inválida: ${item}"
      exit 1
    fi
  done
fi

run_step() {
  local step_number="$1"

  case "${step_number}" in
    1)
      mkdir -p "$(dirname "${tpm_target}")"
      if [[ -f "${tmux_conf_target}" ]]; then
        backup="${tmux_conf_target}.bak.$(date +%Y%m%d%H%M%S)"
        cp "${tmux_conf_target}" "${backup}"
        echo "Backup criado: ${backup}"
      fi
      cp "${tmux_conf_source}" "${tmux_conf_target}"
      ;;
    2)
      mkdir -p "$(dirname "${tpm_target}")"
      if [[ ! -d "${tpm_target}" ]]; then
        git clone https://github.com/tmux-plugins/tpm "${tpm_target}"
      fi
      "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
      ;;
    3)
      if [[ -x "${zsh_setup_script}" ]]; then
        "${zsh_setup_script}"
      else
        echo "Script ${zsh_setup_script} não encontrado ou sem permissão de execução."
        exit 1
      fi
      ;;
    4)
      if [[ -x "${oh_my_zsh_setup_script}" ]]; then
        "${oh_my_zsh_setup_script}"
      else
        echo "Script ${oh_my_zsh_setup_script} não encontrado ou sem permissão de execução."
        exit 1
      fi
      ;;
    5)
      if [[ -x "${zshrc_setup_script}" ]]; then
        "${zshrc_setup_script}"
      else
        echo "Script ${zshrc_setup_script} não encontrado ou sem permissão de execução."
        exit 1
      fi
      ;;
    6)
      if [[ -x "${spaceship_setup_script}" ]]; then
        "${spaceship_setup_script}"
      else
        echo "Script ${spaceship_setup_script} não encontrado ou sem permissão de execução."
        exit 1
      fi
      ;;
    7)
      if [[ -x "${nvm_setup_script}" ]]; then
        "${nvm_setup_script}"
      else
        echo "Script ${nvm_setup_script} não encontrado ou sem permissão de execução."
        exit 1
      fi
      ;;
    8)
      if [[ -x "${nvim_setup_script}" ]]; then
        "${nvim_setup_script}"
      else
        echo "Script ${nvim_setup_script} não encontrado ou sem permissão de execução."
        exit 1
      fi
      ;;
    9)
      if [[ -x "${opencode_setup_script}" ]]; then
        "${opencode_setup_script}"
      else
        echo "Script ${opencode_setup_script} não encontrado ou sem permissão de execução."
        exit 1
      fi
      ;;
    *)
      echo "Passo desconhecido: ${step_number}"
      exit 1
      ;;
  esac
}

for step_number in "${selected_steps[@]}"; do
  run_step "${step_number}"
done

echo "Instalação concluída."
echo "Abra um novo terminal ou recarregue o tmux com:"
echo "tmux source-file ~/.tmux.conf"
