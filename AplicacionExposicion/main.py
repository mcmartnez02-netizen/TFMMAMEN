from __future__ import annotations

import sys
from pathlib import Path

from PySide6.QtCore import QUrl, QThread
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickView

# Local imports
from wearable.controller import MonitorController
from wearable.readings import HeartRateSimulator, load_bpm_samples, HR_State

from people_detection import PresenceWorker


DATA_DIR = Path(__file__).parent / "data"
QML_FILE = Path(__file__).parent / "InterfazFigmaQt" / "Modo_instalacion.qml"
MODEL_DIR = Path(__file__).parent / "people_detection"

Y_PADDING = 5

CONFIG_FILE = Path(__file__).parent / "pyproject.toml"


def main() -> int:
    app = QGuiApplication(sys.argv)

    sources = {
        HR_State.ESTRESADO: load_bpm_samples(DATA_DIR / "estresado.csv"),
        HR_State.SENSIBLE: load_bpm_samples(DATA_DIR / "sensible.csv"),
        HR_State.RELAJADO: load_bpm_samples(DATA_DIR/ "relajado.csv"),
        HR_State.LATENTE: load_bpm_samples(DATA_DIR / "latente.csv")
    }

    # Parented to the app so C++ owns them: otherwise Python frees the
    # controller while QML still holds bindings to it and every binding logs a
    # "property of null" TypeError on shutdown.
    simulator = HeartRateSimulator(sources, state=HR_State.ESTRESADO, parent=app)
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

    # Ejecución modelo
    thread = QThread()
    worker = PresenceWorker(
        model= MODEL_DIR / "yolo26n-pose.pt",
        #source= REFERENCES_FOLDER / "street_walking.mp4",        
        source= 0,)
    worker.moveToThread(thread)
    thread.started.connect(worker.run)
    worker.presence_changed.connect(controller.update_presence) 
    thread.start()
    
    simulator.start()
    exit_code = app.exec()
    
    worker.stop()
    thread.quit()
    if not thread.wait(5000):
        print("Aviso: el hileo de detección no terminó a timepo", file= sys.stderr)    
    
    return exit_code


if __name__ == "__main__":
    sys.exit(main())
