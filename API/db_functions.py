import sqlite3
from datetime import datetime
from pathlib import Path
from enum import Enum
from contextlib import contextmanager

# Local imports
from api_classes import Heartbeat, HeartbeatBatch, HB_State, AvailableScopes, UserRequest

DEFAULT_DB = Path(__file__).parent / "database" / "default.db"



### Connetions

def get_conn():
    conn = sqlite3.connect(DEFAULT_DB,
                           detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA busy_timeout=5000")
    try:
        yield conn
    finally:
        conn.close()

def init_schema(conn: sqlite3.Connection):
    cursor = conn.cursor()    
    cursor.execute("""CREATE TABLE IF NOT EXISTS heartbeats (
            run_id INT NOT NULL,
            seq INT NOT NULL,
            bpm INT NOT NULL,
            state CHAR(9),
            device_timestamp TIMESTAMP,        
            
            PRIMARY KEY (run_id, seq)
        )
    """)    
    conn.commit()
            
    _SCOPE_NAMES = ", ".join(f"'{s.name}'" for s in AvailableScopes)

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
    
def create_new_user(conn:sqlite3.Connection, user : UserRequest):
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO users (username, hashed_password, disabled)
        VALUES (:username, :password, :disabled)
        '''
        , dict(user)
    )
    conn.commit()
    print("user:", user.username)
    scopes = [ {"username" :user.username, "scope" :s.name} for s in user.allowed_scopes]
    
    cursor.executemany(
        '''
        INSERT INTO user_scopes (username, scope)
        VALUES (:username, :scope)
        '''
        ,scopes        
    )
    print("scopes:",scopes)
    conn.commit()
    
###########################################
### HEATBEATS ###
###########################################

def insert_heartbeats(conn:sqlite3.Connection, run_id: int, items: list[Heartbeat]) -> int:
    entries = [{**dict(hb), "run_id": run_id} for hb in items]
    
    try:
        cursor = conn.cursor()
        cursor.executemany('''
                    INSERT OR IGNORE INTO heartbeats (run_id, seq, bpm, state, device_timestamp)
                    VALUES (:run_id, :seq, :bpm, :state, :device_timestamp)
                '''
                ,entries
            )
        inserted = cursor.rowcount
        conn.commit()
    except Exception as ex:
        conn.rollback()
        print(f"Insert failes: {ex.message}")
        return -1

    return inserted

def get_heartbeats_current(conn:sqlite3.Connection, limit:int = 500, offset:int = 0) -> HeartbeatBatch:
    # TODO: just need to know which is the current run and return the heartbeats for it 
    raise NotImplemented("Not implemented yet")
    
def get_heartbeats(conn:sqlite3.Connection, run_id:int, limit:int = 500, offset:int = 0) -> HeartbeatBatch:
    # TODO: the funct    
    rows = conn.execute("""
        SELECT seq, bpm, state, device_timestamp
        FROM heartbeats
        WHERE run_id = :run_id
        ORDER BY seq
        LIMIT :limit OFFSET :offset
        """, {"run_id": run_id, "limit": limit, "offset": offset}).fetchall()
    return HeartbeatBatch(run_id= run_id, items=[Heartbeat(**dict(row)) for row in rows])

def count_hearbeats(conn:sqlite3.Connection, run_id:int) -> int:
    # TODO: the funct
    raise NotImplemented("Not implemented yet")

def get_current_run_id(conn:sqlite3.Connection) -> int:
    """Gets the greates run_id a entry a heartbeat has in the database.

    Args:
        conn (sqlite3.Connection): connector to the database

    Returns:
        int: biggest run_id in heartbeats table
    """    
    cursor = conn.execute('''
            SELECT COALESCE(MAX(run_id),0) FROM heartbeats;
        '''
    )        
    return cursor.fetchone()[0]


###########################################
### STATS ###
###########################################

def stats_summary(conn: sqlite3.Connection, run_id:int ):
    # TODO: the funct
    raise NotImplemented("Not implemented yet")

def stats_by_state(conn: sqlite3.Connection, run_id:int ):
    # TODO: the funct
    raise NotImplemented("Not implemented yet")

from security import password_hash
def main ():
    """For testing purposes"""
    
    conn = sqlite3.connect(DEFAULT_DB, 
        detect_types=sqlite3.PARSE_DECLTYPES | sqlite3.PARSE_COLNAMES)
    
    init_schema(conn)
    
    a = get_current_run_id(conn)
    print(a)
    
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users")
    
    print("Users:")
    for x in cursor.fetchall():
        print(x)
        
    conn.commit()

    print("Scopes")
    cursor.execute("SELECT * FROM user_scopes")
    for x in cursor.fetchall():
        print(x)
    
    
    conn.commit()

    
    conn.close()

if __name__ == "__main__":
    main()