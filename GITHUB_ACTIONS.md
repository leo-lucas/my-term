# GitHub Actions - Validação de Testes

## 📋 Visão Geral

Este projeto utiliza GitHub Actions para validar automaticamente os testes de instalação antes de permitir a merge de PRs.

## 🚀 Configuração do Workflow

Arquivo: `.github/workflows/test.yml`

O workflow executa em três jobs:

### 1. `test` - Testes Unitários
Executa o script principal de testes:
```bash
bash scripts/tests/test.sh all
```

### 2. `validate-scripts` - Validação de Scripts
Valida:
- ✅ Shebang correto (`#!/usr/bin/env bash`)
- ✅ pipefail habilitado (`set -euo pipefail`)
- ✅ Argumentos suportados (`--no-config`, `--config-only`)

### 3. `check-install` - Validação do Install.sh
Verifica:
- ✅ install.sh existe
- ✅ Referencia corretamente os scripts de instalação

## ✅ Status Checks

Quando você criar um PR, verá:

```
✓ test - Test installation scripts
✓ validate-scripts - Validate scripts
✓ check-install - Check install.sh
```

## 🔧 Como Funciona

```yaml
on:
  push:
    branches: [main, master]
  pull_request:
    branches: [main, master]
```

- **Push para main/master**: Executa após o push
- **Pull Request**: Executa antes do merge (obrigatório para passar)

## 📊 Exemplo de Execução

```
name: Test Installation Scripts
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run installation tests
        run: bash scripts/tests/test.sh all
```

## 🔍 Verificação Local

Para verificar antes de criar o PR:

```bash
# Executar testes
make test

# Ou
bash scripts/tests/run-all-tests.sh
```

## 📝 Melhores Práticas

1. **Sempre passe os testes** antes de criar um PR
2. **Valide localmente** com `make test`
3. **Verifique os status checks** após criar o PR
4. **Mantenha todos os 3 jobs passando**

## 🎯 Critérios de Aprovação

O PR será aprovado automaticamente quando:
- ✅ Todos os 3 jobs passam
- ✅ Nenhum script tem erros de sintaxe
- ✅ Shebang e pipefail estão corretos
- ✅ install.sh referencia todos os scripts

## 📚 Documentação Adicional

- `scripts/tests/README.md` - Documentação dos testes
- `TESTING.md` - Guia completo de testes
