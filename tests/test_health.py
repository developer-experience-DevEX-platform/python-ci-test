from fastapi.testclient import TestClient

from main import app

client = TestClient(app)


def test_health() -> None:
    response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {
        "status": "healthy",
        "ready": True,
        "service": "python-ci-test",
    }


def test_ready() -> None:
    response = client.get("/ready")

    assert response.status_code == 200
    assert response.json() == {"ready": True}


def test_unknown_route_returns_404() -> None:
    response = client.get("/missing")

    assert response.status_code == 404
