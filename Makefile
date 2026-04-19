.PHONY: test test-scripts test-install test-syntax validate clean

test:
	@echo "Executando testes unitários..."
	@bash scripts/tests/test.sh all

test-scripts:
	@echo "Executando testes dos scripts..."
	@bash scripts/tests/test.sh all

test-install:
	@echo "Executando testes de instalação..."
	@bash scripts/tests/test.sh all

test-tmux:
	@echo "Executando testes do tmux..."
	@bash scripts/tests/test.sh tmux

test-syntax:
	@echo "Validando sintaxe dos scripts..."
	@for script in scripts/setup-*.sh; do \
		bash -n "$$script" && echo "✓ $$script" || echo "✗ $$script"; \
	done

validate: test-syntax test

clean:
	@echo "Limpando arquivos temporários..."
	@rm -rf scripts/tests/.tmp-*
	@echo "Limpeza concluída."
