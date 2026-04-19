#!/usr/bin/env bash
set -o pipefail

echo "Validando sintaxe dos scripts..."
echo ""

ERRORS=0

# Validar todos os scripts de instalação
for script in scripts/setup-*.sh scripts/install.sh scripts/tests/test.sh scripts/tests/test-functional.sh; do
    if [ -f "$script" ]; then
        if bash -n "$script" 2>&1; then
            echo "✓ $script"
        else
            echo "✗ $script - ERRO DE SINTAXE"
            ((ERRORS++))
        fi
    fi
done

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✓ Todos os scripts têm sintaxe válida!"
    exit 0
else
    echo "✗ $ERRORS script(s) com erros de sintaxe"
    exit 1
fi
