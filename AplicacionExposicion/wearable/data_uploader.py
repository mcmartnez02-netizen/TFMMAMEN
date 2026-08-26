import datetime
import logging
import os
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Any

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
                "Value in toml configuration ulr in section [tool.app.api] was not found."
            )

        self.upload_rate: int = config.get("upload_rate", 30)
        self.timeout: int = config.get("timeout", 30)
        self.retry_attempts: int = config.get("retry_attempts", 3)

        endpoints_config = config.get("endpoints", None)
        if endpoints_config is None:
            raise LookupError(
                "Section of toml configuration file not found [tool.app.api.endpoints]"
            )

        # Endpoints config
        self.status_endpoint: str = config.get("status_endpoint", None)
        if self.status_endpoint is None:
            raise LookupError(
                "Value in toml configuration status_endpoint in section [tool.app.api.endpoints] was not found."
            )

        self.token_endpoint: str = config.get("token_endpoint", None)
        if self.token_endpoint is None:
            raise LookupError(
                "Value in toml configuration token_endpoint in section [tool.app.api.endpoints] was not found."
            )

        self.upload_endpoint: str = config.get("upload_endpoint", None)
        if self.upload_endpoint is None:
            raise LookupError(
                "Value in toml configuration upload_endpoint in section [tool.app.api.endpoints] was not found."
            )

        self.count_endpoint: str = config.get("count_endpoint", None)
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
        self.token = None
        self.token_expire: datetime.datetime = None

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

        return config_dict

    def _refresh_token(self) -> None:

        attempts: int = 0
        uploaded: bool = False
        while attempts < self.retry_attempts and not uploaded:
            try:
                # TODO: check API signature
                pass
            except requests.exceptions.RequestException as e:
                if attempts <= self.retry_attempts:
                    # TODO: escribir warning
                    logger.warning()
                    attempts += 1
                else:
                    # TODO: escribir error
                    logger.error()

    
    def _start_refresh_thread(self) -> None:
        def refreah_loop():
            # TODO: crear
            while True:
                if self.token_expiry is not None:
                    wait_time: float = (
                        self.token_expire - datetime.datetime.now(datetime.timezone.utc)
                    ).total_seconds()
                    
                    if wait_time > 0:
                        time.sleep(min(30,wait_time))
                    else:
                        self._refresh_token()                        
        
        # TODO: Aquí poner un thread normal o de QT, la verdad no sé
        # O a lo mejor utilizar singleshot como en la IA
        raise NotImplementedError()

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
