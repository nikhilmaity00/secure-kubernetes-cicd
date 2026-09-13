from app import app


def test_health_endpoint():
    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200

    data = response.get_json()

    assert data["status"] == "healthy"
    assert data["application"] == "secure-kubernetes-cicd"


def test_version_endpoint():
    client = app.test_client()

    response = client.get("/version")

    assert response.status_code == 200

    data = response.get_json()

    assert data["application"] == "secure-kubernetes-cicd"
    assert data["version"] == "1.0.0"