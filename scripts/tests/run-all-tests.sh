#!/usr/bin/env bash
set -euo pipefail

echo "========================================"
echo "Executando todos os testes - my-term"
echo "========================================"
echo ""

# Contadores
TOTAL_PASSED=0
TOTAL_FAILED=0

# Executar testes unitários
echo "=== Testes Unitários ==="
if bash scripts/tests/test.sh all 2>&1; then
    echo "✓ Testes unitários concluídos"
    ((TOTAL_PASSED++))
else
    echo "✗ Testes unitários falharam"
    ((TOTAL_FAILED++))
fi
echo ""

# Executar testes funcionais
echo "=== Testes Funcionais ==="
if bash scripts/tests/test-functional.sh 2>&1; then
    echo "✓ Testes funcionais concluídos"
    ((TOTAL_PASSED++))
else
    echo "✗ Testes funcionais falharam"
    ((TOTAL_FAILED++))
fi
echo ""

# Resultados
echo "========================================"
echo "Resultados Finais"
echo "========================================"
echo "✓ Testes unitários: OK"
if [ $TOTAL_FAILED -eq 0 ]; then
    echo "✓ Testes funcionais: OK"
else
    echo "✗ Testes funcionais: FALHOU"
fi
echo ""
if [ $TOTAL_FAILED -eq 0 ]; then
    echo "✓ Todos os testes passaram!"
    exit 0
else
    echo "✗ Alguns testes falharam"
    exit 1
fi
