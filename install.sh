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

steps=(
  "Configurar tmux"
  "Instalar TPM e plugins"
  "Configurar Zsh"
  "Instalar Oh My Zsh"
  "Configurar .zshrc"
  "Instalar tema Spaceship"
  "Instalar NVM"
)

selected_steps=()

echo "Selecione os passos para executar (padrão: todos marcados):"
for index in "${!steps[@]}"; do
  printf "  [%s] %s) %s\n" "x" "$((index + 1))" "${steps[${index}]}"
done

read -r -p "Digite os números para DESMARCAR separados por vírgula, ou Enter para manter todos: " deselection

for index in "${!steps[@]}"; do
  selected_steps+=("$((index + 1))")
done

if [[ -n "${deselection}" ]]; then
  deselection="${deselection// /}"
  IFS=',' read -r -a deselected_steps <<< "${deselection}"

  for item in "${deselected_steps[@]}"; do
    for idx in "${!selected_steps[@]}"; do
      if [[ "${selected_steps[$idx]}" == "${item}" ]]; then
        unset 'selected_steps[idx]'
        break
      fi
    done
  done
  selected_steps=("${selected_steps[@]}")
fi

is_selected() {
  local target="$1"
  local item

  for item in "${selected_steps[@]}"; do
    if [[ "${item}" == "${target}" ]]; then
      return 0
    fi
  done
  return 1
}

run_script() {
  local script_path="$1"

  if [[ -x "${script_path}" ]]; then
    "${script_path}"
  else
    echo "Script ${script_path} não encontrado ou sem permissão de execução."
    exit 1
  fi
}

if is_selected 1; then
  mkdir -p "$(dirname "${tpm_target}")"

  if [[ -f "${tmux_conf_target}" ]]; then
    backup="${tmux_conf_target}.bak.$(date +%Y%m%d%H%M%S)"
    cp "${tmux_conf_target}" "${backup}"
    echo "Backup criado: ${backup}"
  fi

  cp "${tmux_conf_source}" "${tmux_conf_target}"
fi

if is_selected 2; then
  mkdir -p "$(dirname "${tpm_target}")"

  if [[ ! -d "${tpm_target}" ]]; then
    git clone https://github.com/tmux-plugins/tpm "${tpm_target}"
  fi

  "${HOME}/.tmux/plugins/tpm/bin/install_plugins"
fi

if is_selected 3; then
  run_script "${zsh_setup_script}"
fi

if is_selected 4; then
  run_script "${oh_my_zsh_setup_script}"
fi

if is_selected 5; then
  run_script "${zshrc_setup_script}"
fi

if is_selected 6; then
  run_script "${spaceship_setup_script}"
fi

if is_selected 7; then
  run_script "${nvm_setup_script}"
fi

echo "Instalação concluída."
echo "Abra um novo terminal ou recarregue o tmux com:"
echo "tmux source-file ~/.tmux.conf"
