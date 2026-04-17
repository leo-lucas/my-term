# Agent Instructions

## Setup & Installation

**Main install command:** `./install.sh`

**Individual setup steps:**
1. Tmux + TPM plugins
2. Zsh installation (`scripts/setup-zsh.sh`)
3. Oh My Zsh (`scripts/setup-oh-my-zsh.sh`)
4. zshrc config (`scripts/setup-zshrc.sh`)
5. Spaceship theme (`scripts/setup-spaceship.sh`)
6. NVM (`scripts/setup-nvm.sh`)
7. Neovim (`install-nvim.sh`)
8. OpenCode (`install-opencode.sh`)

## Commands

- `./install.sh` - Install and configure everything automatically
- `tmux source-file ~/.tmux.conf` - Reload tmux config
- `nvim` - Start Neovim (auto-installs plugins on first run)
- `opencode` - Start OpenCode

## Architecture

**Purpose:** This repo hosts dotfiles and installers for a dev environment:
- `~/.tmux.conf` - Tmux configuration with TPM plugin manager
- `install.sh` - Main orchestrator script calling sub-scripts
- `install-nvim.sh` - Installs Neovim and clones `my-nvim` config from GitHub
- `install-opencode.sh` - Installs OpenCode CLI and clones `my-opencode` config
- `scripts/` - Individual setup scripts for zsh, oh-my-zsh, spaceship, nvm

**External config repos:**
- Neovim: `https://github.com/leo-lucas/my-nvim.git`
- OpenCode: `https://github.com/leo-lucas/my-opencode.git`

## Gotchas

- Scripts exit on error (`set -e` or `set -euo pipefail`)
- Neovim plugins are installed automatically on first launch: `nvim -c 'autocmd VimEnter * PlugInstall | qall'`
- OpenCode is installed via `npm install -g opencode-ai`
- Existing configs are backed up with timestamps before replacement
