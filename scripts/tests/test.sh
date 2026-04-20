#!/usr/bin/env bash
# Testes unitários para scripts de instalação
# Uso: bash scripts/tests/test.sh [script]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"

PASSED=0
FAILED=0

echo "========================================"
echo "Testes Unitários - Scripts de Instalação"
echo "========================================"
echo ""

# Testes para cada script
for script in setup-zsh.sh setup-oh-my-zsh.sh setup-spaceship.sh setup-zshrc.sh setup-nvm.sh setup-tmux.sh; do
    echo "=== ${script} ==="
    
    # Teste: Script existe
    if [[ -f "${TEST_DIR}/${script}" ]]; then
        echo "✓ PASS: ${script} existe"
        PASSED=$((PASSED + 1))
    else
        echo "✗ FAIL: ${script} não encontrado"
        FAILED=$((FAILED + 1))
    fi
    
    # Teste: Sintaxe válida
    if bash -n "${TEST_DIR}/${script}" 2>/dev/null; then
        echo "✓ PASS: ${script} - sintaxe válida"
        PASSED=$((PASSED + 1))
    else
        echo "✗ FAIL: ${script} - erro de sintaxe"
        FAILED=$((FAILED + 1))
    fi
    
    # Teste: Shebang correto
    first_line=$(head -n1 "${TEST_DIR}/${script}")
    if [[ "$first_line" == "#!/usr/bin/env bash" ]]; then
        echo "✓ PASS: ${script} - shebang correto"
        PASSED=$((PASSED + 1))
    else
        echo "✗ FAIL: ${script} - shebang incorreto: ${first_line}"
        FAILED=$((FAILED + 1))
    fi
    
    # Teste: pipefail habilitado
    if grep -q "set -euo pipefail" "${TEST_DIR}/${script}"; then
        echo "✓ PASS: ${script} - pipefail habilitado"
        PASSED=$((PASSED + 1))
    else
        echo "✗ FAIL: ${script} - pipefail não habilitado"
        FAILED=$((FAILED + 1))
    fi
    
    # Teste: Argumentos suportados
    if grep -q -- '--no-config' "${TEST_DIR}/${script}" && grep -q -- '--config-only' "${TEST_DIR}/${script}"; then
        echo "✓ PASS: ${script} - suporta --no-config e --config-only"
        PASSED=$((PASSED + 1))
    else
        echo "✗ FAIL: ${script} - não suporta argumentos corretamente"
        FAILED=$((FAILED + 1))
    fi
    
    # Teste: Dependências verificadas
    case "$script" in
        setup-oh-my-zsh.sh)
            if grep -q "command -v zsh" "${TEST_DIR}/setup-oh-my-zsh.sh"; then
                echo "✓ PASS: setup-oh-my-zsh.sh verifica zsh"
                PASSED=$((PASSED + 1))
            else
                echo "✗ FAIL: setup-oh-my-zsh.sh não verifica zsh"
                FAILED=$((FAILED + 1))
            fi
            ;;
        setup-nvm.sh)
            if grep -q "command -v curl" "${TEST_DIR}/setup-nvm.sh"; then
                echo "✓ PASS: setup-nvm.sh verifica curl"
                PASSED=$((PASSED + 1))
            else
                echo "✗ FAIL: setup-nvm.sh não verifica curl"
                FAILED=$((FAILED + 1))
            fi
            ;;
        setup-tmux.sh)
            if grep -q "command -v tmux" "${TEST_DIR}/setup-tmux.sh"; then
                echo "✓ PASS: setup-tmux.sh verifica tmux"
                PASSED=$((PASSED + 1))
            else
                echo "✗ FAIL: setup-tmux.sh não verifica tmux"
                FAILED=$((FAILED + 1))
            fi
            ;;
    esac
    
    echo ""
done

# Testes específicos do install-opencode.sh
echo "=== install-opencode.sh ==="

if [[ -f "${TEST_DIR}/../install-opencode.sh" ]]; then
    echo "✓ PASS: install-opencode.sh existe"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install-opencode.sh não encontrado"
    FAILED=$((FAILED + 1))
fi

# Teste: Sintaxe válida
if bash -n "${TEST_DIR}/../install-opencode.sh" 2>/dev/null; then
    echo "✓ PASS: install-opencode.sh - sintaxe válida"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install-opencode.sh - erro de sintaxe"
    FAILED=$((FAILED + 1))
fi

# Teste: Shebang correto
first_line=$(head -n1 "${TEST_DIR}/../install-opencode.sh")
if [[ "$first_line" == "#!/usr/bin/env bash" ]]; then
    echo "✓ PASS: install-opencode.sh - shebang correto"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install-opencode.sh - shebang incorreto: ${first_line}"
    FAILED=$((FAILED + 1))
fi

# Teste: pipefail habilitado
if grep -q "set -euo pipefail" "${TEST_DIR}/../install-opencode.sh"; then
    echo "✓ PASS: install-opencode.sh - pipefail habilitado"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install-opencode.sh - pipefail não habilitado"
    FAILED=$((FAILED + 1))
fi

# Teste: Argumentos suportados
if grep -q -- '--no-config' "${TEST_DIR}/../install-opencode.sh" && grep -q -- '--config-only' "${TEST_DIR}/../install-opencode.sh"; then
    echo "✓ PASS: install-opencode.sh - suporta --no-config e --config-only"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install-opencode.sh - não suporta argumentos corretamente"
    FAILED=$((FAILED + 1))
fi

# Teste: Mensagem de aviso SSH antes do git clone
if grep -q -i "senha SSH\|SSH.*senha\|Nota.*SSH" "${TEST_DIR}/../install-opencode.sh"; then
    echo "✓ PASS: install-opencode.sh - mensagem de aviso SSH presente"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install-opencode.sh - mensagem de aviso SSH não encontrada"
    FAILED=$((FAILED + 1))
fi

# Teste: Mensagem específica para git clone
if grep -B3 "git clone" "${TEST_DIR}/../install-opencode.sh" | grep -q -i "senha\|ssh"; then
    echo "✓ PASS: install-opencode.sh - mensagem explicativa antes do git clone"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install-opencode.sh - mensagem explicativa antes do git clone não encontrada"
    FAILED=$((FAILED + 1))
fi

# Teste: Mensagem específica para git pull
if grep -B3 "git pull" "${TEST_DIR}/../install-opencode.sh" | grep -q -i "senha\|ssh"; then
    echo "✓ PASS: install-opencode.sh - mensagem explicativa antes do git pull"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install-opencode.sh - mensagem explicativa antes do git pull não encontrada"
    FAILED=$((FAILED + 1))
fi

echo ""

# Testes específicos do install.sh
   echo "=== install.sh ==="
if [[ -f "${TEST_DIR}/../install.sh" ]]; then
    echo "✓ PASS: install.sh existe"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install.sh não encontrado"
    FAILED=$((FAILED + 1))
fi

if grep -q "setup-zsh.sh" "${TEST_DIR}/../install.sh"; then
    echo "✓ PASS: install.sh referencia setup-zsh.sh"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install.sh não referencia setup-zsh.sh"
    FAILED=$((FAILED + 1))
fi

# Teste: Verifica variável CI para entrada interativa
if grep -q 'CI' "${TEST_DIR}/../install.sh"; then
    echo "✓ PASS: install.sh verifica variável CI"
    PASSED=$((PASSED + 1))
else
    echo "✗ FAIL: install.sh não verifica variável CI"
    FAILED=$((FAILED + 1))
fi

# Teste funcional: Validar comportamento com CI
    if [[ -f "${TEST_DIR}/test-ci-functional.sh" ]]; then
        echo "Testando comportamento funcional com CI..."
        if bash "${TEST_DIR}/test-ci-functional.sh" 2>/dev/null; then
            echo "✓ PASS: Teste funcional CI passou"
            PASSED=$((PASSED + 1))
        else
            echo "✗ FAIL: Teste funcional CI falhou"
            FAILED=$((FAILED + 1))
        fi
    fi

echo ""
echo "========================================"
TOTAL=$((PASSED + FAILED))
echo "Resultados: ${PASSED}/${TOTAL} testes passaram"
echo "========================================"

if [[ ${FAILED} -eq 0 ]]; then
    echo "✓ Todos os testes passaram!"
    exit 0
else
    echo "✗ ${FAILED} teste(s) falhou(aram)"
    exit 1
fi
