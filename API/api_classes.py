"""
Classes used by the API
"""
from datetime import datetime
from enum import Enum
from pydantic import BaseModel, Field, field_validator


class AvailableScopes(Enum):
    admin = "Allows user to create new users and to give and take scopes from other users"
    read = "Allows user to read data from the database"
    write = "Allows user to upload data to the database"
    
class HB_State (Enum):
    ESTRESADO = "Estresado"
    SENSIBLE =  "Sensible"
    RELAJADO =  "Relajado"
    LATENTE =   "Latente"
    
class Heartbeat(BaseModel):
    device_timestamp: datetime
    bpm: int = Field(ge=20, le=250)
    state: HB_State
    seq: int

    @field_validator('state', mode='before')
    @classmethod
    def convert_state(cls, v):
        if isinstance(v, str):
            return HB_State(v)
        return v
    
    def __iter__(self):
        yield from [(k, v) if not type(v) is HB_State else (k, v.name) for (k, v) in self.__dict__.items() if not k.startswith('_')]        
        extra = self.__pydantic_extra__
        if extra:
            yield from extra.items()
           

class HeartbeatBatch(BaseModel):
    run_id: int
    items: list[Heartbeat] = Field(min_length=1, max_length=500)
    

class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str | None = None
    scopes: list[str] = []

class User(BaseModel):
    username: str
    disabled: bool = False
    allowed_scopes : list[AvailableScopes] = []

    @field_validator('allowed_scopes', mode='before')
    @classmethod
    def convert_scopes(cls, v):
        if isinstance(v, list):
            return [AvailableScopes[item] if isinstance(item, str) else item for item in v]
        return v

class UserRequest(User):
    password: str

class UserInDB(User):
    hashed_password: str

class StatsSummary(BaseModel):
    total : int = Field(ge=0)
    avg_bpm : float = Field(ge=0.0, le=250)
    min_bpm : int = Field(ge=0, le=250)
    max_bpm : int = Field(ge=0, le=250)
 
class StatsState(StatsSummary):
    state : HB_State
    percentaje : float = Field(ge=0.0, le=100.0)
       
class StatsSummaryState(StatsSummary):
    state_stats: list[StatsState]
    
    
    
    
