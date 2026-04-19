# Testes Unitários - my-term

Este diretório contém os testes unitários para validar a instalação e configuração dos scripts do projeto my-term.

## Executando os Testes

### Executar todos os testes

```bash
# Na raiz do projeto
make test

# Ou diretamente
bash scripts/tests/test.sh all
```

### Executar testes específicos

```bash
# Testar todos os scripts
bash scripts/tests/test.sh all

# Testar apenas um script específico
bash scripts/tests/test.sh setup-zsh.sh
```

### Validar sintaxe apenas

```bash
make test-syntax
```

## O que é testado

Cada script de instalação é validado contra os seguintes critérios:

1. **Existência** - O arquivo existe no diretório correto
2. **Sintaxe** - O script tem sintaxe bash válida
3. **Shebang** - O script tem o shebang correto (`#!/usr/bin/env bash`)
4. **pipefail** - O script usa `set -euo pipefail` para tratamento de erros
5. **Argumentos** - O script suporta as flags `--no-config` e `--config-only`
6. **Dependências** - Os scripts verificam as dependências necessárias (zsh, curl, tmux, etc.)

## Estrutura dos Testes

- `test.sh` - Script principal de testes que valida todos os scripts de instalação
- `run.sh` - Script alternativo para testes rápidos

## Resultados dos Testes

```
========================================
Testes Unitários - Scripts de Instalação
========================================

=== setup-zsh.sh ===
✓ PASS: setup-zsh.sh existe
✓ PASS: setup-zsh.sh - sintaxe válida
✓ PASS: setup-zsh.sh - shebang correto
✓ PASS: setup-zsh.sh - pipefail habilitado
✓ PASS: setup-zsh.sh - suporta --no-config e --config-only

... (outros scripts)

=== install.sh ===
✓ PASS: install.sh existe
✓ PASS: install.sh referencia setup-zsh.sh

========================================
Resultados: 35/35 testes passaram
========================================
✓ Todos os testes passaram!
```

## Scripts Testados

- `setup-zsh.sh` - Instalação do zsh
- `setup-oh-my-zsh.sh` - Instalação do Oh My Zsh
- `setup-spaceship.sh` - Instalação do tema Spaceship
- `setup-zshrc.sh` - Configuração do .zshrc
- `setup-nvm.sh` - Instalação do NVM
- `setup-tmux.sh` - Instalação do tmux
- `install.sh` - Script principal de instalação

## Como adicionar novos testes

1. Adicione novos casos de teste no arquivo `scripts/tests/test.sh`
2. Execute os testes com `make test` ou `bash scripts/tests/test.sh all`
3. Verifique se todos os testes passam

## Referências

- [Bash best practices](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/) - Linter para shell scripts
- [Bash Unit Testing](https://github.com/lehoff/bashunit) - Framework de testes para bash
