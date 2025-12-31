#!/bin/bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
tmux_conf_source="${repo_dir}/.tmux.conf"
status_script_source="${repo_dir}/system_status_cli.py"
status_package_source="${repo_dir}/system_status"

tmux_conf_target="${HOME}/.tmux.conf"
status_script_target="${HOME}/.local/bin/system_status"
status_package_target="${HOME}/.local/lib/system_status"

mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.local/lib"

if [[ -f "${tmux_conf_target}" ]]; then
  backup="${tmux_conf_target}.bak.$(date +%Y%m%d%H%M%S)"
  cp "${tmux_conf_target}" "${backup}"
  echo "Backup criado: ${backup}"
fi

cp "${tmux_conf_source}" "${tmux_conf_target}"
cp "${status_script_source}" "${status_script_target}"
rm -rf "${status_package_target}"
cp -R "${status_package_source}" "${status_package_target}"
chmod +x "${status_script_target}"

echo "Instalação concluída."
echo "Abra um novo terminal ou recarregue o tmux com:"
echo "tmux source-file ~/.tmux.conf"
