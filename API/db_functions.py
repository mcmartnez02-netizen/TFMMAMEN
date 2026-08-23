import sqlite3
from pathlib import Path

# Local imports
from api_classes import (
    AvailableScopes,
    HB_State,
    Heartbeat,
    HeartbeatBatch,
    UserRequest,
    StatsSummary,
    StatsSummaryState,
    StatsState,
)
from security import password_hash

DEFAULT_DB = Path(__file__).parent / "database" / "default.db"

###########################################
### Connections ###
###########################################


def get_conn():
    conn = sqlite3.connect(
        DEFAULT_DB, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES
    )
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA busy_timeout=5000")
    try:
        yield conn
    finally:
        conn.close()


def init_schema(conn: sqlite3.Connection):
    _STATE_NAMES = ", ".join(f"'{s.name}'" for s in HB_State)
    _SCOPE_NAMES = ", ".join(f"'{s.name}'" for s in AvailableScopes)
    cursor = conn.cursor()
    cursor.execute(f"""CREATE TABLE IF NOT EXISTS heartbeats (
            run_id INT NOT NULL,
            seq INT NOT NULL,
            bpm INT NOT NULL,
            state TEXT NOT NULL CHECK (state IN ({_STATE_NAMES})),
            device_timestamp TIMESTAMP,        
            
            PRIMARY KEY (run_id, seq)
        )
    """)
    conn.commit()

    cursor.execute("""CREATE TABLE IF NOT EXISTS users (
            username        TEXT PRIMARY KEY,
            hashed_password TEXT NOT NULL,
            disabled        INTEGER NOT NULL DEFAULT 0 CHECK (disabled IN (0, 1))
        )
    """)
    conn.commit()
    cursor.execute(f"""CREATE TABLE IF NOT EXISTS user_scopes (
            username TEXT NOT NULL REFERENCES users(username) ON DELETE CASCADE,
            scope    TEXT NOT NULL CHECK (scope IN ({_SCOPE_NAMES})),
            
            PRIMARY KEY (username, scope)
        )
    """)
    conn.commit()


###########################################
### USERS ###
###########################################


def create_new_user(conn: sqlite3.Connection, user: UserRequest):
    with conn:
        conn.execute(
            """
            INSERT INTO users (username, hashed_password, disabled)
            VALUES (:username, :password, :disabled)
            """,
            dict(user),
        )
        scopes = [
            {"username": user.username, "scope": s.name} for s in user.allowed_scopes
        ]

        conn.executemany(
            """
            INSERT INTO user_scopes (username, scope)
            VALUES (:username, :scope)
            """,
            scopes,
        )


###########################################
### HEATBEATS ###
###########################################


def insert_heartbeats(
    conn: sqlite3.Connection, run_id: int, items: list[Heartbeat]
) -> int:
    entries = [{**dict(hb), "run_id": run_id} for hb in items]
    with conn:
        cursor = conn.executemany(
            """
                    INSERT OR IGNORE INTO heartbeats (run_id, seq, bpm, state, device_timestamp)
                    VALUES (:run_id, :seq, :bpm, :state, :device_timestamp)
                """,
            entries,
        )
        inserted = cursor.rowcount

    return inserted


def get_heartbeats_current(
    conn: sqlite3.Connection, limit: int = 500, offset: int = 0
) -> HeartbeatBatch:
    # TODO: just need to know which is the current run and return the heartbeats for it
    raise NotImplementedError("Not implemented yet")


def get_heartbeats(
    conn: sqlite3.Connection, run_id: int, limit: int = 500, offset: int = 0
) -> HeartbeatBatch:
    rows = conn.execute(
        """
            SELECT device_timestamp, bpm, state, seq
            FROM heartbeats
            WHERE run_id = :run_id
            ORDER BY seq
            LIMIT :limit OFFSET :offset
        """,
        {"run_id": run_id, "limit": limit, "offset": offset},
    ).fetchall()
    items = [
        Heartbeat(device_timestamp=row[0], bpm=row[1], state=row[2], seq=row[3])
        for row in rows
    ]
    return HeartbeatBatch(run_id=run_id, items=items)


def count_hearbeats(conn: sqlite3.Connection, run_id: int) -> int:
    cursor = conn.execute(
        """
            SELECT COUNT(*)
            FROM heartbeats
            WHERE run_id = :run_id
        """,
        {"run_id": run_id},
    )
    return int(cursor.fetchone()[0])


def get_current_run_id(conn: sqlite3.Connection) -> int:
    """Gets the greates run_id a entry a heartbeat has in the database.

    Args:
        conn (sqlite3.Connection): connector to the database

    Returns:
        int: biggest run_id in heartbeats table
    """
    cursor = conn.execute(
        """
            SELECT COALESCE(MAX(run_id),0) 
            FROM heartbeats;
        """)
    return cursor.fetchone()[0]


###########################################
### STATS ###
###########################################


def stats_summary(conn: sqlite3.Connection, run_id: int):
    with conn:
        row = conn.execute(
            """
                SELECT COUNT (*) AS total,
                    AVG(bpm) AS avg_bpm,
                    MIN(bpm) AS min_bpm,
                    MAX(bpm) AS max_bpm
                FROM heartbeats 
                WHERE run_id = :run_id
            """,
            {"run_id": run_id},
        ).fetchone()
    return StatsSummary(
        total=int(row[0]),
        avg_bpm=float(row[1]) if row[1] is not None else 0.0,
        min_bpm=int(row[2]) if row[2] is not None else 0,
        max_bpm=int(row[3]) if row[3] is not None else 0,
    )


def stats_by_state(conn: sqlite3.Connection, run_id: int):
    general = stats_summary(conn, run_id)
    with conn:
        rows = conn.execute(
            """
            SELECT state,
                COUNT(*) AS count,
                100.0 * COUNT(*) / SUM(COUNT(*)) OVER () AS pct,
                AVG(bpm) AS avg_bpm,
                MIN(bpm) AS min_bpm,
                MAX(bpm) AS max_bpm
            FROM heartbeats
            WHERE run_id = :run_id
            GROUP BY state
            ORDER BY count DESC
            """,
            {"run_id": run_id},
        )
        state_stats = []
        for r in rows:
            state = [
                HB_State(value)
                for name, value in vars(HB_State).items()
                if name == r[0]
            ]

            state_stats.append(
                StatsState(
                    state=state[0] if len(state) > 0 else None,
                    total= int(r[1]) if r[1] is not None else 0,
                    percentaje=float(r[2]) if r[2] is not None else 0.0,
                    avg_bpm=float(r[3]) if r[3] is not None else 0.0,
                    min_bpm=int(r[4]) if r[4] is not None else 0,
                    max_bpm=int(r[5]) if r[5] is not None else 0,
                )
            )
            # print(HB_State(r[0]))
            print(state, r)

        return StatsSummaryState(
            total=general.total,
            avg_bpm=general.avg_bpm,
            min_bpm=general.min_bpm,
            max_bpm=general.max_bpm,
            state_stats=state_stats,
        )


def main_test():
    """For testing purposes"""

    conn = sqlite3.connect(
        DEFAULT_DB, detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES
    )

    init_schema(conn)
    """
    import datetime
    with conn:        
        insert_heartbeats(conn,
                          0,
                          [Heartbeat(device_timestamp=datetime.datetime.now(tz=datetime.timezone.utc),
                                     bpm=100,
                                     state=HB_State.ESTRESADO,
                                     seq=0),
                            Heartbeat(device_timestamp=datetime.datetime.now(tz=datetime.timezone.utc),
                                     bpm=100,
                                     state=HB_State.LATENTE,
                                     seq=1),
                            Heartbeat(device_timestamp=datetime.datetime.now(tz=datetime.timezone.utc),
                                     bpm=100,
                                     state=HB_State.RELAJADO,
                                     seq=2),
                            Heartbeat(device_timestamp=datetime.datetime.now(tz=datetime.timezone.utc),
                                     bpm=100,
                                     state=HB_State.SENSIBLE,
                                     seq=3)])"""

    id = get_current_run_id(conn)
    print(id)

    a = stats_by_state(conn, id)
    print(dict(a))

    conn.commit()

    conn.close()


if __name__ == "__main__":
    main_test()
