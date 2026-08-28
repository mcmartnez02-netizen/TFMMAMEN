# Original from @tiangolo
# Source: https://fastapi.tiangolo.com/advanced/security/oauth2-scopes/#declare-scopes-in-path-operations-and-dependencies

import sqlite3
from datetime import datetime, timedelta, timezone
from typing import Annotated

import jwt
from api_classes import AvailableScopes, Token, TokenData, User, UserInDB
from db_functions import get_conn, get_user, get_user_db
from fastapi import Depends, HTTPException, status
from fastapi.security import (
    OAuth2PasswordBearer,
    OAuth2PasswordRequestForm,
    SecurityScopes,
)
from jwt.exceptions import InvalidTokenError
from pwdlib import PasswordHash
from pydantic import SecretStr, ValidationError
from settings import settings

# to get a string like this run:
# openssl rand -hex 32
SECRET_KEY = settings.app.secretkey.get_secret_value()
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


password_hash = PasswordHash.recommended()

DUMMY_HASH = SecretStr(password_hash.hash("dummypassword"))

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="token",
    scopes={ x.name:x.value for x  in AvailableScopes  },
)

# Security
def get_token(form_data:OAuth2PasswordRequestForm):
    # Authenticate user
    user = authenticate_user(form_data.username, form_data.password)
    if not user:
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    
    if user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    
    # Check the scopes are allowed
    allowed_scopes = {s.name for s  in user.allowed_scopes}
    invalid_scopes =  set(form_data.scopes) - allowed_scopes
    if invalid_scopes:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"User not allowed the following requested scopes {', '.join(sorted(invalid_scopes))}"
        )
    
    # Create token        
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.username, "scope": " ".join(form_data.scopes)},
        expires_delta=access_token_expires,
    )
    return Token(access_token=access_token, token_type="bearer")


def verify_password(plain_password:str, hashed_password: SecretStr ):
    return password_hash.verify(plain_password, hashed_password.get_secret_value())


def get_password_hash(password:str):
    return SecretStr(password_hash.hash(password))


def authenticate_user(username: str, password: str) ->  UserInDB | None:
    gen = get_conn()
    conn = next(gen)
    
    try:
        user = get_user_db(conn, username)
    finally:
        gen.close()
        
    if user is None:
        verify_password(password, DUMMY_HASH)
        return None
    
    if not verify_password(password, user.hashed_password):
        return None    
    
    return user


def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(
    security_scopes: SecurityScopes, 
    token: Annotated[str, Depends(oauth2_scheme)],
    conn : Annotated[sqlite3.Connection, Depends(get_conn)]
):
    if security_scopes.scopes:
        authenticate_value = f'Bearer scope="{security_scopes.scope_str}"'
    else:
        authenticate_value = "Bearer"
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": authenticate_value},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username = payload.get("sub")
        if username is None:
            raise credentials_exception
        scope: str = payload.get("scope", "")
        token_scopes = scope.split(" ") if scope else []
        token_data = TokenData(scopes=token_scopes, username=username)
    except (InvalidTokenError, ValidationError):
        raise credentials_exception
    
    user = get_user(conn, token_data.username)
    
    if user is None:
        raise credentials_exception
    for scope in security_scopes.scopes:
        if scope not in token_data.scopes:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Not enough permissions",
                headers={"WWW-Authenticate": authenticate_value},
            )
    return user


async def get_current_active_user(
    current_user: Annotated[User, Depends(get_current_user)],
):
    if current_user.disabled:
        raise HTTPException(status_code=400, detail="Inactive user")
    return current_user

if __name__ == "__main__":
    password = input("Please enter password to hash:")
    print("You hash is :")
    print(password_hash.hash(password))