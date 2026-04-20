# OpenCode Agent Instructions

## Purpose
Terminal setup repo: tmux, zsh, Neovim, OpenCode.

## Commands

### Installation
```bash
./install.sh              # Full install
./install.sh --no-config  # Software only
./install.sh --config-only  # Configs only (software already installed)
```

### Testing (before PR)
```bash
make test        # Run all tests (35 tests)
make test-syntax # Syntax check only
```

### tmux
```bash
tmux source-file ~/.tmux.conf  # Reload after config changes
```

## Scripts

| Script | Purpose |
|--------|---------|
| `install.sh` | Master installer with `--no-config`, `--config-only` |
| `install-nvim.sh` | Neovim + `my-nvim` config + `PlugInstall` |
| `install-opencode.sh` | npm `opencode-ai` + `my-opencode` config |
| `scripts/setup-zsh.sh` | Install zsh |
| `scripts/setup-oh-my-zsh.sh` | Install Oh My Zsh |
| `scripts/setup-spaceship.sh` | Spaceship theme, `ZSH_THEME="spaceship"` |
| `scripts/setup-zshrc.sh` | Zinit + Spaceship + NVM + fzf-tab |
| `scripts/setup-nvm.sh` | NVM from GitHub releases |
| `scripts/setup-tmux.sh` | tmux via package manager |

## Order (if running manually)
1. `setup-zsh.sh` → 2. `setup-oh-my-zsh.sh` → 3. `setup-spaceship.sh` → 4. `setup-zshrc.sh` → 5. `setup-nvm.sh` → 6. `setup-tmux.sh` → 7. `install-nvim.sh` → 8. `install-opencode.sh`

## Key Facts
- tmux prefix: `C-x` (not `C-b`)
- tmux: Dracula theme, TPM, GPU/CPU/ram/time plugins
- zsh: Zinit (not Oh My Zsh plugins), Spaceship theme
- NVM auto-activates `.nvmrc` via `load-nvmrc` hook

## Gotchas
- `--no-config`: installs software, skips config files
- `--config-only`: assumes software is installed
- Manual script execution can overwrite configs; prefer `./install.sh`
- If `.zshrc` has existing `ZSH_THEME=`, installer backs it up

## Config Locations
- `~/.tmux.conf` — tmux config
- `~/.zshrc` — zsh config
- `~/.config/nvim` — Neovim (from `leo-lucas/my-nvim`)
- `~/.config/opencode` — OpenCode (from `leo-lucas/my-opencode`)

## GitHub Actions
Tests run on push to `main`/`master` and PR creation. Check: `.github/workflows/test.yml`
