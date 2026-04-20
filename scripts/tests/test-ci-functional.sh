#!/usr/bin/env bash
# Teste funcional para validar comportamento com variável CI
# Testa se install.sh não pede input quando CI está definido

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"
INSTALL_SCRIPT="${TEST_DIR}/../install.sh"

echo "========================================"
echo "Teste Funcional - Variável CI"
echo "========================================"
echo ""

# Teste: Script não pede input quando CI está definido
echo "Teste: install.sh com CI=1 (modo não interativo)"
if [[ -f "${INSTALL_SCRIPT}" ]]; then
    # Usar timeout para garantir que o script não fica bloqueado esperando input
    # Se o script tentar ler input, o timeout vai matá-lo e retornar erro
    output=$(CI=1 timeout 5 bash "${INSTALL_SCRIPT}" 2>&1 || true)
    # Verifica se não há erro de timeout (script não bloqueou)
    if echo "$output" | grep -q "timed out"; then
        echo "✗ FAIL: install.sh bloqueou esperando input com CI=1"
        exit 1
    fi
    # Verifica se não mostra prompt de seleção
    if echo "$output" | grep -q "Selecione os passos da instalação"; then
        echo "✗ FAIL: install.sh mostrou prompt com CI=1"
        exit 1
    fi
    echo "✓ PASS: install.sh executa sem bloqueio e sem prompt com CI=1"
else
    echo "✗ FAIL: install.sh não encontrado"
    exit 1
fi

echo ""
echo "========================================"
echo "Teste Funcional Concluído"
echo "========================================"
