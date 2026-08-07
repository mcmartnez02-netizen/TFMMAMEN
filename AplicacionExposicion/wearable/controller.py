"""Bridges the heart-rate simulator to the QML window."""

from __future__ import annotations

from typing import Tuple

from collections import deque

from PySide6.QtCore import Property, QObject, QPointF, Signal, Slot

from .readings import DEFAULT, EXCITADO, HeartRateSimulator



class SumBoundedQueue:
    """Clase auxiliar que permite tener una cola de listas o tuplas 
    cuyo primer elemento puede sumar como maximo un umbral"""
    # NOTA: implementamos esto para tener una lista de elementos que 
    # se puedan representar dentro del grafico, es decir, que solo tengan
    # los elementos de los últimos N milisegundos (en nuestro caso 30 segundos)
    
    def __init__(self, threshold):
        self.threshold = threshold
        self.items = deque()
        self.total = 0.0

    def push(self, item):
        self.items.append(item)
        self.total += item[0]
        while self.total > self.threshold and self.items:
            self.total -= self.items.popleft()[0]
    
    def __len__(self):
        return len(self.items)
    
    def __iter__(self):
        return iter(self.items)
    
    def __reversed__(self):
        return reversed(self.items)
    
    def __getitem__(self, key):
        # Nota: no permite slice solo int
        return self.items[key]


class MonitorController(QObject):
    bpmChanged = Signal()
    stateTextChanged = Signal()
    exciteEnabledChanged = Signal()
    excitedChanged = Signal()
    pointsChanged = Signal()
    WINDOW_SIZE = 90
    threshold_to_window =  1 / 1000
    threshold_ms = WINDOW_SIZE / threshold_to_window

    def __init__(
        self, simulator: HeartRateSimulator, parent: QObject | None = None
    ) -> None:
        super().__init__(parent)
        self._simulator = simulator
        self._readings: deque[Tuple[float, float]] = SumBoundedQueue(self.threshold_ms)

        self._bpm = 0
        self._state_text = "Resting"
        self._excite_enabled = True
        self._excited = False
        self._points: list[QPointF] = []
        self._y_min = 0
        self._y_max = 0

        simulator.reading_ready.connect(self._on_reading_ready)
        simulator.source_exhausted.connect(self._on_source_exhausted)

    # ---------- Propiedades Expuestas a QML ----------

    @Property(int, notify=bpmChanged)
    def bpm(self) -> int:
        return self._bpm

    @Property(str, notify=stateTextChanged)
    def stateText(self) -> str:
        return self._state_text

    @Property(bool, notify=exciteEnabledChanged)
    def exciteEnabled(self) -> bool:
        return self._excite_enabled

    @Property(bool, notify=excitedChanged)
    def excited(self) -> bool:
        return self._excited

    @Property(list, notify=pointsChanged)
    def points(self) -> list[QPointF]:
        return self._points

    @Property(int, constant=True)
    def windowSize(self) -> int:
        return self.WINDOW_SIZE

    @Property(int, constant=True)
    def yMin(self) -> int:
        return self._y_min

    @Property(int, constant=True)
    def yMax(self) -> int:
        return self._y_max

    def set_y_range(self, low: int, high: int) -> None:
        """Snap to whole decades so the axis lands on round labels."""
        self._y_min = low - low % 10
        self._y_max = high + -high % 10

    # ---------- events ----------

    def _on_reading_ready(self, rr:float, bpm:float) -> None:        
        self._readings.push((rr, bpm))

        self._bpm = bpm
        self.bpmChanged.emit()

        # Newest sample sits at x=0; the trail extends left into the past.
        
        newest = self._readings[len(self._readings)-1][0]
        self._points = [
            QPointF((newest:=newest - rr) * self.threshold_to_window, value) for rr, value in reversed(self._readings)
        ]
                
        self.pointsChanged.emit()

    @Slot()
    def excite(self) -> None:
        """Evento del botón: cambiar de DEFAULT a EXCITADO"""
        self._simulator.switch_to(EXCITADO)

        self._excite_enabled = False
        self.exciteEnabledChanged.emit()
        self._excited = True
        self.excitedChanged.emit()
        self._state_text = "Excitado"
        self.stateTextChanged.emit()

    def _on_source_exhausted(self, name: str) -> None:
        """Evento de fin de lecturas: solo el estado de EXCITADO.
        El estado DEFAULT no cambia."""
        if name != EXCITADO:
            return
        self._simulator.switch_to(DEFAULT)

        self._excite_enabled = True
        self.exciteEnabledChanged.emit()
        self._excited = False
        self.excitedChanged.emit()
        self._state_text = "Resting"
        self.stateTextChanged.emit()
