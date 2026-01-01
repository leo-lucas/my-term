#!/usr/bin/env bash

set -euo pipefail

if ! command -v zsh >/dev/null 2>&1; then
  echo "zsh não encontrado. Execute scripts/setup-zsh.sh primeiro."
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl não encontrado. Instale o curl para continuar."
  exit 1
fi

zshrc_path="${HOME}/.zshrc"
zinit_dir="${HOME}/.zinit/bin"
zinit_install_script="https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh"

if [[ ! -d "${zinit_dir}" ]]; then
  ZINIT_HOME="${HOME}/.zinit" bash -c "$(curl -fsSL "${zinit_install_script}")"
  echo "Zinit instalado em ${zinit_dir}."
else
  echo "Zinit já está instalado."
fi

touch "${zshrc_path}"

block_start="# >>> my-term defaults >>>"
block_end="# <<< my-term defaults <<<"

if grep -q "${block_start}" "${zshrc_path}"; then
  tmp_file="$(mktemp)"
  awk -v start="${block_start}" -v end="${block_end}" '
    $0 == start {in_block=1; next}
    $0 == end {in_block=0; next}
    !in_block {print}
  ' "${zshrc_path}" > "${tmp_file}"
  mv "${tmp_file}" "${zshrc_path}"
fi

cat <<'ZSHRC' >> "${zshrc_path}"
# >>> my-term defaults >>>
# Histórico e autocorreção
HISTSIZE=50000
SAVEHIST=50000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt correct

# Spaceship prompt
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_PROMPT_ORDER=(
  time
  user
  dir
  host
  git
  node
  docker
  dotnet
  line_sep
  char
)
SPACESHIP_DOTNET_SHOW=true

# Zinit plugins
if [[ -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
  source "${HOME}/.zinit/bin/zinit.zsh"
  zinit light spaceship-prompt/spaceship-prompt
  autoload -U promptinit
  promptinit
  prompt spaceship
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-completions
  zinit light zdharma-continuum/fast-syntax-highlighting
  zinit light Aloxaf/fzf-tab
fi
# <<< my-term defaults <<<
ZSHRC

echo "Configurações padrão adicionadas ao .zshrc."
