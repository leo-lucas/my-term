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

# Define all installation steps
steps=(
  "Instalar tmux"
  "Instalar TPM e plugins"
  "Instalar Zsh"
  "Instalar Oh My Zsh"
  "Configurar zshrc"
  "Instalar tema Spaceship"
  "Instalar NVM"
  "Instalar Neovim"
  "Instalar OpenCode"
)

selected_steps=(1 2 3 4 5 6 7 8 9)

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
      "${zsh_setup_script}"
      ;;
    4)
      "${oh_my_zsh_setup_script}"
      ;;
    5)
      "${zshrc_setup_script}"
      ;;
    6)
      "${spaceship_setup_script}"
      ;;
    7)
      "${nvm_setup_script}"
      ;;
    8)
      "${nvim_setup_script}"
      ;;
    9)
      "${opencode_setup_script}"
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
