#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux_conf_source="${repo_dir}/.tmux.conf"
zsh_setup_script="${repo_dir}/scripts/setup-zsh.sh"
oh_my_zsh_setup_script="${repo_dir}/scripts/setup-oh-my-zsh.sh"
zshrc_setup_script="${repo_dir}/scripts/setup-zshrc.sh"
spaceship_setup_script="${repo_dir}/scripts/setup-spaceship.sh"
nvm_setup_script="${repo_dir}/scripts/setup-nvm.sh"

tmux_conf_target="${HOME}/.tmux.conf"
tpm_target="${HOME}/.tmux/plugins/tpm"

mkdir -p "$(dirname "${tpm_target}")"

if [[ -f "${tmux_conf_target}" ]]; then
  backup="${tmux_conf_target}.bak.$(date +%Y%m%d%H%M%S)"
  cp "${tmux_conf_target}" "${backup}"
  echo "Backup criado: ${backup}"
fi

cp "${tmux_conf_source}" "${tmux_conf_target}"

if [[ ! -d "${tpm_target}" ]]; then
  git clone https://github.com/tmux-plugins/tpm "${tpm_target}"
fi

"${HOME}/.tmux/plugins/tpm/bin/install_plugins"

if [[ -x "${zsh_setup_script}" ]]; then
  "${zsh_setup_script}"
else
  echo "Script ${zsh_setup_script} não encontrado ou sem permissão de execução."
  exit 1
fi

if [[ -x "${oh_my_zsh_setup_script}" ]]; then
  "${oh_my_zsh_setup_script}"
else
  echo "Script ${oh_my_zsh_setup_script} não encontrado ou sem permissão de execução."
  exit 1
fi

if [[ -x "${zshrc_setup_script}" ]]; then
  "${zshrc_setup_script}"
else
  echo "Script ${zshrc_setup_script} não encontrado ou sem permissão de execução."
  exit 1
fi

if [[ -x "${spaceship_setup_script}" ]]; then
  "${spaceship_setup_script}"
else
  echo "Script ${spaceship_setup_script} não encontrado ou sem permissão de execução."
  exit 1
fi

if [[ -x "${nvm_setup_script}" ]]; then
  "${nvm_setup_script}"
else
  echo "Script ${nvm_setup_script} não encontrado ou sem permissão de execução."
  exit 1
fi

echo "Instalação concluída."
echo "Abra um novo terminal ou recarregue o tmux com:"
echo "tmux source-file ~/.tmux.conf"
