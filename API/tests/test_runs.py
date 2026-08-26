"""Run reservation, heartbeat upload, and reading heartbeats back."""

from conftest import heartbeats


def test_new_run_ids_are_unique_and_increasing(client, writer):
    first = client.get("/new", headers=writer).json()["run_id"]
    second = client.get("/new", headers=writer).json()["run_id"]
    assert second > first


def test_reader_cannot_reserve_a_run(client, reader):
    assert client.get("/new", headers=reader).status_code == 401


def test_upload_stores_every_heartbeat(client, writer):
    run_id = client.get("/new", headers=writer).json()["run_id"]
    response = client.post(
        f"/upload?run_id={run_id}", headers=writer, json=heartbeats("Estresado", "Relajado")
    )
    assert response.json() == {"inserted": 2, "received": 2}


def test_reupload_is_idempotent(client, writer, reader):
    """A client retrying after a timeout must not get an error, and must not
    duplicate rows -- this is what INSERT OR IGNORE buys us."""
    run_id = client.get("/new", headers=writer).json()["run_id"]
    payload = heartbeats("Estresado", "Relajado")

    client.post(f"/upload?run_id={run_id}", headers=writer, json=payload)
    retry = client.post(f"/upload?run_id={run_id}", headers=writer, json=payload)

    assert retry.status_code == 200
    assert retry.json() == {"inserted": 0, "received": 2}
    count = client.get(f"/runs/heartbeats/count?run_id={run_id}", headers=reader)
    assert count.json()["entries"] == 2


def test_upload_to_an_unreserved_run_is_404(client, writer):
    response = client.post(
        "/upload?run_id=99999", headers=writer, json=heartbeats("Estresado")
    )
    assert response.status_code == 404


def test_upload_to_someone_elses_run_is_403(client, writer, auth):
    """The ownership check -- the reason `assert` was the wrong tool for it."""
    run_id = client.get("/new", headers=writer).json()["run_id"]
    intruder = auth("intruder", ["write"])

    response = client.post(
        f"/upload?run_id={run_id}", headers=intruder, json=heartbeats("Estresado")
    )
    assert response.status_code == 403


def test_reader_cannot_upload(client, reader, run_with_data):
    response = client.post(
        f"/upload?run_id={run_with_data}", headers=reader, json=heartbeats("Estresado")
    )
    assert response.status_code == 401


def test_out_of_range_bpm_is_rejected(client, writer):
    run_id = client.get("/new", headers=writer).json()["run_id"]
    payload = heartbeats("Estresado")
    payload[0]["bpm"] = 500
    assert client.post(f"/upload?run_id={run_id}", headers=writer, json=payload).status_code == 422


def test_unknown_state_is_rejected(client, writer):
    run_id = client.get("/new", headers=writer).json()["run_id"]
    payload = heartbeats("Estresado")
    payload[0]["state"] = "Eufórico"
    assert client.post(f"/upload?run_id={run_id}", headers=writer, json=payload).status_code == 422


def test_heartbeats_come_back_ordered_by_seq(client, reader, run_with_data):
    body = client.get(f"/runs/heartbeats?run_id={run_with_data}", headers=reader).json()
    assert body["run_id"] == run_with_data
    assert [hb["seq"] for hb in body["items"]] == [0, 1, 2]
    assert body["items"][0]["state"] == "Estresado"


def test_current_resolves_to_the_latest_run(client, reader, run_with_data):
    body = client.get("/runs/heartbeats", headers=reader).json()
    assert body["run_id"] == run_with_data


def test_empty_run_returns_an_empty_batch_not_an_error(client, reader, writer):
    """A reserved-but-unused run is a valid, empty result -- not a 500."""
    run_id = client.get("/new", headers=writer).json()["run_id"]
    response = client.get(f"/runs/heartbeats?run_id={run_id}", headers=reader)
    assert response.status_code == 200
    assert response.json()["items"] == []


def test_pagination(client, reader, run_with_data):
    page = client.get(
        f"/runs/heartbeats?run_id={run_with_data}&limit=2&offset=1", headers=reader
    ).json()
    assert [hb["seq"] for hb in page["items"]] == [1, 2]

    past_the_end = client.get(
        f"/runs/heartbeats?run_id={run_with_data}&offset=100", headers=reader
    )
    assert past_the_end.status_code == 200
    assert past_the_end.json()["items"] == []


def test_run_id_zero_is_rejected(client, reader):
    """Runs are AUTOINCREMENT and start at 1."""
    assert client.get("/runs/heartbeats?run_id=0", headers=reader).status_code == 422
