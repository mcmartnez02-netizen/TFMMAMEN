import logging
import sys
from logging.handlers import RotatingFileHandler
from pathlib import Path

LOG_DIR = Path(__file__).parent / "logs"
FORMAT = "%(asctime)s %(levelname)-8s [%(threadName)s] %(name)s: %(message)s"


def setup_logging(level: int = logging.INFO, to_file: bool = True) -> None:
    root = logging.getLogger()
    root.setLevel(logging.DEBUG)          # handlers do the real filtering

    console = logging.StreamHandler(sys.stderr)
    console.setLevel(level)
    console.setFormatter(logging.Formatter(FORMAT))
    root.addHandler(console)

    if to_file:
        LOG_DIR.mkdir(exist_ok=True)
        file_handler = RotatingFileHandler(
            LOG_DIR / "exposicion.log", maxBytes=2_000_000, backupCount=3,
            encoding="utf-8",
        )
        file_handler.setLevel(logging.DEBUG)
        file_handler.setFormatter(logging.Formatter(FORMAT))
        root.addHandler(file_handler)

    # Ultralytics logs one line per inference — at 2 FPS that is 7200 lines/hour.
    logging.getLogger("ultralytics").setLevel(logging.WARNING)
