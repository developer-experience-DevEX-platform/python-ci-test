import os

import pytest
from fastapi.testclient import TestClient

from app.main import app


@pytest.mark.integration
def test_health_with_integration_environment() -> None:
    assert os.environ.get("TEST_ENV") == "test"

    response = TestClient(app).get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}
