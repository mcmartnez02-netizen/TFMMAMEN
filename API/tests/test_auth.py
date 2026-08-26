"""Authentication and authorization: /token, /user/create, scope enforcement."""

from conftest import PASSWORD


def test_status_needs_no_token(client):
    assert client.get("/status/").json() == {"status": "ok"}


def test_login_returns_a_bearer_token(client, make_user):
    make_user("someone", ["read"])
    response = client.post(
        "/token", data={"username": "someone", "password": PASSWORD, "scope": "read"}
    )
    assert response.status_code == 200
    assert response.json()["token_type"] == "bearer"


def test_login_with_wrong_password_is_rejected(client, make_user):
    make_user("someone", ["read"])
    response = client.post(
        "/token", data={"username": "someone", "password": "wrong", "scope": "read"}
    )
    assert response.status_code == 400


def test_login_with_unknown_user_is_rejected(client):
    response = client.post("/token", data={"username": "ghost", "password": PASSWORD})
    assert response.status_code == 400


def test_cannot_request_a_scope_the_user_does_not_have(client, make_user):
    """A read-only user must not be able to mint a write token."""
    make_user("someone", ["read"])
    response = client.post(
        "/token", data={"username": "someone", "password": PASSWORD, "scope": "write"}
    )
    assert response.status_code == 400
    assert "write" in response.json()["detail"]


def test_protected_endpoint_requires_a_token(client):
    assert client.get("/new").status_code == 401


def test_protected_endpoint_rejects_a_forged_token(client):
    response = client.get("/new", headers={"Authorization": "Bearer not-a-real-jwt"})
    assert response.status_code == 401


def test_me_reports_the_authenticated_user(client, reader):
    body = client.get("/user/me/", headers=reader).json()
    assert body["username"] == "reader"
    assert "hashed_password" not in body  # never leak the hash


def test_admin_can_create_a_user_who_can_then_log_in(client, admin):
    response = client.post(
        "/user/create",
        headers=admin,
        json={"username": "recruit", "password": "s3cret", "allowed_scopes": ["read"]},
    )
    assert response.status_code == 200

    login = client.post(
        "/token", data={"username": "recruit", "password": "s3cret", "scope": "read"}
    )
    assert login.status_code == 200


def test_non_admin_cannot_create_a_user(client, reader):
    response = client.post(
        "/user/create",
        headers=reader,
        json={"username": "recruit", "password": "s3cret", "allowed_scopes": ["read"]},
    )
    assert response.status_code == 401


def test_creating_a_duplicate_user_is_a_conflict(client, admin):
    payload = {"username": "twin", "password": "s3cret", "allowed_scopes": ["read"]}
    assert client.post("/user/create", headers=admin, json=payload).status_code == 200
    assert client.post("/user/create", headers=admin, json=payload).status_code == 409
