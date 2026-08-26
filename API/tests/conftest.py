"""Shared fixtures.

Every test runs against a throwaway SQLite file, never against
database/default.db. The redirection works by pointing the module-level
db_functions.DEFAULT_DB at a temporary path *before* the app starts:
get_conn reads that global on each call, so the real get_conn (pragmas
and all) is exercised rather than a stubbed replacement.
"""

import sqlite3
import sys
from pathlib import Path

import pytest

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

import api_classes as ac
import db_functions as db
from fastapi.testclient import TestClient
from security import get_password_hash

PASSWORD = "test-password"

@pytest.fixture
def db_path(tmp_path, monkeypatch):
    """Redirect the whole app to a fresh database for one test."""
    path = tmp_path / "test.db"
    monkeypatch.setattr(db, "DEFAULT_DB", path)
    return path


@pytest.fixture
def client(db_path):
    """TestClient whose lifespan creates the schema in the temporary database."""
    import api

    with TestClient(api.app) as c:
        yield c


@pytest.fixture
def make_user(db_path):
    """Create a user directly in the database, bypassing the API.

    Tests need users with specific scopes, and /user/create itself requires
    an admin token -- so building them here keeps each test independent of the
    endpoint it is not trying to exercise.
    """

    def _make(username: str, scopes: list[str]) -> str:
        conn = sqlite3.connect(db_path)
        try:
            db.create_new_user(
                conn,
                ac.User(username=username, allowed_scopes=scopes),
                get_password_hash(PASSWORD),
            )
        finally:
            conn.close()
        return username

    return _make


@pytest.fixture
def auth(client, make_user):
    """Return an Authorization header for a new user with the given scopes.

    Requesting a token is a real POST /token round trip, so the fixture also
    covers the happy path of the login flow for every test that uses it.
    """

    def _auth(username: str, scopes: list[str]) -> dict[str, str]:
        make_user(username, scopes)
        response = client.post(
            "/token",
            data={
                "username": username,
                "password": PASSWORD,
                "scope": " ".join(scopes),
            },
        )
        assert response.status_code == 200, response.text
        return {"Authorization": f"Bearer {response.json()['access_token']}"}

    return _auth


@pytest.fixture
def writer(auth):
    return auth("writer", ["write"])


@pytest.fixture
def reader(auth):
    return auth("reader", ["read"])


@pytest.fixture
def admin(auth):
    return auth("boss", ["admin", "read", "write"])


def heartbeats(*states: str, start: int = 0) -> list[dict]:
    """Build a payload of heartbeats, one per state given."""
    return [
        {
            "device_timestamp": f"2026-01-01T00:00:{start + i:02d}",
            "bpm": 80 + i,
            "state": state,
            "seq": start + i,
        }
        for i, state in enumerate(states)
    ]


@pytest.fixture
def run_with_data(client, writer):
    """A reserved run owned by writer, holding 1 stressed + 2 relaxed beats."""
    run_id = client.get("/new", headers=writer).json()["run_id"]
    response = client.post(
        f"/upload?run_id={run_id}",
        headers=writer,
        json=heartbeats("Estresado", "Relajado", "Relajado"),
    )
    assert response.status_code == 200, response.text
    return run_id
