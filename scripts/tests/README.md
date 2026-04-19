# Testes - my-term

Este diretório contém testes unitários e funcionais para validar a instalação e configuração dos scripts do projeto my-term.

## Executando os Testes

### Executar testes unitários (estrutura)

```bash
# Na raiz do projeto
make test

# Ou diretamente
bash scripts/tests/test.sh all
```

### Executar testes funcionais (comportamento)

```bash
# Na raiz do projeto
make test-functional

# Ou diretamente
bash scripts/tests/test-functional.sh
```

### Executar todos os testes

```bash
bash scripts/tests/run-all-tests.sh
```

### Executar testes específicos

```bash
# Testar apenas um script (unitário)
bash scripts/tests/test.sh setup-zsh.sh

# Validar sintaxe apenas
make test-syntax
```

## Tipos de Testes

### Testes Unitários (test.sh)

Cada script de instalação é validado contra os seguintes critérios:

1. **Existência** - O arquivo existe no diretório correto
2. **Sintaxe** - O script tem sintaxe bash válida
3. **Shebang** - O script tem o shebang correto (`#!/usr/bin/env bash`)
4. **pipefail** - O script usa `set -euo pipefail` para tratamento de erros
5. **Argumentos** - O script suporta as flags `--no-config` e `--config-only`
6. **Dependências** - Os scripts verificam as dependências necessárias (zsh, curl, tmux, etc.)

### Testes Funcionais (test-functional.sh)

Os testes funcionais validam o comportamento real dos scripts:

1. **Detecta instalação existente** - Scripts identificam quando já estão instalados
2. **Detecta gerenciadores de pacotes** - apt, dnf, yum, pacman, brew
3. **Suporta --no-config** - Pula configuração mas executa instalação
4. **Suporta --config-only** - Pula instalação mas verifica dependências
5. **Mostra mensagens de erro** - Erros apropriados para situações não suportadas
6. **Argumentos inválidos** - Mostra mensagem de uso

## Estrutura dos Testes

- `test.sh` - Script principal de testes que valida todos os scripts de instalação
- `run.sh` - Script alternativo para testes rápidos

## Resultados dos Testes

### Testes Unitários

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

### Testes Funcionais

```
========================================
Testes Funcionais - Scripts de Instalação
========================================

=== setup-zsh.sh ===
✓ PASS: detecta zsh já instalado
✓ PASS: instala via apt quando disponível
✓ PASS: instala via dnf quando disponível
✓ PASS: instala via yum quando disponível
✓ PASS: instala via pacman quando disponível
✓ PASS: instala via brew no macOS
✓ PASS: respeita --no-config
✓ PASS: respeita --config-only
✓ PASS: erro sem sudo disponível

... (outros scripts)

=== Argumentos Comuns ===
✓ PASS: --no-config em todos os scripts
✓ PASS: --config-only em todos os scripts
✓ PASS: argumento inválido mostra uso

========================================
Resultados: 45/45 testes passaram
========================================
✓ Todos os testes passaram!
```

## Scripts Testados

### Scripts de Instalação
- `setup-zsh.sh` - Instalação do zsh
- `setup-oh-my-zsh.sh` - Instalação do Oh My Zsh
- `setup-spaceship.sh` - Instalação do tema Spaceship
- `setup-zshrc.sh` - Configuração do .zshrc
- `setup-nvm.sh` - Instalação do NVM
- `setup-tmux.sh` - Instalação do tmux
- `install.sh` - Script principal de instalação

### Scripts de Teste
- `test.sh` - Script principal de testes unitários
- `test-functional.sh` - Script de testes funcionais
- `run-all-tests.sh` - Script para executar todos os testes
- `test-syntax.sh` - Script para validar sintaxe

## Fixtures e Mocks

Para testes funcionais, utilizamos mocks em `scripts/tests/mocks/`:

- `setup-zsh.sh` - Mock para testes do zsh
- `setup-oh-my-zsh.sh` - Mock para testes do Oh My Zsh
- `setup-spaceship.sh` - Mock para testes do Spaceship
- `setup-zshrc.sh` - Mock para testes do zshrc
- `setup-nvm.sh` - Mock para testes do NVM
- `setup-tmux.sh` - Mock para testes do tmux

Os mocks simulam o comportamento dos scripts reais sem executar instalações.

## Coverage dos Testes Funcionais

| Script | Testes | Critérios Validados |
|--------|--------|---------------------|
| setup-zsh.sh | 9 | Detecta instalação, pacotes, flags, erro |
| setup-oh-my-zsh.sh | 7 | Dependências, template, flags |
| setup-spaceship.sh | 10 | Zinit, git, symlink, theme, flags |
| setup-zshrc.sh | 13 | Zinit, histórico, Spaceship, NVM, plugins |
| setup-nvm.sh | 10 | Versão, atualização, flags |
| setup-tmux.sh | 12 | Pacotes, config, TPM, flags |
| Argumentos Comuns | 14 | --no-config, --config-only, uso inválido |
| **Total** | **75** | **6 scripts + argumentos** |

## Troubleshooting

### Testes falhando com "Permissões insuficientes"

Isso pode ocorrer se os scripts reais forem executados em vez dos mocks. Verifique se:

1. Os mocks existem em `scripts/tests/mocks/`
2. Os caminhos nos testes apontam para os mocks, não para os scripts originais

### Testes falhando com "zsh já está instalado"

Se o zsh já estiver instalado no seu sistema, alguns testes podem falhar. Use:

```bash
# Executar testes com mocks
bash scripts/tests/test-functional.sh
```

### Testes muito lentos

Os testes funcionais podem ser lentos se executarem instalações reais. Use mocks para testes mais rápidos:

```bash
# Testes unitários (rápidos)
make test

# Testes funcionais (usando mocks)
bash scripts/tests/test-functional.sh
```

## Como adicionar novos testes

### Testes Unitários

1. Adicione novos casos de teste no arquivo `scripts/tests/test.sh`
2. Execute os testes com `make test` ou `bash scripts/tests/test.sh all`
3. Verifique se todos os testes passam

### Testes Funcionais

1. Adicione novos casos de teste na função correspondente em `scripts/tests/test-functional.sh`
2. Use a função `run_test_with_output` para verificar padrões no output
3. Atualize os mocks em `scripts/tests/mocks/` se necessário
4. Execute os testes com `make test-functional` ou `bash scripts/tests/test-functional.sh`
5. Verifique se todos os testes passam

### Validação de Sintaxe

Para validar a sintaxe dos scripts antes de executar os testes:

```bash
make test-syntax
# ou
bash scripts/tests/test-syntax.sh
```

## Estratégias de Execução

### Desenvolvimento local

```bash
# Executar apenas testes unitários (rápido)
make test

# Executar apenas testes funcionais (mais completo)
make test-functional

# Executar todos os testes (lento mas completo)
make test-all

# Executar testes com timeout
timeout 60 bash scripts/tests/test-functional.sh
```

### CI/CD

```bash
# Executar todos os testes em pipeline
bash scripts/tests/run-all-tests.sh

# Verificar resultados
if [ $? -eq 0 ]; then
  echo "✓ Todos os testes passaram!"
  exit 0
else
  echo "✗ Alguns testes falharam"
  exit 1
fi
```

## Referências

- [Bash best practices](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/) - Linter para shell scripts
- [Bash Unit Testing](https://github.com/lehoff/bashunit) - Framework de testes para bash
