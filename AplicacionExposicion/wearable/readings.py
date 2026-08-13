"""Loading and replaying heart-rate samples exported by the wearable."""

from __future__ import annotations

import csv
from pathlib import Path
from enum import Enum

from PySide6.QtCore import QObject, QTimer, Signal

# De cada lectura del CSV solo nos interesa la
HEADER_ROWS = 1
RR_COLUMN = 2
HR_COLUMN = 3




def load_bpm_samples(path: Path) -> list[(float,float)]:
    """Lee los bpm del CSV del Polar H10"""
    with path.open(newline="", encoding="utf-8-sig") as handle:
        rows = list(csv.reader(handle))

    samples: list[(float, float)] = []
    for row in rows[HEADER_ROWS:]:
        if len(row) <= HR_COLUMN:
            continue
        raw = row[HR_COLUMN].strip()
        rr = row[RR_COLUMN].strip()
        if not raw and not rr:
            continue
        try:
            samples.append((float(rr), float(raw)))
        except ValueError:
            continue

    if not samples:
        raise ValueError(f"No BPM samples found in {path}")
    return samples

_INITIAL_INTERVAL = 1000 

class HR_State (Enum):
        ESTRESADO = "Estresado"
        SENSIBLE = "Sensible"
        RELAJADO = "Relajado"
        LATENTE = "Latente"

class HeartRateSimulator(QObject):    
    """Emite una lectura por tick, en modo default vuelve 
    al inicio cuando se terminan las lecturas y en modo excitado 
    vuelve al modo default una vez se terminan las lecturas."""   

    reading_ready = Signal(float, float)
    source_exhausted = Signal(HR_State)

    def __init__(
        self,
        sources: dict[HR_State, list[(float, float)]],
        state: HR_State = HR_State.ESTRESADO,
        parent: QObject | None = None,
    ) -> None:
        super().__init__(parent)
        self._sources = sources
        self._state: HR_State = state
        self._index = 0

        self._timer = QTimer(self)
        self._timer.setInterval(_INITIAL_INTERVAL)
        self._timer.timeout.connect(self._tick)

    @property
    def active_source(self) -> HR_State:
        return self._state

    def start(self) -> None:
        self._timer.start()

    def switch_to(self, new_state: HR_State) -> None:
        """Cambiar estado entre excitado y descanso"""
        self._state = new_state
        self._index = 0

    def _tick(self) -> None:
        """En cada tick el programa emite una nueva lectura. 
        Cuando se terminan las lecturas vuelve al inicio del modo default."""
        samples = self._sources[self._state]
        # Aquí accedemos al BPM
        self.reading_ready.emit(samples[self._index][0], samples[self._index][1])

        self._index += 1
        if self._index >= len(samples):
            self._index = 0
            self.source_exhausted.emit(self._state)
        
        # Aquí accedmos al rr
        self._timer.setInterval(samples[self._index][0])
