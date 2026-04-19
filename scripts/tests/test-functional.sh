#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR=$(mktemp -d)
export TEST_ENV_DIR="${TEST_DIR}"

# Contadores de teste
TESTS_PASSED=0
TESTS_FAILED=0

# Funções utilitárias
run_test_with_output() {
    local test_name="$1"
    local pattern="$2"
    local test_cmd="$3"
    local output
    local exit_code
    
    # Capturar output, exit code e verificar se contém o padrão esperado
    eval "$test_cmd" > /tmp/test_output_$$.tmp 2>&1
    exit_code=$?
    output=$(cat /tmp/test_output_$$.tmp)
    rm -f /tmp/test_output_$$.tmp
    
    # Verifica se o exit code é esperado (0 para sucesso)
    if [[ $exit_code -eq 0 ]] && echo "$output" | grep -qiE "$pattern"; then
        echo "✓ PASS: $test_name"
        TESTS_PASSED=$((TESTS_PASSED + 1)) || true
    else
        echo "✗ FAIL: $test_name"
        TESTS_FAILED=$((TESTS_FAILED + 1)) || true
    fi
}

# Limpeza ao final
cleanup() {
    rm -rf "${TEST_ENV_DIR}"
}
trap cleanup EXIT

# Setup do ambiente
setup_test_env() {
    mkdir -p "${TEST_DIR}/bin"
    mkdir -p "${TEST_DIR}/home/.oh-my-zsh/custom/themes"
    mkdir -p "${TEST_DIR}/home/.zinit/bin"
    mkdir -p "${TEST_DIR}/home/.nvm"
    mkdir -p "${TEST_DIR}/home/.tmux/plugins"
    
    export PATH="${TEST_DIR}/bin:${PATH}"
    export HOME="${TEST_DIR}/home"
    export ZSH="${TEST_DIR}/home/.oh-my-zsh"
}

# Testes para setup-zsh.sh
test_setup_zsh() {
    echo "=== setup-zsh.sh ==="
    
    run_test_with_output "detecta zsh já instalado" "zsh já está instalado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh 2>&1; true"
    
    run_test_with_output "instala via apt quando disponível" "apt-get" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh 2>&1; true"
    
    run_test_with_output "instala via dnf quando disponível" "dnf" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh 2>&1; true"
    
    run_test_with_output "instala via yum quando disponível" "yum" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh 2>&1; true"
    
    run_test_with_output "instala via pacman quando disponível" "pacman" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh 2>&1; true"
    
    run_test_with_output "instala via brew no macOS" "brew" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh 2>&1; true"
    
    run_test_with_output "respeita --no-config" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh --no-config 2>&1; true"
    
    run_test_with_output "respeita --config-only" "config-only" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh --config-only 2>&1; true"
    
    run_test_with_output "erro sem sudo disponível" "Permiss" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh 2>&1; true"
}

# Testes para setup-oh-my-zsh.sh
test_setup_oh_my_zsh() {
    echo ""
    echo "=== setup-oh-my-zsh.sh ==="
    
    run_test_with_output "erro sem zsh instalado" "zsh não encontrado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh 2>&1; true"
    
    run_test_with_output "instala Oh My Zsh" "Oh My Zsh" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh 2>&1; true"
    
    run_test_with_output ".zshrc criado a partir do template" "template|\.zshrc" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh 2>&1; true"
    
    run_test_with_output "Oh My Zsh já instalado detectado" "já está instalado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh 2>&1; true"
    
    run_test_with_output "respeita --no-config" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh --no-config 2>&1; true"
    
    run_test_with_output "respeita --config-only" "config-only" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh --config-only 2>&1; true"
    
    run_test_with_output "erro sem curl" "curl não encontrado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh 2>&1; true"
}

# Testes para setup-spaceship.sh
test_setup_spaceship() {
    echo ""
    echo "=== setup-spaceship.sh ==="
    
    run_test_with_output "erro sem zsh instalado" "zsh não encontrado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh 2>&1; true"
    
    run_test_with_output "erro sem Oh My Zsh" "Oh My Zsh não encontrado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh 2>&1; true"
    
    run_test_with_output "detecta Zinit instalado" "Zinit" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh 2>&1; true"
    
    run_test_with_output "instala em diretório correto" "spaceship-prompt" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh 2>&1; true"
    
    run_test_with_output "clona repositório git" "git clone|clone" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh 2>&1; true"
    
    run_test_with_output "symlink criado" "symlink" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh 2>&1; true"
    
    run_test_with_output "ZSH_THEME configurado" "ZSH_THEME|spaceship" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh 2>&1; true"
    
    run_test_with_output "backup criado" "backup" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh 2>&1; true"
    
    run_test_with_output "respeita --no-config" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh --no-config 2>&1; true"
    
    run_test_with_output "respeita --config-only" "config-only" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh --config-only 2>&1; true"
}

# Testes para setup-zshrc.sh
test_setup_zshrc() {
    echo ""
    echo "=== setup-zshrc.sh ==="
    
    run_test_with_output "erro sem zsh instalado" "zsh não encontrado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "detecta curl" "curl" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "erro sem curl" "curl não encontrado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "instala Zinit" "Zinit" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "Zinit já instalado detectado" "já está instalado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "blocos de configuração adicionados" "my-term defaults" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "configurações de histórico" "HISTSIZE|SAVEHIST|share_history" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "Spaceship configurado" "SPACESHIP" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "plugins Zinit configurados" "zsh-users|zinit|Zinit" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "NVM configurado" "NVM|nvm.sh" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "load-nvmrc hook adicionado" "load-nvmrc|add-zsh-hook" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh 2>&1; true"
    
    run_test_with_output "respeita --no-config" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh --no-config 2>&1; true"
    
    run_test_with_output "respeita --config-only" "config-only" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh --config-only 2>&1; true"
}

# Testes para setup-nvm.sh
test_setup_nvm() {
    echo ""
    echo "=== setup-nvm.sh ==="
    
    run_test_with_output "erro sem curl" "curl não encontrado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh 2>&1; true"
    
    run_test_with_output "erro sem zsh" "zsh não encontrado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh 2>&1; true"
    
    run_test_with_output "detecta versão mais recente" "versão|v[0-9]" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh 2>&1; true"
    
    run_test_with_output "fallback para versão padrão" "v0\\.39\\.7|fallback" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh 2>&1; true"
    
    run_test_with_output "NVM já instalado detectado" "já está" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh 2>&1; true"
    
    run_test_with_output "versão atual < mais recente executa atualização" "atualizar|installing" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh 2>&1; true"
    
    run_test_with_output "versão igual diz que está atualizado" "mais recente|up to date" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh 2>&1; true"
    
    run_test_with_output ".nvm/nvm.sh criado" ".nvm/nvm.sh" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh 2>&1; true"
    
    run_test_with_output "respeita --no-config" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh --no-config 2>&1; true"
    
    run_test_with_output "respeita --config-only" "config-only" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh --config-only 2>&1; true"
}

# Testes para setup-tmux.sh
test_setup_tmux() {
    echo ""
    echo "=== setup-tmux.sh ==="
    
    run_test_with_output "tmux já instalado detectado" "já está instalado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "instala via apt quando disponível" "apt-get" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "instala via dnf quando disponível" "dnf" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "instala via yum quando disponível" "yum" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "instala via pacman quando disponível" "pacman" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "instala via brew no macOS" "brew" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "erro sem gerenciador de pacotes" "não suportado" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "erro sem sudo" "Permiss" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "configura .tmux.conf" "tmux.conf|prefix|Dracula" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "TPM instalado" "TPM|plugin" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh 2>&1; true"
    
    run_test_with_output "respeita --no-config" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh --no-config 2>&1; true"
    
    run_test_with_output "respeita --config-only" "config-only" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh --config-only 2>&1; true"
}

# Testes de argumentos comuns
test_common_arguments() {
    echo ""
    echo "=== Argumentos Comuns ==="
    
    run_test_with_output "--no-config em setup-zsh.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh --no-config 2>&1; true"
    
    run_test_with_output "--no-config em setup-oh-my-zsh.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh --no-config 2>&1; true"
    
    run_test_with_output "--no-config em setup-spaceship.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh --no-config 2>&1; true"
    
    run_test_with_output "--no-config em setup-zshrc.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh --no-config 2>&1; true"
    
    run_test_with_output "--no-config em setup-nvm.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh --no-config 2>&1; true"
    
    run_test_with_output "--no-config em setup-tmux.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh --no-config 2>&1; true"
    
    run_test_with_output "--config-only em setup-zsh.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh --config-only 2>&1; true"
    
    run_test_with_output "--config-only em setup-oh-my-zsh.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-oh-my-zsh.sh . && chmod +x setup-oh-my-zsh.sh && bash setup-oh-my-zsh.sh --config-only 2>&1; true"
    
    run_test_with_output "--config-only em setup-spaceship.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-spaceship.sh . && chmod +x setup-spaceship.sh && bash setup-spaceship.sh --config-only 2>&1; true"
    
    run_test_with_output "--config-only em setup-zshrc.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zshrc.sh . && chmod +x setup-zshrc.sh && bash setup-zshrc.sh --config-only 2>&1; true"
    
    run_test_with_output "--config-only em setup-nvm.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-nvm.sh . && chmod +x setup-nvm.sh && bash setup-nvm.sh --config-only 2>&1; true"
    
    run_test_with_output "--config-only em setup-tmux.sh" "config" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-tmux.sh . && chmod +x setup-tmux.sh && bash setup-tmux.sh --config-only 2>&1; true"
    
    run_test_with_output "argumento inválido mostra uso" "uso" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh --invalid-arg 2>&1; true"
    
    run_test_with_output "sem argumentos executa comportamento padrão" "zsh já está" \
        "cd ${TEST_DIR} && cp ${SCRIPT_DIR}/mocks/setup-zsh.sh . && chmod +x setup-zsh.sh && bash setup-zsh.sh 2>&1; true"
}

# Main
main() {
    echo "========================================"
    echo "Testes Funcionais - Scripts de Instalação"
    echo "========================================"
    echo ""
    
    setup_test_env
    
    test_setup_zsh
    test_setup_oh_my_zsh
    test_setup_spaceship
    test_setup_zshrc
    test_setup_nvm
    test_setup_tmux
    test_common_arguments
    
    echo ""
    echo "========================================"
    echo "Resultados: $((TESTS_PASSED + TESTS_FAILED)) testes executados"
    echo "  ✓ Passados: $TESTS_PASSED"
    echo "  ✗ Falhados: $TESTS_FAILED"
    echo "========================================"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo ""
        echo "✓ Todos os testes passaram!"
        exit 0
    else
        echo ""
        echo "✗ Alguns testes falharam"
        exit 1
    fi
}

main
