# GitHub Actions Workflows

## Test Installation Scripts

Valida todos os scripts de instalação do projeto my-term antes de mergear PRs.

### Jobs

1. **test** - Executa os testes unitários completos
2. **validate-scripts** - Valida shebang, pipefail e argumentos
3. **check-install** - Verifica install.sh e suas referências

### Execução

- **Push para main/master**: Executa após push
- **Pull Request**: Executa antes do merge

### Status Checks

```
✓ test - Test installation scripts
✓ validate-scripts - Validate scripts
✓ check-install - Check install.sh
```

### Configuração

O workflow executa em `ubuntu-latest` e valida:
- Sintaxe dos scripts bash
- Shebang correto (`#!/usr/bin/env bash`)
- pipefail habilitado (`set -euo pipefail`)
- Suporte a argumentos (`--no-config`, `--config-only`)
- Referências corretas nos scripts
