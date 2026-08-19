# /// script
# requires-python = ">=3.11"
# dependencies = [
#     "fastapi[standard]>=0.141.1",
# ]
# ///
import sqlite3
from typing import Annotated
from contextlib import asynccontextmanager
from fastapi import Depends, FastAPI, HTTPException, Query, status, Security
from fastapi.security import OAuth2PasswordRequestForm

# Local imports
from api_classes import Heartbeat, AvailableScopes
from db_functions import *
from security import (
    Token, 
    User,        
    get_current_active_user,
    get_current_user,
    get_token,
    AvailableScopes
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    conn = sqlite3.connect(DEFAULT_DB)
    init_schema(conn)
    conn.execute("PRAGMA journal_mode=WAL")
    conn.close()
    yield

app = FastAPI(lifespan=lifespan)


@app.post("/token")
async def login_for_access_token(
    form_data: Annotated[OAuth2PasswordRequestForm, Depends()],
) -> Token:
    return get_token(form_data)


@app.get("/user/me/")
async def read_users_me(
    current_user: Annotated[User, Depends(get_current_active_user)],
) -> User:
    return current_user

@app.get("/user/scopes/")
async def user(
    current_user: Annotated[User, Depends(get_current_active_user)],
):    
    return [{"username": current_user.username, "scopes": current_user.username}]


@app.post("/user/create")
async def api_user_create(
    new_user: UserRequest,
    current_user: Annotated[User, Security(get_current_active_user, scopes=[AvailableScopes.admin.name])]
):    
    gen = get_conn()
    conn = next(gen)
    try:
        new_user.password = password_hash.hash(new_user.password)
        create_new_user(conn, new_user)
    except sqlite3.IntegrityError as ex:
        raise HTTPException(status_code=400, detail="The new user already exists")
    finally:
        gen.close()


    return {"created": "ok"}


# Health Check
@app.get("/status/")
async def read_system_status(current_user: Annotated[User, Depends(get_current_user)]):
    return {"status": "ok"}


# Hearbeat Upload
@app.post("/upload")
def upload(run_id:int, hb_items: list[Heartbeat], user: Annotated[User, Depends(get_current_active_user)]):
    # TODO: verify the user has permission to upload
    gen = get_conn()
    _conn: sqlite3.Connection = next(gen)
    with _conn:
        n = insert_heartbeats(_conn, run_id, hb_items) 
    
    gen.close()
    if n < 0:        
        raise HTTPException (status_code=500, detail="Unable to upload data")
    
    return {"inserted" : n}

# New Run
@app.get("/new")
def new_run(current_user: Annotated[User, 
                Security(get_current_active_user,scopes=[AvailableScopes.write.name])]):
    """
        Get an ID for a new run. This is calculated by getting the highest current 
        RUN_ID and adding one to it.
    """
    gen = get_conn()
    conn = next(gen)
    
    try:
        with conn:
            id = get_current_run_id(conn)
    finally:
        gen.close()       
    gen.close()    
    
    return {"run_id" : id+1}

# Query runs: for statistics
@app.get("/runs/{run_id}/heartbeats")
def heartbeats(run_id: int,
               current_user: Annotated[User, Security(get_current_active_user, scopes=[AvailableScopes.read.name])],
               limit: Annotated[int, Query(ge=1, le=500)] = 500,
               offset: Annotated[int, Query(ge=0)] = 0):
    # TODO: the function
    """
    Purpose: Get rows from the database of run_id 
    Steps:
        1 - Check if user has the required permissions
        2 - Get conn and call the db function
        3 - Return a dict with the results
            3.1 - Handle errors and return Corrent HTTP responses 
                    Possible errors: empty list or offset out of bounds
                    
    """
    gen = get_conn()
    conn = next(gen)
        
    try:
        with conn:
            batch: HeartbeatBatch = get_heartbeats(conn, run_id, limit, offset)
    finally:
        gen.close()
        
    return dict(batch)

@app.get("/runs/heartbeats")
def current_heartbeats(current_user: Annotated[User, Security(get_current_active_user,
                                                              scopes=[AvailableScopes.read.name])],
               limit: Annotated[int, Query(ge=1, le=500)] = 500,
               offset: Annotated[int, Query(ge=0)] = 0):
    """
    Purpose: Get rows from the database of current run 
    Steps:
        1. - Check if User has required permissions
        2. - Obtain current run_id
        3. - Either call heartbeats function above or implement same functionality
    """    
    raise NotImplemented()

