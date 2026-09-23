# python-ci-test

FastAPI service used to prove the Python GitOps golden path.

```bash
uv sync
make verify
make test-integration
uv run uvicorn src.main:app --reload --port 8000
```
