# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "fastapi[standard]>=0.141.1",
# ]
# ///
import sqlite3
from contextlib import asynccontextmanager
from typing import Annotated, Literal

import db_functions as db  # Local import
from api_classes import (  # Local import
    AvailableScopes,
    Heartbeat,
    HeartbeatBatch,
    StatsSummary,
    StatsSummaryState,
)
from fastapi import Depends, FastAPI, HTTPException, Query, Security
from fastapi.security import OAuth2PasswordRequestForm
from security import (
    Token,
    User,
    get_current_active_user,
    get_current_user,
    get_token,
    password_hash,
)  # Local import


@asynccontextmanager
async def lifespan(app: FastAPI):
    conn = sqlite3.connect(db.DEFAULT_DB)
    db.init_schema(conn)
    conn.execute("PRAGMA journal_mode=WAL")
    conn.close()
    yield


app = FastAPI(lifespan=lifespan)

###########################################
###            AUTENTICATION            ###
###########################################


@app.post("/token")
def login_for_access_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
) -> Token:
    return get_token(form_data)


###########################################
###               USERS                 ###
###########################################


@app.get("/user/me/")
async def read_users_me(
    current_user: Annotated[User, Depends(get_current_active_user)],
) -> User:
    return current_user


@app.get("/user/scopes/")
async def user(
    current_user: Annotated[User, Depends(get_current_active_user)],
):
    return [
        {
            "username": current_user.username,
            "scopes": [scope.name for scope in current_user.allowed_scopes],
        }
    ]


@app.post("/user/create")
def api_user_create(
    new_user: db.UserRequest,
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.admin.name])
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
) -> dict[str, str]:
    new_user.password = password_hash.hash(new_user.password)
    db.create_new_user(conn, new_user)

    return {"created": "ok"}


# Health Check
@app.get("/status/")
async def read_system_status(current_user: Annotated[User, Depends(get_current_user)]):
    return {"status": "ok"}


###########################################
###               UPLOAD                ###
###########################################


# Hearbeat Upload
@app.post("/upload")
def upload(
    run_id: Annotated[int, Query(ge=0)],
    hb_items: list[Heartbeat],
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.write.name])
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
):

    n = db.insert_heartbeats(conn, run_id, hb_items)
    if n < len(hb_items):
        raise HTTPException(
            status_code=409,
            detail=f"Of the {len(hb_items)} uploaded only {n} where uploaded",
        )

    return {"inserted": n}


###########################################
###               RUNS                  ###
###########################################
# New Run
@app.get("/new")
def new_run(
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.write.name])
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
) -> dict[str, int]:
    """Get an ID for a new run. This is calculated by getting the highest current
        RUN_ID and adding one to it.

    Args:
        current_user User: User of the required token. The user requires write privileges.

    Returns:
        dict[str, int]: a JSON with the id
    """
    id = db.get_current_run_id(conn)
    return {"run_id": id + 1}


###########################################
###           READ HEARTBEATS           ###
###########################################
# Query runs: for statistics
@app.get("/runs/heartbeats")
def heartbeats(
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.read.name])
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
    run_id: Annotated[int, Query(ge=0)] | Literal["current"] = "current",
    limit: Annotated[int, Query(ge=1, le=500)] = 500,
    offset: Annotated[int, Query(ge=0)] = 0,
) -> HeartbeatBatch:
    
    if run_id == "current":
        run_id = db.get_current_run_id(conn)
        
    batch: db.HeartbeatBatch = db.get_heartbeats(conn, run_id, limit, offset)
    return batch


@app.get("/runs/{run_id}/heartbeats/count")
def heartbeats_count(
    run_id: int,
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.read.name])
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
) -> dict[str, int]:

    n_entries = db.count_hearbeats(conn, run_id)
    return {"id": run_id, "entries": n_entries}


###########################################
###                STATS                ###
###########################################


@app.get("/stats/summary")
def stat_summary(
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.read.name])
    ],
    run_id: Annotated[int, Query(ge=0)],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
) -> StatsSummary:

    summary = db.stats_summary(conn, run_id)

    return summary


@app.get("/stats/summary/states")
def stats_states(
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.read.name])
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
    run_id: Annotated[int, Query(ge=0)],
) -> StatsSummaryState:

    summary = db.stats_by_state(conn, run_id)

    return summary
