# Testes de Instalação e Configuração - my-term

## Resumo

Este projeto inclui testes unitários completos para validação dos scripts de instalação e configuração.

## Testes Criados

### 1. `scripts/tests/test.sh`
Script principal de testes que valida:
- Existência dos scripts
- Sintaxe bash válida
- Shebang correto (`#!/usr/bin/env bash`)
- pipefail habilitado (`set -euo pipefail`)
- Argumentos suportados (`--no-config`, `--config-only`)
- Dependências verificadas (zsh, curl, tmux, etc.)

### 2. `scripts/tests/run-all-tests.sh`
Script alternativo para executar todos os testes.

### 3. `scripts/tests/README.md`
Documentação completa dos testes.

### 4. `Makefile` na raiz
Comandos Make para executar testes:
- `make test` - Executa todos os testes
- `make test-syntax` - Valida sintaxe dos scripts
- `make validate` - Executa todos os testes
- `make clean` - Limpa arquivos temporários

### 5. `scripts/Makefile`
Comandos Make para os scripts:
- `make test` - Executa testes
- `make validate` - Valida scripts

## Executando os Testes

```bash
# Executar todos os testes
make test

# Ou diretamente
bash scripts/tests/run-all-tests.sh

# Validar apenas sintaxe
make test-syntax
```

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

=== install.sh ===
✓ PASS: install.sh existe
✓ PASS: install.sh referencia setup-zsh.sh

========================================
Resultados: 35/35 testes passaram
========================================
✓ Todos os testes passaram!
```

## Scripts Testados

1. `setup-zsh.sh` - Instalação do zsh
2. `setup-oh-my-zsh.sh` - Instalação do Oh My Zsh
3. `setup-spaceship.sh` - Instalação do tema Spaceship
4. `setup-zshrc.sh` - Configuração do .zshrc
5. `setup-nvm.sh` - Instalação do NVM
6. `setup-tmux.sh` - Instalação do tmux
7. `install.sh` - Script principal de instalação

## Critérios de Validação

Cada script é validado contra:
- **Existência**: Arquivo existe no diretório correto
- **Sintaxe**: `bash -n <script>` retorna sucesso
- **Shebang**: Primeira linha é `#!/usr/bin/env bash`
- **pipefail**: Contém `set -euo pipefail`
- **Argumentos**: Contém `--no-config` e `--config-only`
- **Dependências**: Verifica comandos necessários (zsh, curl, tmux)

## Referências

- [Bash best practices](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/)
- [Bash Unit Testing](https://github.com/lehoff/bashunit)
