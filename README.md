# my-term - Terminal Configuration

<div align="center">

[![Test Installation Scripts](https://github.com/leo-lucas/my-term/actions/workflows/test.yml/badge.svg)](https://github.com/leo-lucas/my-term/actions/workflows/test.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**Complete terminal configuration for tmux, zsh, Neovim, and OpenCode**

</div>

---

## 🚀 Quick Start

```bash
# Full installation
./install.sh

# Install software only (no configs)
./install.sh --no-config

# Install configs only (software already installed)
./install.sh --config-only
```

## 📋 Table of Contents

- [Installation](#installation)
- [Manual Setup](#manual-setup)
- [Components](#components)
- [Configuration](#configuration)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)

## Installation

### Automatic Installation

Run the installation script to set up everything:

```bash
./install.sh
```

This will install:
- ✅ tmux with Dracula theme
- ✅ zsh with Zinit and Spaceship theme
- ✅ Oh My Zsh
- ✅ NVM (Node Version Manager)
- ✅ Neovim with custom config
- ✅ OpenCode with custom config

### Remote Installation

Install without cloning the repository:

```bash
curl -fsSL https://raw.githubusercontent.com/leo-lucas/my-term/main/install-from-github.sh | bash
```

## Manual Setup

If you prefer to install components manually:

### 1. Install tmux

**Linux (Debian/Ubuntu):**
```bash
sudo apt update && sudo apt install tmux
```

**macOS:**
```bash
brew install tmux
```

**Windows (WSL):**
```bash
sudo apt update && sudo apt install tmux
```

### 2. Copy tmux configuration

```bash
cp ./.tmux.conf ~/.tmux.conf
```

### 3. Reload tmux

```bash
tmux source-file ~/.tmux.conf
```

### 4. Install Neovim

```bash
./install-nvim.sh
```

### 5. Install OpenCode

```bash
./install-opencode.sh
```

### 6. Setup zsh (optional)

```bash
./scripts/setup-zsh.sh
./scripts/setup-oh-my-zsh.sh
./scripts/setup-zshrc.sh
./scripts/setup-spaceship.sh
./scripts/setup-nvm.sh
```

## Components

### tmux

- **Prefix:** `C-x` (changed from default `C-b`)
- **Theme:** Dracula
- **Plugins:** TPM, GPU, CPU, Memory, Time
- **Session management:** Automatic session creation

### zsh

- **Plugin Manager:** Zinit
- **Theme:** Spaceship
- **Plugins:**
  - zsh-autosuggestions
  - zsh-completions
  - fast-syntax-highlighting
  - fzf-tab
- **Features:**
  - NVM auto-activation via `.nvmrc`
  - History: 50,000 commands
  - Autocorrect and history reduction

### Neovim

- **Config:** From `leo-lucas/my-nvim`
- **Auto-installs:** Plugins via `PlugInstall`

### OpenCode

- **Config:** From `leo-lucas/my-opencode`
- **Install:** Via npm package `opencode-ai`

## Configuration

### tmux Configuration

File: `~/.tmux.conf`

```bash
# Key bindings
bind -r C-x send-prefix
set -g prefix C-x
unbind C-b

# Themes
source $HOME/.tmux/plugins/tpm/plugins/dracula/dracula-tmux.conf
```

### zsh Configuration

File: `~/.zshrc`

```bash
# Zinit
source $HOME/.zinit/bin/zinit.zsh
zinit light spaceship-prompt/spaceship-prompt

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# load-nvmrc hook
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc ]]; then
    nvm install
    nvm use
  fi
}
add-zsh-hook chpwd load-nvmrc
```

## Testing

### Run All Tests

```bash
# Using make
make test

# Or directly
bash scripts/tests/run-all-tests.sh

# Or specific test
bash scripts/tests/test.sh all
```

### Test Coverage

All scripts are validated against:
- ✅ Syntax validation (`bash -n`)
- ✅ Shebang correctness (`#!/usr/bin/env bash`)
- ✅ pipefail enabled (`set -euo pipefail`)
- ✅ Argument support (`--no-config`, `--config-only`)
- ✅ Dependency checks (zsh, curl, tmux, etc.)

**Total Tests:** 35/35 passed

### GitHub Actions

Tests run automatically on:
- Push to `main`/`master`
- Pull Request creation

Check status at: [Actions](https://github.com/leo-lucas/my-term/actions)

## Troubleshooting

### tmux Configuration Not Loading

```bash
# Verify file exists
ls -la ~/.tmux.conf

# Reload configuration
tmux source-file ~/.tmux.conf

# Check for errors
tmux source-file ~/.tmux.conf 2>&1
```

### zsh Issues

```bash
# Verify zsh is installed
which zsh

# Check .zshrc exists
ls -la ~/.zshrc

# Source manually
source ~/.zshrc
```

### NVM Not Working

```bash
# Verify NVM is installed
ls -la ~/.nvm/nvm.sh

# Source NVM manually
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install specific Node version
nvm install --lts
```

### Common Issues

| Issue | Solution |
|-------|----------|
| tmux prefix not working | Restart tmux: `tmux source-file ~/.tmux.conf` |
| zsh theme not loading | Check `ZSH_THEME="spaceship"` in `.zshrc` |
| NVM not activating | Ensure `.nvmrc` file exists in project |
| Plugin not loading | Run `tmux source-file ~/.tmux.conf` and restart |

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `install.sh` | Master installer with all options |
| `install-nvim.sh` | Neovim installation |
| `install-opencode.sh` | OpenCode installation |
| `scripts/setup-zsh.sh` | Install zsh |
| `scripts/setup-oh-my-zsh.sh` | Install Oh My Zsh |
| `scripts/setup-zshrc.sh` | Configure zshrc with Zinit |
| `scripts/setup-spaceship.sh` | Install Spaceship theme |
| `scripts/setup-nvm.sh` | Install NVM |
| `scripts/setup-tmux.sh` | Install tmux |

## Testing

### Unit Tests

```bash
# Run all tests
make test

# Validate syntax only
make test-syntax

# Run specific test
bash scripts/tests/test.sh all
```

### GitHub Actions

Automated testing on PR:
- ✅ Test installation scripts
- ✅ Validate script syntax
- ✅ Check shebang and pipefail
- ✅ Verify install.sh references

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) before submitting PRs.

## Support

- 📖 [Documentation](TESTING.md)
- 🐛 [Issues](https://github.com/leo-lucas/my-term/issues)
- 💬 [Discussions](https://github.com/leo-lucas/my-term/discussions)

---

<div align="center">

Made with ❤️ by [leo-lucas](https://github.com/leo-lucas)

[![GitHub stars](https://img.shields.io/github/stars/leo-lucas/my-term?style=social)](https://github.com/leo-lucas/my-term/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/leo-lucas/my-term?style=social)](https://github.com/leo-lucas/my-term/network)

</div>
