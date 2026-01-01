#!/usr/bin/env bash

set -euo pipefail

if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh não encontrado. Execute scripts/setup-zsh.sh primeiro."
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 não encontrado. Instale o Python 3 para continuar."
  exit 1
fi

zsh_dir="${ZSH:-${HOME}/.oh-my-zsh}"
if [[ ! -d "${zsh_dir}" ]]; then
  echo "Oh My Zsh não encontrado em ${zsh_dir}. Execute scripts/setup-oh-my-zsh.sh primeiro."
  exit 1
fi

zsh_custom="${ZSH_CUSTOM:-${zsh_dir}/custom}"
spaceship_dir="${zsh_custom}/themes/spaceship-prompt"

mkdir -p "${zsh_custom}/themes"

if [[ ! -d "${spaceship_dir}" ]]; then
  git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "${spaceship_dir}"
  echo "Tema Spaceship instalado em ${spaceship_dir}."
else
  echo "Tema Spaceship já está instalado."
fi

ln -sf "${spaceship_dir}/spaceship.zsh-theme" "${zsh_custom}/themes/spaceship.zsh-theme"

zshrc_path="${HOME}/.zshrc"
if [[ -f "${zshrc_path}" ]]; then
  backup="${zshrc_path}.bak.$(date +%Y%m%d%H%M%S)"
  cp "${zshrc_path}" "${backup}"
  echo "Backup do .zshrc criado em: ${backup}"
fi

python3 - "${zshrc_path}" <<'PY'
import pathlib
import re
import sys

path = pathlib.Path(sys.argv[1])
content = path.read_text() if path.exists() else ""

line = 'ZSH_THEME="spaceship"'
if re.search(r"^\s*ZSH_THEME=", content, flags=re.M):
  content = re.sub(r"^\s*ZSH_THEME=.*$", line, content, flags=re.M)
else:
  if content and not content.endswith("\n"):
    content += "\n"
  content += f"{line}\n"

path.write_text(content)
PY

echo "Tema Spaceship configurado no .zshrc."
