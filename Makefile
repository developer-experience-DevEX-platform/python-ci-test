.PHONY: format-check lint test test-integration

format-check:
	black --check .

lint:
	ruff check .

test:
	pytest -m "not integration" --cov=src --cov-report=xml --cov-report=term-missing

test-integration:
	pytest -m integration
