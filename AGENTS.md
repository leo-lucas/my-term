# OpenCode Agent Instructions

## Purpose
This repository configures a personal terminal environment: tmux, zsh, Neovim, and OpenCode.

## Key Commands

### Full installation
```bash
./install.sh
```

### Install without configs (software only)
```bash
./install.sh --no-config
```

### Install configs only (requires software installed)
```bash
./install.sh --config-only
```

### Install from remote (no clone)
```bash
curl -fsSL https://raw.githubusercontent.com/leo-lucas/my-term/main/install-from-github.sh | bash
```

### Reload tmux after config changes
```bash
tmux source-file ~/.tmux.conf
```

## Running Tests

### Validate all scripts before PR
```bash
make test
```

### Run tests directly
```bash
bash scripts/tests/run-all-tests.sh
```

### Validate syntax only
```bash
make test-syntax
```

## Script Anatomy

| Script | Purpose |
|--------|---------|
| `install.sh` | Master installer, supports `--no-config` and `--config-only` flags |
| `install-nvim.sh` | Installs Neovim + clones `my-nvim` config, runs `PlugInstall` |
| `install-opencode.sh` | Installs `opencode-ai` npm package + clones `my-opencode` config |
| `scripts/setup-zsh.sh` | Installs zsh via system package manager |
| `scripts/setup-oh-my-zsh.sh` | Installs Oh My Zsh, creates `.zshrc` template |
| `scripts/setup-zshrc.sh` | Installs Zinit + configures zshrc with Spaceship, NVM, fzf-tab |
| `scripts/setup-spaceship.sh` | Installs Spaceship theme, sets `ZSH_THEME="spaceship"` |
| `scripts/setup-nvm.sh` | Installs latest NVM from GitHub releases |
| `scripts/setup-tmux.sh` | Installs tmux via package manager |

## Testing Scripts

| Test Script | Description |
|-------------|-------------|
| `scripts/tests/test.sh` | Main test runner (35 tests) |
| `scripts/tests/run-all-tests.sh` | Alternative test runner |
| `scripts/tests/README.md` | Test documentation |

### Test Coverage
- ✅ Script existence
- ✅ Syntax validation (`bash -n`)
- ✅ Shebang correctness (`#!/usr/bin/env bash`)
- ✅ pipefail enabled (`set -euo pipefail`)
- ✅ Argument support (`--no-config`, `--config-only`)
- ✅ Dependency checks

**Total: 35/35 tests passed**

## Configuration Locations

- `~/.tmux.conf` — tmux config (prefix: `C-x`, Dracula theme, TPM)
- `~/.zshrc` — zsh config (Zinit, Spaceship, NVM, autosuggestions)
- `~/.config/nvim` — Neovim config (from `leo-lucas/my-nvim`)
- `~/.config/opencode` — OpenCode config (from `leo-lucas/my-opencode`)

## Order Matters

Scripts have dependencies. Run in this order if executing individually:

1. `scripts/setup-zsh.sh` — zsh must exist first
2. `scripts/setup-oh-my-zsh.sh` — requires zsh
3. `scripts/setup-spaceship.sh` — requires zsh and Oh My Zsh
4. `scripts/setup-zshrc.sh` — requires zsh
5. `scripts/setup-nvm.sh` — requires zsh
6. `scripts/setup-tmux.sh` — tmux standalone
7. `install-nvim.sh` — standalone
8. `install-opencode.sh` — standalone

## Framework/Toolchain Facts

- Uses **Zinit** (not Oh My Zsh plugins) for zsh plugin management
- Uses **Dracula** theme for tmux with GPU/CPU/ram/time plugins
- Uses **TPM** (tmux plugin manager) for tmux plugins
- NVM auto-activates `.nvmrc` projects via `load-nvmrc` hook
- Prefix for tmux is `C-x` (not default `C-b`)

## Gotchas

- `--no-config` installs software but skips config file changes
- `--config-only` skips software installation, assumes it's already installed
- Running multiple scripts manually can overwrite configs; prefer `./install.sh`
- If `.zshrc` already has `ZSH_THEME=`, the installer creates a timestamped backup

## GitHub Actions

Automated testing runs on:
- Push to `main`/`master`
- Pull Request creation

Check status: `.github/workflows/test.yml`

## Documentation

- `README.md` - Main documentation
- `TESTING.md` - Testing guide
- `GITHUB_ACTIONS.md` - GitHub Actions guide
- `scripts/tests/README.md` - Test documentation
