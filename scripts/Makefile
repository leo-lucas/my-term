.PHONY: test validate clean test-functional test-syntax test-all

# Executar todos os testes
test: test-syntax test-functional

# Executar testes unitários (estrutura)
test-unit:
	@echo "Executando testes unitários..."
	@bash tests/test.sh all

# Executar testes funcionais (comportamento)
test-functional:
	@echo "Executando testes funcionais..."
	@bash tests/test-functional.sh

# Executar testes de sintaxe
test-syntax:
	@echo "Validando sintaxe dos scripts..."
	@bash tests/test-syntax.sh

# Executar todos os testes
test-all: test

# Validar scripts
validate:
	@echo "Validando scripts..."
	@for script in scripts/setup-*.sh; do \
		bash -n "$$script" && echo "✓ $$script" || echo "✗ $$script"; \
	done
	@echo "Validação concluída!"

clean:
	@echo "Limpeza concluída."
