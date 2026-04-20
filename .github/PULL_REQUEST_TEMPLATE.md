## Descrição
<!-- Descreva suas alterações de forma clara -->

## Tipo de Mudança
<!-- Marque as opções relevantes -->
- [ ] Correção de bug
- [ ] Nova funcionalidade
- [ ] Refatoração
- [ ] Documentação
- [ ] Outros: _______

## Verificação de Testes
<!-- Antes de submeter, certifique-se de que os testes passaram -->
- [ ] Meus testes passam localmente com `make test`
- [ ] Novos testes foram adicionados para minhas alterações
- [ ] Testes de syntax foram executados

### Executar Testes Locais
```bash
# Executar todos os testes
make test

# Validar apenas sintaxe
make test-syntax
```

## Checklist de Qualidade
- [ ] Código segue as convenções do projeto
- [ ] Scripts têm shebang correto (`#!/usr/bin/env bash`)
- [ ] Scripts têm `set -euo pipefail`
- [ ] Scripts suportam `--no-config` e `--config-only`

## Testes do GitHub Actions
Os testes são executados automaticamente em:
- Push para `main`/`master`
- Pull Request para a branch `main`/`master`

Status dos testes: [![Test](https://github.com/leo-lucas/my-term/actions/workflows/test.yml/badge.svg)](https://github.com/leo-lucas/my-term/actions/workflows/test.yml)
