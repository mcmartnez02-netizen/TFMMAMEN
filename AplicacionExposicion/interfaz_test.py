from __future__ import annotations

import sys
from pathlib import Path

from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickView

from wearable.controller import MonitorController
from wearable.readings import DEFAULT, EXCITADO, HeartRateSimulator, load_bpm_samples

DATA_DIR = Path(__file__).parent / "data"
QML_FILE = Path(__file__).parent / "InterfazFigmaQt" / "Modo_instalacion.qml"
Y_PADDING = 5


def main() -> int:
    app = QGuiApplication(sys.argv)

    sources = {
        DEFAULT: load_bpm_samples(DATA_DIR / "session.csv"),
        EXCITADO: load_bpm_samples(DATA_DIR / "exce.csv"),
    }

    # Parented to the app so C++ owns them: otherwise Python frees the
    # controller while QML still holds bindings to it and every binding logs a
    # "property of null" TypeError on shutdown.
    simulator = HeartRateSimulator(sources, active=DEFAULT, parent=app)
    controller = MonitorController(simulator, parent=app)

    # A shared y range keeps the excited stretch visibly higher instead of
    # rescaling the axis to look identical to the resting trace.
    every_sample = [bpm for samples in sources.values() for rr, bpm in samples]
    controller.set_y_range(min(every_sample) - Y_PADDING, max(every_sample) + Y_PADDING)

    # The root element is a plain Rectangle, so QQmlApplicationEngine has no
    # Window to show. QQuickView provides the window itself.
    view = QQuickView()
    view.setResizeMode(QQuickView.SizeRootObjectToView)

    # Must land before setSource: the first binding pass would otherwise
    # evaluate against an undefined `controller`.
    view.rootContext().setContextProperty("controller", controller)
    view.setSource(QUrl.fromLocalFile(QML_FILE))

    if view.status() == QQuickView.Error:
        for error in view.errors():
            print(error.toString(), file=sys.stderr)
        return 1

    # The design is 1920x1080; start smaller so it fits on a normal screen.
    view.resize(1280, 720)
    view.rootObject().exitRequested.connect(view.close)
    view.show()

    simulator.start()
    return app.exec()


if __name__ == "__main__":
    sys.exit(main())
