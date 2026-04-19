.PHONY: test test-syntax test-functional test-all clean

# Executar todos os testes
test: test-syntax test-functional

# Executar testes unitários (estrutura)
test-unit:
	@echo "Executando testes unitários..."
	@bash scripts/tests/test.sh all

# Executar testes funcionais (comportamento)
test-functional:
	@echo "Executando testes funcionais..."
	@bash scripts/tests/test-functional.sh

# Executar testes de sintaxe
test-syntax:
	@echo "Validando sintaxe dos scripts..."
	@bash scripts/tests/test-syntax.sh

# Executar testes unitários e funcionais
test-all: test-unit test-functional

# Limpar arquivos de teste
clean:
	@echo "Limpando arquivos de teste..."
	@rm -rf /tmp/test_*

# Executar testes com timeout
test-timeout:
	@echo "Executando testes com timeout de 60 segundos..."
	@timeout 60 bash scripts/tests/test-functional.sh || echo "Testes expirados ou falharam"

# Executar testes específicos
test-script:
	@echo "Executando testes para $1..."
	@bash scripts/tests/test.sh $(1)

# Verificar status dos testes
status:
	@echo "=== Status dos Testes ==="
	@echo "Testes unitários:"
	@bash scripts/tests/test.sh all 2>&1 | tail -5
	@echo ""
	@echo "Testes funcionais:"
	@bash scripts/tests/test-functional.sh 2>&1 | tail -10
