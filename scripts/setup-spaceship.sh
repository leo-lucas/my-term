#!/usr/bin/env bash

set -euo pipefail

if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh não encontrado. Execute scripts/setup-zsh.sh primeiro."
  exit 1
fi

zsh_dir="${ZSH:-${HOME}/.oh-my-zsh}"
if [[ ! -d "${zsh_dir}" ]]; then
  echo "Oh My Zsh não encontrado em ${zsh_dir}. Execute scripts/setup-oh-my-zsh.sh primeiro."
  exit 1
fi

themes_dir="${zsh_dir}/themes"
spaceship_dir="${themes_dir}/spaceship-prompt"

mkdir -p "${themes_dir}"

if [[ ! -d "${spaceship_dir}" ]]; then
  git clone --depth=1 https://github.com/spaceship-prompt/spaceship-prompt.git "${spaceship_dir}"
  echo "Tema Spaceship instalado em ${spaceship_dir}."
else
  echo "Tema Spaceship já está instalado."
fi

ln -sf "${spaceship_dir}/spaceship.zsh-theme" "${themes_dir}/spaceship.zsh-theme"

os_name="$(uname -s)"
zshrc_path="${HOME}/.zshrc"
if [[ -f "${zshrc_path}" ]]; then
  backup="${zshrc_path}.bak.$(date +%Y%m%d%H%M%S)"
  cp "${zshrc_path}" "${backup}"
  echo "Backup do .zshrc criado em: ${backup}"
fi

touch "${zshrc_path}"
if grep -q "^ZSH_THEME=" "${zshrc_path}"; then
  if [[ "${os_name}" == "Darwin" ]]; then
    sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="spaceship"/' "${zshrc_path}"
  else
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="spaceship"/' "${zshrc_path}"
  fi
else
  echo 'ZSH_THEME="spaceship"' >> "${zshrc_path}"
fi

echo "Tema Spaceship configurado no .zshrc."
