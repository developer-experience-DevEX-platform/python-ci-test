# python-ci-test

FastAPI service used to prove the Python GitOps golden path.

```bash
pip install -r requirements.txt
make format-check
make lint
make test
make test-integration
uvicorn src.main:app --reload --port 8000
```
