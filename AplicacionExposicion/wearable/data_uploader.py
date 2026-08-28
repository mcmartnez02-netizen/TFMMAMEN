import base64
import datetime
import json
import logging
import os
import threading
import time
from dataclasses import asdict, dataclass
from pathlib import Path

# from pathlib import Path
from typing import Any

import dotenv
import requests
import tomllib
from PySide6.QtCore import QObject, QTimer, Signal
from readings import HR_State


@dataclass
class HeartBeat:
    device_timestamp: datetime.datetime
    bpm: int
    state: HR_State
    seq: int


class HeartBeatEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, datetime.datetime):
            return obj.strftime("%Y-%m-%dT%H:%M:%S.%f")[:-3] + "Z"
        if isinstance(obj, HeartBeat):
            return asdict(obj)
        if isinstance(obj, HR_State):
            return obj.value
        return super().default(obj)


logger = logging.getLogger()


class DataUploader(QObject):
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

        self.new_run_endpoint: str = endpoints_config.get("new_run_endpoint", None)
        if self.new_run_endpoint is None:
            raise LookupError(
                "Value in toml configuration new_run_endpoint in section [tool.app.api.endpoints] was not found."
            )

        # Upload options
        self.run_id: int = 0
        self.seq: int = 0
        self.to_upload: list[HeartBeat] = []

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
        self.timer = None  # Dummy, instanciated in run
        self._stop = threading.Event()

        self._start_refresh_timer()
        self._new_run_id()

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
                    "scope": ["write"],
                }
                header = {"accept": "application/json"}

                response = requests.post(
                    f"{self.api_url}{self.token_endpoint}",
                    headers=header,
                    data=payload,
                    timeout=self.timeout,
                )
                response.raise_for_status()
                response_data: dict[str, Any] = response.json()
                expiry = self._extract_token_expiry(
                    response_data.get("access_token", "")
                )

                with self.lock:
                    self.token = response_data.get("access_token", "")
                    self.token_type = response_data.get("token_type", "bearer")
                    self.token_expire = expiry
                uploaded = True
            except requests.exceptions.RequestException as e:
                # TODO: escribir warning
                logger.warning(f"On attempt {attempts}: request exception {e}")
                attempts += 1

        if attempts >= self.retry_attempts:
            logger.error(f"Could not obtain a token after {self.retry_attempts}")

    def _extract_token_expiry(self, token: str) -> datetime.datetime:
        try:
            payload = token.split(".")[1]
            payload += "=" * (4 - len(payload) % 4)
            decode = base64.urlsafe_b64decode(payload)
            data: dict[str, Any] = json.loads(decode)
            if "exp" in data:
                return datetime.datetime.fromtimestamp(
                    data.get("exp", 0), datetime.timezone.utc
                )
        except Exception as e:  # noqa: BLE001
            logger.error(f"Error decoding token expiry: {e}")

        return None

    def _refresh_timer(self) -> None:
        if self._stop.is_set():
            return
        try:
            if self.token_expire is None:
                self._refresh_token()

            wait_time: float = (
                self.token_expire - datetime.datetime.now(datetime.timezone.utc)
            ).total_seconds()

            # Refresh if expiration is imminent (within 10 seconds)
            if wait_time <= 10:
                self._refresh_token()
                wait_time: float = (
                    self.token_expire - datetime.datetime.now(datetime.timezone.utc)
                ).total_seconds()

            # Check between one hour or the wait_time minus 10
            # to never have a expired token
            next_check = max(10, min(3600, wait_time - 10))
            self.timer.start(int(next_check * 1000))
        except Exception as e:
            logger.error(
                f"Unexpected exception in _refresh_timer: {e}. Retry in 30 seconds"
            )
            self.timer.start(30000)

    def _start_refresh_timer(self) -> None:
        self._stop.clear()
        # Define Timer
        self.timer = QTimer()
        self.timer.setSingleShot(True)
        self.timer.timeout.connect(self._refresh_timer)

        self._refresh_timer()

    # TODO: Legacy: delete when QTimer approach works
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

    def stop(self) -> None:
        self._stop.set()
        self.timer.stop()

    def get_header(self) -> dict:
        with self.lock:
            if not self.token:
                raise ValueError("No current token")
            return {
                "accept": "application/json",
                "Authorization": f"Bearer {self.token}",
                "Content-Type": "application/json",
            }

    # Generic get and post actions

    def get(
        self, endpoint: str, params: dict[str, Any] | None = None, **kwargs
    ) -> dict:
        if params is None:
            params = {}
        url = f"{self.api_url}{endpoint}"
        kwargs.setdefault("timeout", self.timeout)
        try:
            response = requests.get(
                url, headers=self.get_header(), params=params, **kwargs
            )
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            logger.error(f"Error during GET call to API: {e} \n {response.text}")

        return None

    def post(
        self,
        endpoint: str,
        params: dict | None = None,
        data: dict | None = None,
        **kwargs,
    ) -> dict:
        url = f"{self.api_url}{endpoint}"
        kwargs.setdefault("timeout", self.timeout)
        try:
            response = requests.post(
                url, params=params, json=data, headers=self.get_header(), **kwargs
            )
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            logger.error(f"Error during POST call to API: {e} \n {response.text}")

        return None

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

    def _upload(self) -> bool:
        # TODO: crear una función que suba los datos a la API y compruebe si todos se han subido correctamente,
        # el total de entradas introducidas en la API tiene que ser igual a la longitud de la lista de datos a subir
        # Sin embargo, si tras varios intentos no se puede, solo se envía un warning para no bloquear el programa

        # Check API status
        status = self.get(self.status_endpoint)
        total_to_upload = len(self.to_upload)

        # Response model:
        # { "status" : "ok" }
        if status.get("status", "") != "ok":
            return False

        attempts = 0
        while len(self.to_upload) > 0 and attempts < self.retry_attempts:
            data = [
                {
                    "device_timestamp": hb.device_timestamp.strftime(
                        "%Y-%m-%dT%H:%M:%S.%f"
                    )[:-3]
                    + "Z",
                    "bpm": hb.bpm,
                    "state": hb.state.value,
                    "seq": hb.seq,
                }
                for hb in self.to_upload
            ]
            response = self.post(
                self.upload_endpoint, params={"run_id": self.run_id}, data=data
            )                
            # Response Model:
            # { "inserted": [1, 2, 3], "received": 1 }
            if response is not None:
                hb_uploaded: list[int] = response["inserted"]
                self.to_upload = [
                    item for item in self.to_upload if item.seq not in hb_uploaded
                ]
            else:
                logger.warning("Error uploading in function _upload()")

            attempts += 1

        if len(self.to_upload) > 0:
            logger.warning(
                f"Not all hearbeats could be uploaded to API: those which could be not uploaded where saved for latter attempts {[i.seq for i in self.to_upload]}"
            )
            return False

        logger.info(
            f"Correctly uploaded {total_to_upload} hearbeats in {attempts} attempts"
        )
        return True

    def _new_run_id(self) -> bool:
        # Response model :{ "run_id": 4 }
        response = self.get(self.new_run_endpoint)
        self.run_id = response.get("run_id", -1)

        return self.run_id == -1


if __name__ == "__main__":
    dotenv.load_dotenv(
        "/home/alf/Documents/Trabajos/TFMMAMEN/AplicacionExposicion/.env"
    )
    datauploader = DataUploader(Path(__file__).parent.parent / "pyproject.toml")
    dummy = [
        HeartBeat(
            device_timestamp=datetime.datetime.now(),
            bpm=100,
            state=HR_State.ESTRESADO,
            seq=1,
        ),
        HeartBeat(
            device_timestamp=datetime.datetime.now(),
            bpm=100,
            state=HR_State.ESTRESADO,
            seq=2,
        ),
        HeartBeat(
            device_timestamp=datetime.datetime.now(),
            bpm=100,
            state=HR_State.ESTRESADO,
            seq=3,
        ),
        HeartBeat(
            device_timestamp=datetime.datetime.now(),
            bpm=100,
            state=HR_State.ESTRESADO,
            seq=4,
        ),
    ]

    print(datauploader.upload_rate)
    for h in dummy:
        datauploader.upload(h.state, h.bpm)

    print(datauploader.to_upload)
    datauploader.stop()

    """dotenv.load_dotenv(str(Path(__file__).parent.parent / ".env"))
    uploader = DataUploader(Path(__file__).parent.parent / "pyproject.toml")
    print(uploader.token)"""
