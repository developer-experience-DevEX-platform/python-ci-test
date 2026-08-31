from fastapi import FastAPI

app = FastAPI(title="Python CI Test")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "healthy"}
