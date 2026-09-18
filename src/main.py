from fastapi import FastAPI

app = FastAPI(title="python-ci-test")


@app.get("/health")
def health() -> dict[str, str | bool]:
    return {
        "status": "healthy",
        "ready": True,
        "service": "python-ci-test",
    }


@app.get("/ready")
def ready() -> dict[str, bool]:
    return {"ready": True}
