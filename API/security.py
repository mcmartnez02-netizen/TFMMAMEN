# Original from @tiangolo
# Source: https://fastapi.tiangolo.com/advanced/security/oauth2-scopes/#declare-scopes-in-path-operations-and-dependencies

from datetime import datetime, timedelta, timezone
from typing import Annotated
from fastapi import Depends, HTTPException, status, Security
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm,  SecurityScopes
from pydantic import BaseModel, ValidationError
import jwt
from jwt.exceptions import InvalidTokenError
from pwdlib import PasswordHash
from enum import Enum

# Local Imports
from api_classes import Token, TokenData, User, UserInDB, AvailableScopes


fake_users_db = {
    "johndoe": {
        "username": "johndoe",
        "hashed_password": "$argon2id$v=19$m=65536,t=3,p=4$wagCPXjifgvUFBzq4hqe3w$CYaIb8sB+wtD+Vu/P4uod1+Qof8h+1g7bbDlBID48Rc",
        "disabled": False,
        "allowed_scopes" : [AvailableScopes.admin, AvailableScopes.read, AvailableScopes.write]
    },
    "alice": {
        "username": "alice",
        "hashed_password": "$argon2id$v=19$m=65536,t=3,p=4$g2/AV1zwopqUntPKJavBFw$BwpRGDCyUHLvHICnwijyX8ROGoiUPwNKZ7915MeYfCE",
        "disabled": True,
        "allowed_scopes" : [AvailableScopes.read]
    },
}

# to get a string like this run:
# openssl rand -hex 32
SECRET_KEY = "09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30


password_hash = PasswordHash.recommended()

DUMMY_HASH = password_hash.hash("dummypassword")

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="token",
    scopes={ x.name:x.value for x  in AvailableScopes  },
)

# Security
def get_token(form_data:OAuth2PasswordRequestForm):
    # Authenticate user
    user = authenticate_user(fake_users_db, form_data.username, form_data.password)
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


def verify_password(plain_password, hashed_password):
    return password_hash.verify(plain_password, hashed_password)


def get_password_hash(password):
    return password_hash.hash(password)


def get_user(db, username: str):
    if username in db:
        user_dict = db[username]
        return UserInDB(**user_dict)


def authenticate_user(fake_db, username: str, password: str):
    user = get_user(fake_db, username)
    if not user:
        verify_password(password, DUMMY_HASH)
        return False
    
    if not verify_password(password, user.hashed_password):
        return False    
    
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
    security_scopes: SecurityScopes, token: Annotated[str, Depends(oauth2_scheme)]
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
    user = get_user(fake_users_db, username=token_data.username)
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