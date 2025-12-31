#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux_conf_source="${repo_dir}/.tmux.conf"

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

echo "Instalação concluída."
echo "Abra um novo terminal ou recarregue o tmux com:"
echo "tmux source-file ~/.tmux.conf"
