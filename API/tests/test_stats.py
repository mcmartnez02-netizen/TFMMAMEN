"""Statistics endpoints -- the aggregates the exhibition app displays."""

from api_classes import HB_State
from conftest import heartbeats
from pytest import approx


def test_summary_aggregates_bpm(client, reader, run_with_data):
    """run_with_data holds bpm 80, 81, 82."""
    body = client.get(f"/stats/summary?run_id={run_with_data}", headers=reader).json()
    assert body == {"total": 3, "avg_bpm": 81.0, "min_bpm": 80, "max_bpm": 82}


def test_summary_of_an_empty_run_is_all_zeros(client, reader, writer):
    run_id = client.get("/new", headers=writer).json()["run_id"]
    body = client.get(f"/stats/summary?run_id={run_id}", headers=reader).json()
    assert body["total"] == 0


def test_by_state_counts_and_percentages(client, reader, run_with_data):
    body = client.get(
        f"/stats/summary/states?run_id={run_with_data}", headers=reader
    ).json()
    by_state = {s["state"]: s for s in body["state_stats"]}

    assert by_state["Relajado"]["total"] == 2
    assert by_state["Estresado"]["total"] == 1
    assert by_state["Relajado"]["percentage"] == approx(200 / 3)
    assert by_state["Estresado"]["percentage"] == approx(100 / 3)


def test_percentages_sum_to_one_hundred(client, reader, run_with_data):
    body = client.get(
        f"/stats/summary/states?run_id={run_with_data}", headers=reader
    ).json()
    total = sum(s["percentage"] for s in body["state_stats"])
    assert total == approx(100.0)


def test_every_state_is_reported_even_with_no_beats(client, reader, run_with_data):
    """A client drawing four bars must always receive four entries."""
    body = client.get(
        f"/stats/summary/states?run_id={run_with_data}", headers=reader
    ).json()
    reported = {s["state"] for s in body["state_stats"]}
    assert reported == {state.value for state in HB_State}

    unseen = next(s for s in body["state_stats"] if s["state"] == "Latente")
    assert unseen["total"] == 0
    assert unseen["percentage"] == 0.0


def test_state_totals_match_the_overall_total(client, reader, writer):
    run_id = client.get("/new", headers=writer).json()["run_id"]
    client.post(
        f"/upload?run_id={run_id}",
        headers=writer,
        json=heartbeats("Latente", "Latente", "Sensible", "Relajado"),
    )

    body = client.get(f"/stats/summary/states?run_id={run_id}", headers=reader).json()
    assert sum(s["total"] for s in body["state_stats"]) == body["total"] == 4


def test_stats_require_the_read_scope(client, writer, run_with_data):
    response = client.get(f"/stats/summary?run_id={run_with_data}", headers=writer)
    assert response.status_code == 401
