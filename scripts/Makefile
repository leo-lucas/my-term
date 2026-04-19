.PHONY: test validate clean

test:
	@echo "Executando testes..."
	@bash tests/test.sh all

validate:
	@echo "Validando scripts..."
	@for script in scripts/setup-*.sh; do \
		bash -n "$$script" && echo "✓ $$script" || echo "✗ $$script"; \
	done
	@echo "Validação concluída!"

clean:
	@echo "Limpeza concluída."
