# Plano de Testes Funcionais - Scripts de Instalação

## Resumo
Os testes atuais em `scripts/tests/test.sh` apenas validam estrutura (sintaxe, shebang, pipefail, existência de argumentos), mas não validam as funcionalidades reais dos scripts. Este documento descreve o plano para criar testes funcionais que validem o comportamento real dos scripts.

## Arquivo de Testes
- **Novo arquivo**: `scripts/tests/test-functional.sh`
- **Objetivo**: Validar comportamentos reais de cada script

---

## Estrutura do Teste Funcional

```bash
#!/usr/bin/env bash
set -euo pipefail

# Criar ambiente isolado para testes
TEST_DIR=$(mktemp -d)
export TEST_ENV_DIR="${TEST_DIR}"

# Limpeza automática
trap 'rm -rf "${TEST_ENV_DIR}"' EXIT
```

---

## Casos de Teste por Script

### 1. setup-zsh.sh

**Objetivo**: Validar instalação do zsh em diferentes sistemas

- [ ] **zsh já instalado**: Script diz "zsh já está instalado" e retorna exit 0
- [ ] **zsh não instalado**: Simula instalação corretamente
- [ ] **Linux com apt**: Detecta apt-get e executa instalação
- [ ] **Linux com dnf**: Detecta dnf e executa instalação
- [ ] **Linux com yum**: Detecta yum e executa instalação
- [ ] **Linux com pacman**: Detecta pacman e executa instalação
- [ ] **macOS com brew**: Detecta brew e executa instalação
- [ ] **`--no-config`**: Respeita flag (pula configuração, se houver)
- [ ] **`--config-only`**: Não instala, apenas reporta
- [ ] **sem sudo disponível**: Erro apropriado

---

### 2. setup-oh-my-zsh.sh

**Objetivo**: Validar instalação do Oh My Zsh e configuração do .zshrc

- [ ] **sem zsh instalado**: Erro: "zsh não encontrado. Execute scripts/setup-zsh.sh primeiro."
- [ ] **zsh instalado**: Instala Oh My Zsh em ~/.oh-my-zsh
- [ ] **curl disponível**: Executa instalação via curl
- [ ] **sem curl**: Erro: "curl não encontrado"
- [ ] **.zshrc criado**: Copia template do Oh My Zsh se .zshrc não existir
- [ ] **Oh My Zsh já instalado**: Diz "Oh My Zsh já está instalado"
- [ ] **`--no-config`**: Respeita flag
- [ ] **`--config-only`**: Pula instalação mas verifica dependências

---

### 3. setup-spaceship.sh

**Objetivo**: Validar instalação do tema Spaceship e configuração do .zshrc

- [ ] **sem zsh instalado**: Erro: "zsh não encontrado"
- [ ] **sem Oh My Zsh**: Erro: "Oh My Zsh não encontrado em ~/.oh-my-zsh"
- [ ] **Zinit instalado**: Detecta Zinit e reporta que Spaceship será carregado via Zinit
- [ ] **Instalação completa**: Instala em ${ZSH:-${HOME}/.oh-my-zsh}/custom/themes/spaceship-prompt
- [ ] **Clona repositório**: Executa `git clone --depth=1`
- [ ] **Symlink criado**: ${ZSH_CUSTOM}/themes/spaceship.zsh-theme aponta para spaceship-prompt
- [ ] **ZSH_THEME configurado**: Adiciona/altera `ZSH_THEME="spaceship"` no .zshrc
- [ ] **Backup criado**: Se .zshrc existir, cria backup com timestamp
- [ ] **`--no-config`**: Respeita flag
- [ ] **`--config-only`**: Pula instalação

---

### 4. setup-zshrc.sh

**Objetivo**: Validar configuração completa do .zshrc

- [ ] **sem zsh instalado**: Erro: "zsh não encontrado"
- [ ] **curl disponível**: Executa instalação do Zinit
- [ ] **sem curl**: Erro: "curl não encontrado"
- [ ] **Zinit instalado**: Instala em ~/.zinit/bin
- [ ] **Zinit já instalado**: Diz "Zinit já está instalado"
- [ ] **Blocos de configuração**: Adiciona bloco `# >>> my-term defaults <<< ... # <<< my-term defaults <<<`
- [ ] **Configurações de histórico**:
  - HISTSIZE=50000
  - SAVEHIST=50000
  - setopt share_history
  - setopt hist_ignore_dups
  - setopt hist_ignore_all_dups
  - setopt hist_reduce_blanks
  - setopt correct
- [ ] **Spaceship configurado**:
  - SPACESHIP_PROMPT_ADD_NEWLINE=false
  - SPACESHIP_CHAR_SYMBOL="❯"
  - SPACESHIP_CHAR_SUFFIX=" "
  - SPACESHIP_PROMPT_ORDER configurado
  - SPACESHIP_DOTNET_SHOW=true
- [ ] **Plugins Zinit**:
  - spaceship-prompt/spaceship-prompt
  - zsh-users/zsh-autosuggestions
  - zsh-users/zsh-completions
  - zdharma-continuum/fast-syntax-highlighting
  - Aloxaf/fzf-tab
- [ ] **NVM configurado**:
  - export NVM_DIR="${HOME}/.nvm"
  - source "${NVM_DIR}/nvm.sh"
- [ ] **load-nvmrc hook**: add-zsh-hook precmd load-nvmrc
- [ ] **Remover blocos duplicados**: Remove blocos `my-term defaults` antes de adicionar
- [ ] **`--no-config`**: Respeita flag
- [ ] **`--config-only`**: Pula instalação

---

### 5. setup-nvm.sh

**Objetivo**: Validar instalação e atualização do NVM

- [ ] **sem curl**: Erro: "curl não encontrado"
- [ ] **sem zsh**: Erro: "zsh não encontrado"
- [ ] **Versão mais recente**: Detecta via GitHub API (curl + sed/jq)
- [ ] **Versão não detectada**: Usa fallback v0.39.7
- [ ] **NVM já instalado**: Verifica versão atual em .nvm/nvm.sh
- [ ] **Versão atual < mais recente**: Executa atualização
- [ ] **Versão igual**: Diz "NVM já está na versão mais recente"
- [ ] **.nvm/nvm.sh criado**: Após instalação
- [ ] **`--no-config`**: Respeita flag
- [ ] **`--config-only`**: Pula instalação

---

### 6. setup-tmux.sh

**Objetivo**: Validar instalação do tmux e configuração do .tmux.conf

- [ ] **tmux já instalado**: Diz "tmux já está instalado" e exit 0
- [ ] **Linux com apt**: Detecta e instala via apt-get
- [ ] **Linux com dnf**: Detecta e instala via dnf
- [ ] **Linux com yum**: Detecta e instala via yum
- [ ] **Linux com pacman**: Detecta e instala via pacman
- [ ] **macOS com brew**: Detecta e instala via brew
- [ ] **sem gerenciador de pacotes**: Erro: "Gerenciador de pacotes não suportado"
- [ ] **sem sudo**: Erro: "Permissões insuficientes"
- [ ] **Sem flag --no-config**:
  - .tmux.conf configurado (copiado de scripts/.tmux.conf)
  - Backup criado se existir
  - TPM instalado em ~/.tmux/plugins/tpm
  - Plugins instalados via install_plugins
- [ ] **`--no-config`**: Pula configuração do .tmux.conf e TPM
- [ ] **`--config-only`**: Pula instalação

---

## Testes de Argumentos Comuns

- [ ] **`--no-config` em todos os scripts**: Cada script respeita a flag e pula configuração
- [ ] **`--config-only` em todos os scripts**: Cada script pula instalação mas mantém verificações de dependência
- [ ] **Argumento inválido**: Mostra mensagem de uso e exit 1
- [ ] **Sem argumentos**: Executa comportamento padrão

---

## Formato de Output

```bash
=== setup-zsh.sh ===
✓ PASS: zsh detectado quando já instalado
✓ PASS: instala via apt quando disponível
✓ PASS: instala via dnf quando disponível
✓ PASS: instala via yum quando disponível
✓ PASS: instala via pacman quando disponível
✓ PASS: instala via brew no macOS
✓ PASS: --no-config respeitado
✓ PASS: --config-only respeitado
✓ PASS: erro sem sudo disponível

=== setup-oh-my-zsh.sh ===
✓ PASS: erro sem zsh
✓ PASS: instala Oh My Zsh
✓ PASS: .zshrc criado a partir do template
✓ PASS: Oh My Zsh já instalado detectado
✓ PASS: --no-config respeitado
✓ PASS: --config-only respeitado
✓ PASS: erro sem curl

... (demais scripts)

=== Argumentos Comuns ===
✓ PASS: --no-config em todos os scripts
✓ PASS: --config-only em todos os scripts
✓ PASS: argumento inválido mostra uso

========================================
Resultados: 45/45 testes passaram
========================================
✓ Todos os testes passaram!
```

---

## Critérios de Avaliação

| Critério | Valor Mínimo |
|----------|--------------|
| Total de testes | 30+ |
| Scripts testados | 6 (zsh, oh-my-zsh, spaceship, zshrc, nvm, tmux) |
| Argumentos testados | 2 (--no-config, --config-only) |
| Pass rate | 100% |
| Exit code | 0 se todos passaram, 1 se algum falhar |

---

## Entregáveis

1. **scripts/tests/test-functional.sh**
   - Script principal de testes funcionais
   - Ambiente isolado com limpeza automática

2. **scripts/tests/README.md** (atualização)
   - Adicionar seção "Testes Funcionais"
   - Listar novos critérios de validação
   - Exemplos de output

3. **scripts/tests/run-all-tests.sh** (atualização)
   - Integrar testes funcionais
   - Opção para executar apenas funcionais ou todos

4. **Makefile** (atualização)
   - Adicionar target `test-functional`
   - Exemplo: `make test-functional`

---

## Implementação Recomendada

### Estrutura do Script

```bash
#!/usr/bin/env bash
set -euo pipefail

# Funções utilitárias
run_test() { ... }
pass() { ... }
fail() { ... }

# Setup do ambiente
setup_test_env() { ... }
cleanup() { ... }

# Testes por script
test_setup_zsh() { ... }
test_setup_oh_my_zsh() { ... }
test_setup_spaceship() { ... }
test_setup_zshrc() { ... }
test_setup_nvm() { ... }
test_setup_tmux() { ... }

# Testes de argumentos comuns
test_common_arguments() { ... }

# Main
main() { ... }
```

### Técnicas de Teste

1. **Mock de comandos**: Criar versões mockadas de apt, brew, curl, git
2. **Ambiente controlado**: Executar scripts em diretório temporário
3. **Verificação de estado**: Checar arquivos criados após execução
4. **Captura de output**: Validar mensagens exibidas
5. **Verificação de exit code**: Validar códigos de retorno

---

## Exemplo de Implementação

```bash
test_setup_zsh_zsh_already_installed() {
    # Simular zsh instalado
    mkdir -p "${TEST_ENV_DIR}/bin"
    touch "${TEST_ENV_DIR}/bin/zsh"
    export PATH="${TEST_ENV_DIR}/bin:${PATH}"
    
    # Executar script
    output=$(bash scripts/tests/setup-zsh.sh 2>&1)
    
    # Validar output
    if echo "$output" | grep -q "zsh já está instalado"; then
        pass "zsh detectado quando já instalado"
    else
        fail "zsh detectado quando já instalado"
    fi
}

test_setup_zsh_installs_via_apt() {
    # Simular sistema Linux com apt
    mkdir -p "${TEST_ENV_DIR}/bin"
    touch "${TEST_ENV_DIR}/bin/sudo"
    touch "${TEST_ENV_DIR}/bin/apt-get"
    export PATH="${TEST_ENV_DIR}/bin:${PATH}"
    
    # Simular ausência de zsh
    rm -f "${TEST_ENV_DIR}/bin/zsh"
    
    # Executar script (não deve executar instalação real)
    # Testar se detecta apt corretamente
    output=$(bash scripts/tests/setup-zsh.sh 2>&1 || true)
    
    if echo "$output" | grep -q "apt-get"; then
        pass "detecta apt quando disponível"
    else
        fail "detecta apt quando disponível"
    fi
}
```

---

## Referências

- [Bash best practices](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/) - Linter para shell scripts
- [Bash Unit Testing](https://github.com/lehoff/bashunit) - Framework de testes para bash

---

## Status

- [ ] Criar `scripts/tests/test-functional.sh`
- [ ] Implementar testes para setup-zsh.sh
- [ ] Implementar testes para setup-oh-my-zsh.sh
- [ ] Implementar testes para setup-spaceship.sh
- [ ] Implementar testes para setup-zshrc.sh
- [ ] Implementar testes para setup-nvm.sh
- [ ] Implementar testes para setup-tmux.sh
- [ ] Implementar testes de argumentos comuns
- [ ] Atualizar `scripts/tests/README.md`
- [ ] Atualizar `scripts/tests/run-all-tests.sh`
- [ ] Atualizar Makefile
- [ ] Executar todos os testes e validar

---

**Última atualização**: 2026-04-19
**Versão do plano**: 1.0
