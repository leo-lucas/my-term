#!/bin/bash
# Script de execução de testes para my-term

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"

echo "========================================"
echo "Executando Testes de Instalação"
echo "========================================"
echo ""

bash "$SCRIPT_DIR/test.sh" all
RESULT=$?

echo ""
echo "========================================"
if [ $RESULT -eq 0 ]; then
    echo "✓ Testes concluídos com sucesso!"
else
    echo "✡ Alguns testes falharam."
fi
echo "========================================"

exit $RESULT
