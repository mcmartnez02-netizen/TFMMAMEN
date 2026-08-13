"""Entry point for the wearable heart-rate monitor."""

from __future__ import annotations

import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

from wearable.controller import MonitorController
from wearable.readings import HeartRateSimulator, load_bpm_samples, HR_State

DATA_DIR = Path(__file__).parent / "data"
QML_FILE = Path(__file__).parent / "wearable" / "qml" / "Main.qml"
Y_PADDING = 5


def main() -> int:
    app = QGuiApplication(sys.argv)

    sources = {
        HR_State.ESTRESADO: load_bpm_samples(DATA_DIR / "session.csv"),
        HR_State.EXCITADO: load_bpm_samples(DATA_DIR / "exce.csv"),
    }

    simulator = HeartRateSimulator(sources, state=ESTRESADO)
    controller = MonitorController(simulator)

    # A shared y range keeps the excited stretch visibly higher instead of
    # rescaling the axis to look identical to the resting trace.
    every_sample = [bpm for samples in sources.values() for rr, bpm in samples]
    controller.set_y_range(min(every_sample) - Y_PADDING, max(every_sample) + Y_PADDING)

    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("controller", controller)
    engine.load(QML_FILE)
    if not engine.rootObjects():
        return 1

    simulator.start()
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
