import base64
import datetime
import json
import logging
import os
import threading
import time
from dataclasses import dataclass
from pathlib import Path

# from pathlib import Path
from typing import Any

import dotenv
import requests
import tomllib
from readings import HR_State


@dataclass
class HeartBeat:
    device_timestamp: datetime
    bpm: int
    state: HR_State
    seq: int


logger = logging.getLogger()


class DataUploader:
    def __init__(self, config_path: Path = "pyproject.toml"):

        config: dict[str, Any] = self._load_config(config_path)

        self.api_url: str = config.get("url", None)
        if self.api_url is None:
            raise LookupError(
                "Value in toml configuration url in section [tool.app.api] was not found."
            )

        self.upload_rate: int = config.get("upload_rate", 30)
        self.timeout: int = config.get("timeout", 30)
        self.retry_attempts: int = config.get("retry_attempts", 3)

        endpoints_config: dict[str, Any] = config.get("endpoints", None)
        if endpoints_config is None:
            raise LookupError(
                "Section of toml configuration file not found [tool.app.api.endpoints]"
            )

        # Endpoints config
        self.status_endpoint: str = endpoints_config.get("status_endpoint", None)
        print(self.status_endpoint)
        if self.status_endpoint is None:
            raise LookupError(
                "Value in toml configuration status_endpoint in section [tool.app.api.endpoints] was not found."
            )

        self.token_endpoint: str = endpoints_config.get("token_endpoint", None)
        if self.token_endpoint is None:
            raise LookupError(
                "Value in toml configuration token_endpoint in section [tool.app.api.endpoints] was not found."
            )

        self.upload_endpoint: str = endpoints_config.get("upload_endpoint", None)
        if self.upload_endpoint is None:
            raise LookupError(
                "Value in toml configuration upload_endpoint in section [tool.app.api.endpoints] was not found."
            )

        self.count_endpoint: str = endpoints_config.get("count_endpoint", None)
        if self.count_endpoint is None:
            raise LookupError(
                "Value in toml configuration count_endpoint in section [tool.app.api.endpoints] was not found."
            )

        # Upload options
        self.run_id: int = 0
        self.seq: int = 0
        self.to_upload: list[dict[str, Any]] = []

        # Credentials
        self.username = os.environ.get("UPLOAD_API_USERNAME", None)
        self.password = os.environ.get("UPLOAD_API_PASSWORD", None)
        if self.username is None or self.password is None:
            raise LookupError(
                "User API creadential were not found in the enviroment. Please insert then with name UPLOAD_API_USERNAME and UPLOAD_API_PASSWORD"
            )

        # Token
        self.token: str = None
        self.token_type: str = None
        self.token_expire: datetime.datetime = None

        self.lock = threading.Lock()

        self._refresh_token()
        self._start_refresh_thread()

    @staticmethod
    def _load_config(config_path: Path) -> dict[str, Any]:
        if not config_path.exists():
            raise FileNotFoundError(
                f"Configuration file not found: {config_path.absolute!s}"
            )

        with open(config_path, "rb") as f:
            config_dict = tomllib.load(f)

        config_dict: dict[str, Any] = config_dict.get("tool", None)

        if config_dict is None:
            raise LookupError("Section of configuration file not found: [tool]")

        config_dict = config_dict.get("app", None)
        if config_dict is None:
            raise LookupError("Section of configuration file not found: [tool.app]")

        config_dict = config_dict.get("api", None)
        if config_dict is None:
            raise LookupError("Section of configuration file not found: [tool.app.api]")

        return config_dict

    def _refresh_token(self) -> None:

        attempts: int = 0
        uploaded: bool = False
        while attempts < self.retry_attempts and not uploaded:
            try:
                payload = {
                    "grant_type": "password",
                    "username": self.username,
                    "password": self.password,
                    "scope": "",  # Optional, can be omitted if empty
                }
                header = {
                    "accept" : "application/json"
                }

                response = requests.post(
                    f"{self.api_url}{self.token_endpoint}",
                    headers=header,
                    data=payload,
                    timeout=self.timeout,
                )
                response.raise_for_status()
                response_data : dict[str, Any] = response.json()
                expiry = self._extract_token_expiry(response_data.get("access_token", ""))

                with self.lock:
                    self.token = response_data.get("access_token", "")
                    self.token_type = response_data.get("token_type", "bearer")
                    self.token_expire = expiry
                    uploaded =True
            except requests.exceptions.RequestException as e:
                if attempts <= self.retry_attempts:
                    # TODO: escribir warning
                    logger.warning(f"Request exception error: {e}")
                    attempts += 1
                else:
                    # TODO: escribir error
                    logger.error()

    def _extract_token_expiry(self, token: str) -> datetime.datetime:
        try:
            payload = token.split(".")[1]
            payload += "=" * (4 - len(payload) % 4)
            decode = base64.urlsafe_b64decode(payload)
            data:dict[str, Any] = json.loads(decode)
            if "exp" in data:
                return datetime.datetime.fromtimestamp(
                    data.get("exp", 0), datetime.timezone.utc
                )
        except Exception as e:  # noqa: BLE001
            logger.error(f"Error decoding token expiry: {e}")

        return None

    def _start_refresh_thread(self) -> None:
        def refresh_loop():
            # TODO: crear
            while True:
                if self.token_expire is not None:
                    wait_time: float = (
                        self.token_expire - datetime.datetime.now(datetime.timezone.utc)
                    ).total_seconds()

                    if wait_time > 0:
                        time.sleep(min(30, wait_time))
                    else:
                        self._refresh_token()

        thread = threading.Thread(target=refresh_loop, daemon=True)
        thread.start()

    def get_hearder(self) -> dict:
        with self.lock:
            if not self.token:
                raise ValueError("No current token")
            return {
                "Autorization": f"Bearer {self.token}",
                "Content-Type": "application/json",
            }

    # Generic get and post actions

    def get(self, endpoint: str, **kwargs) -> dict:
        url = f"{self.api_url}{endpoint}"
        kwargs.setdefault("timeout", self.timeout)
        response = requests.get(url, headers=self.get_hearder(), **kwargs)
        response.raise_for_status()
        return response.json()

    def post(self, endpoint: str, data: dict | None = None, **kwargs) -> dict:
        url = f"{self.api_url}{endpoint}"
        kwargs.setdefault("timeout", self.timeout)
        response = requests.post(url, json=data, headers=self.get_hearder(), **kwargs)
        response.raise_for_status()
        return response.json()

    def upload(self, state: HR_State, bpm: int):

        self.to_upload.append(
            HeartBeat(
                device_timestamp=datetime.datetime.now(datetime.timezone.utc),
                state=state,
                bpm=bpm,
                seq=self.seq,
            )
        )
        self.seq += 1

        if len(self.to_upload) >= self.upload_rate:
            self._upload()

        self.to_upload.clear()

    def _upload(self):
        # TODO: crear una función que suba los datos a la API y compruebe si todos se han subido correctamente,
        # el total de entradas introducidas en la API tiene que ser igual a la longitud de la lista de datos a subir
        # Sin embargo, si tras varios intentos no se puede, solo se envía un warning para no bloquear el programa
        raise NotImplementedError()

    def _new_run_id(self):
        # TODO: llamar a la función /new de la API para crear una nueva
        # run en la base de datos y obtener su run_id
        raise NotImplementedError()


if __name__ == "__main__":
    dotenv.load_dotenv(str(Path(__file__).parent.parent / ".env"))
    uploader = DataUploader(Path(__file__).parent.parent / "pyproject.toml")
    print(uploader.token)
