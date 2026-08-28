import sqlite3
from pathlib import Path

# Local imports
from api_classes import (
    AvailableScopes,
    HB_State,
    Heartbeat,
    HeartbeatBatch,
    StatsState,
    StatsSummary,
    StatsSummaryState,
    User,
    UserInDB,
)
from pydantic import SecretStr
from settings import settings

DEFAULT_DB = Path(__file__).parent / "database" / "default.db"

###########################################
###              CONNECTIONS            ###
###########################################


def get_conn():
    conn = sqlite3.connect(
        DEFAULT_DB,
        check_same_thread=False,
        detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES,
    )
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA busy_timeout=5000")
    conn.execute("PRAGMA foreign_keys=ON")
    try:
        yield conn
    finally:
        conn.close()


def init_schema(conn: sqlite3.Connection):
    _STATE_NAMES = ", ".join(f"'{s.name}'" for s in HB_State)
    _SCOPE_NAMES = ", ".join(f"'{s.name}'" for s in AvailableScopes)

    with conn:
        conn.execute("""CREATE TABLE IF NOT EXISTS users (
                username        TEXT PRIMARY KEY,
                hashed_password TEXT NOT NULL,
                disabled        INTEGER NOT NULL DEFAULT 0 CHECK (disabled IN (0, 1))
            )
        """)
        conn.execute(f"""CREATE TABLE IF NOT EXISTS user_scopes (
                username TEXT NOT NULL REFERENCES users(username) ON DELETE CASCADE,
                scope    TEXT NOT NULL CHECK (scope IN ({_SCOPE_NAMES})),
                
                PRIMARY KEY (username, scope)
            )
        """)
        conn.execute("""CREATE TABLE IF NOT EXISTS runs (
                run_id  INTEGER PRIMARY KEY AUTOINCREMENT,
                username TEXT NOT NULL REFERENCES users(username) ON DELETE CASCADE
            );
        """)
        conn.execute(f"""CREATE TABLE IF NOT EXISTS heartbeats (
                run_id INT NOT NULL REFERENCES runs(run_id) ON DELETE CASCADE,
                seq INT NOT NULL,
                bpm INT NOT NULL,
                state TEXT NOT NULL CHECK (state IN ({_STATE_NAMES})),
                device_timestamp TIMESTAMP,        
                
                PRIMARY KEY (run_id, seq)
            )
        """)


def admin_seed(conn: sqlite3.Connection) -> bool:

    row_count = conn.execute(
        """
            SELECT COUNT(*)
            FROM users 
            WHERE username = :username
        """,
        {"username": "admin"},
    ).fetchone()[0]

    if row_count > 0:
        return False

    admin_user = User(
        username="admin",
        disabled=False,
        allowed_scopes=list(AvailableScopes),
    )

    create_new_user(conn, admin_user, settings.db.admin_password_hash)

    return True


###########################################
###                 USERS               ###
###########################################


def create_new_user(conn: sqlite3.Connection, user: User, hashed_password: SecretStr):
    with conn:
        user_dict = dict(user)
        user_dict["password"] = hashed_password.get_secret_value()
        conn.execute(
            """
                INSERT INTO users (username, hashed_password, disabled)
                VALUES (:username, :password, :disabled)
            """,
            user_dict,
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


def get_user(conn: sqlite3.Connection, username: str) -> User | None:
    u = get_user_db(conn, username)    
    return User(**u.model_dump(exclude={"hashed_password"})) if u is not None else None


def get_user_db(conn: sqlite3.Connection, username: str) -> UserInDB | None:
    request_dict = {"username": username}
    row = conn.execute(
        """
            SELECT username, hashed_password, disabled
            FROM users
            WHERE username = :username            
        """,
        request_dict,
    ).fetchone()

    if row is None:
        return None

    scopes = conn.execute(
        """
            SELECT scope
            FROM user_scopes
            WHERE username = :username
        """,
        request_dict,
    ).fetchall()

    user = UserInDB(
        username=row[0],
        hashed_password=row[1],
        disabled=row[2],
        allowed_scopes=[x[0] for x in scopes],
    )

    return user


###########################################
###             HEARTBEATS              ###
###########################################


def insert_heartbeats(
    conn: sqlite3.Connection, current_user: User, run_id: int, items: list[Heartbeat]
) -> list[int]:
    owner = get_run_owner(conn, run_id)
    if owner is None:
        raise LookupError("Run id was not registered yet")

    if owner != current_user.username:
        raise PermissionError("User is not the owner of the uploaded run")

    entries = [{**dict(hb), "run_id": run_id} for hb in items]
    seq_numbers = [e["seq"] for e in entries]

    with conn:
        conn.executemany(
            """
                    INSERT OR IGNORE INTO heartbeats (run_id, seq, bpm, state, device_timestamp)
                    VALUES (:run_id, :seq, :bpm, :state, :device_timestamp)
                """,
            entries,
        )

        inserted_rows = conn.execute(
            """
                SELECT seq FROM heartbeats
                WHERE run_id = :run_id AND seq IN ({})
            """.format(",".join("?" * len(seq_numbers))),
            [run_id] + seq_numbers,
        ).fetchall()

    inserted_seqs = [row[0] for row in inserted_rows]

    return inserted_seqs


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
        Heartbeat(
            device_timestamp=row[0], bpm=row[1], state=HB_State[row[2]], seq=row[3]
        )
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


###########################################
###                 RUNS                ###
###########################################


def get_current_run_id(conn: sqlite3.Connection) -> int:
    """Gets the greatets run_id reserved

    Args:
        conn (sqlite3.Connection): connector to the database

    Returns:
        int: run_id reserved
    """
    cursor = conn.execute(
        """
            SELECT COALESCE(MAX(run_id),0) 
            FROM runs;
        """
    )
    return cursor.fetchone()[0]


def create_new_run(conn: sqlite3.Connection, user: User) -> int:

    with conn:
        cursor = conn.execute(
            """
                INSERT INTO runs (username)
                VALUES (:username)
            """,
            {"username": user.username},
        )

    return int(cursor.lastrowid)


def get_run_owner(conn: sqlite3.Connection, run_id: int) -> str | None:
    row = conn.execute(
        """
            SELECT username 
            FROM runs
            WHERE run_id = :run_id
        """,
        {"run_id": run_id},
    ).fetchone()

    if row is None:
        return None

    return str(row[0])


###########################################
###                 STATS               ###
###########################################


def stats_summary(conn: sqlite3.Connection, run_id: int):
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
    state_stats: list[StatsState] = []
    for r in rows:
        state_stats.append(
            StatsState(
                state=HB_State[r[0]],
                total=int(r[1]) if r[1] is not None else 0,
                percentage=float(r[2]) if r[2] is not None else 0.0,
                avg_bpm=float(r[3]) if r[3] is not None else 0.0,
                min_bpm=int(r[4]) if r[4] is not None else 0,
                max_bpm=int(r[5]) if r[5] is not None else 0,
            )
        )

    seen = {stats.state for stats in state_stats}
    state_stats += [StatsState(state=s) for s in HB_State if s not in seen]

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
    admin_seed(conn)

    rows = conn.execute("""
                        SELECT * 
                        FROM users
                        """).fetchall()
    print(rows)
    print(stats_by_state(conn, 0))

    print("users:")
    for r in rows:
        print(r)

    conn.close()


if __name__ == "__main__":
    main_test()
