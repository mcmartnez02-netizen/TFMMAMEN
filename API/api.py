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
    Token,
    User,
    UserRequest,
)
from fastapi import Depends, FastAPI, HTTPException, Query, Security
from fastapi.security import OAuth2PasswordRequestForm
from security import (
    get_current_active_user,
    get_password_hash,
    get_token,
)  # Local import


@asynccontextmanager
async def lifespan(app: FastAPI):
    conn = sqlite3.connect(db.DEFAULT_DB)
    db.init_schema(conn)
    db.admin_seed(conn)
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
    new_user: UserRequest,
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.admin.name])
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
) -> dict[str, str]:
    try:
        db.create_new_user(
            conn, new_user, get_password_hash(new_user.password.get_secret_value())
        )
    except sqlite3.IntegrityError:
        raise HTTPException(
            status_code=409,
            detail=f"Username {new_user.username} is already in use. Pick another username.",
        )

    return {"created": "ok"}


# Health Check
@app.get("/status/")
async def read_system_status():
    return {"status": "ok"}


###########################################
###               UPLOAD                ###
###########################################


# Hearbeat Upload
@app.post("/upload")
def upload(
    run_id: Annotated[int, Query(ge=1)],
    hb_items: list[Heartbeat],
    current_user: Annotated[
        User, Security(get_current_active_user, scopes=[AvailableScopes.write.name])
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
):
    try:
        inserted = db.insert_heartbeats(conn, current_user, run_id, hb_items)
    except LookupError:
        raise HTTPException(
            status_code=404,
            detail=f"The run with id {run_id} was not reserved yet. \
            Please reserve your run id before any upload at /new",
        )
    except PermissionError:
        raise HTTPException(
            status_code=403,
            detail=f"The run with id {run_id} does not belong to the user \
                {current_user.username}. Use already reserved run_id by this \
                user or reserve a new run at /new",
        )

    return {"inserted": inserted, "received": len(hb_items)}


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
    
    id = db.create_new_run(conn, current_user)
    return {"run_id": id}


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
    run_id: Annotated[int, Query(ge=1)] | Literal["current"] = "current",
    limit: Annotated[int, Query(ge=1, le=500)] = 500,
    offset: Annotated[int, Query(ge=0)] = 0,
) -> HeartbeatBatch:

    if run_id == "current":
        run_id = db.get_current_run_id(conn)

    batch: db.HeartbeatBatch = db.get_heartbeats(conn, run_id, limit, offset)
    return batch


@app.get("/runs/heartbeats/count")
def heartbeats_count(
    current_user: Annotated[
        User, Depends(get_current_active_user)
    ],
    conn: Annotated[sqlite3.Connection, Depends(db.get_conn)],
    run_id: Annotated[int, Query(ge=1)] | Literal["current"] = "current",
) -> dict[str, int]:

    if run_id == "current":
        run_id = db.get_current_run_id(conn)

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
    run_id: Annotated[int, Query(ge=1)],
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
    run_id: Annotated[int, Query(ge=1)],
) -> StatsSummaryState:

    summary = db.stats_by_state(conn, run_id)

    return summary
