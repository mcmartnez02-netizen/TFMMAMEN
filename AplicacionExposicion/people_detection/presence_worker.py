# Class by Alfredo Marquina Meseguer
# Original code by Ultralytics (Object-traking)

import logging
import threading
import time
from pathlib import Path

import cv2
from PySide6.QtCore import QObject, QTimer, Signal
from ultralytics import YOLO
from ultralytics.engine.results import Results

# Local imports
from people_detection.config import DetectionConfig, load_detection_config
from people_detection.debug_renderer import DebugRenderer
from people_detection.utils import Detection, calculateHeight, grab_fresh

MODEL_DIR = Path(__file__).parent
REFERENCES_FOLDER = Path(__file__).parent / "test_references"

logger = logging.getLogger()

class PresenceWorker(QObject):
    """Object Tracking using Ultralytics YOLO26: https://docs.ultralytics.com/models/yolo26/"""

    presence_changed = Signal(bool)
    finished = Signal(bool)

    def __init__(
        self,
        model_path="yolo26n-pose_ncnn_model",
        source_path="path/to/video.mp4",
        output_path: Path = Path(__file__).parent / "output_debug.avi",
        debug: bool = False,
        save: bool = False,
    ):
        super().__init__()

        self.model = YOLO(model_path)  # Model initialization

        # Video capturing module
        self.cap = cv2.VideoCapture(source_path)
        assert self.cap.isOpened(), "Error reading video file"
        self.cap.set(cv2.CAP_PROP_FPS, 2)

        # Video writing module
        self.frame_width, self.frame_height, self.fps = (
            int(self.cap.get(x))
            for x in (
                cv2.CAP_PROP_FRAME_WIDTH,
                cv2.CAP_PROP_FRAME_HEIGHT,
                cv2.CAP_PROP_FPS,
            )
        )

        # Detection
        self.presence_near = False
        self.detection_config: DetectionConfig = load_detection_config()
        self.time_no_presence = time.monotonic()

        # Window setup
        temp_fps = (
            min(self.fps, self.detection_config.max_fps)
            if self.fps > 0
            else self.detection_config.max_fps
        )
        self.renderer = (
            DebugRenderer(
                self.frame_width, self.frame_height, temp_fps, output_path, debug, save
            )
            if debug or save
            else None
        )
        self.debug = debug

        # Threading
        self.min_period = 1 / self.detection_config.max_fps
        self._stop = threading.Event()
        self._finished = False
        self._consecutive_errors = 0

        self.timer = None  # Dummy, instanciated in run

    def _update_presence(self, detections: list[Detection]):
        # NOTE: llamar al controler cada vez que cambia no siempre.
        people_heights = [
            detection.height for detection in detections if detection.height is not None
        ]
        if people_heights:
            max_height = max(people_heights)
            if (
                not self.presence_near
                and max_height > self.detection_config.near_height
            ):
                self.presence_near = True
                # NOTE: Call to controller here
                self.presence_changed.emit(self.presence_near)
            elif self.presence_near and max_height < self.detection_config.far_height:
                self.presence_near = False
                # NOTE: Call to controller here
                self.presence_changed.emit(self.presence_near)
            self.time_no_presence = time.monotonic()
        elif (
            time.monotonic() - self.time_no_presence
            > self.detection_config.time_no_presence
            and self.presence_near == True
        ):
            self.presence_near = False
            # NOTE: Call to controller here
            self.presence_changed.emit(self.presence_near)

    def model_thingy(self) -> bool:
        # NOTE: since we are manually forcing an fps reduction we need
        # to empty camera buffer before getting the next frame
        success, im0 = grab_fresh(self.cap)
        if not success:
            # TODO: put real logger
            
            print("End of video or failed to read image.")
            return False

        detections = self.process_image(im0)

        # TODO: since this version runs with the Qt app it
        # might not be able to render it's own window. Need to test
        # and remove renderer if not needed.
        if self.renderer:
            self.renderer.render(im0, detections, self.presence_near)
            if self.renderer.should_quit():
                return False

        return True

    def process_image(self, img: cv2.typing.MatLike) -> list[Detection]:
        detections = []
        results = self.model(img, conf=self.detection_config.person_confidence)
        if results and len(results) > 0:
            detections = self.process_results(results[0])
            self._update_presence(detections)
            if self.debug:
                logger.debug(f"{len(detections)} people detected")
                for i, detection in  enumerate(detections):
                    logger.debug(f"Detection {i}, height {detection.height if detection.height is not None else 0.0:.2f}, box {detection.box!s}, keypoints {detection.keypoints!s}")

        return detections

    def process_results(self, result: Results) -> list[Detection]:
        """Calculamos con el"""
        detections: list[Detection] = []
        if result.keypoints is not None:
            boxes = result.boxes.xyxy.cpu()
            keypoints = result.keypoints.xy.tolist()
            keypoints_conf = result.keypoints.conf.tolist()

            for box, k_point, conf in zip(boxes, keypoints, keypoints_conf):
                person_height = calculateHeight(k_point, conf, self.detection_config)
                person_height_norm = (
                    person_height / self.frame_height
                    if person_height is not None
                    else None
                )
                detections.append(Detection(box, k_point, person_height_norm))

        return detections

    def run(self):
        self._stop.clear()
        # Define Timer
        self.timer = QTimer(self)
        self.timer.setSingleShot(True)
        self.timer.timeout.connect(self._tick)

        self._tick()

    def _finish(self, ok: bool = True):
        if self._finished:
            return

        if self.renderer:
            self.renderer.cleanup()
        self.cap.release()

        self._stop.set()
        self._finished = True
        self.finished.emit(ok)

    def _tick(self):
        try:
            if self._stop.is_set():
                self._finish(True)
                return

            if not self.cap.isOpened():
                logger.warning("End of video or camera closed.")
                self._finish(False)
                return
            now = time.monotonic()

            ok = self.model_thingy()
            if not ok:
                self._consecutive_errors += 1
                if (
                    self._consecutive_errors
                    > self.detection_config.max_consecutive_erros
                ):
                    self._finish(False)
                return

            self._consecutive_errors = 0
            remaining = self.min_period - (time.monotonic() - now)
            self.timer.start(max(0, int(remaining * 1000)))
        except Exception:
            logger.exception("Unexpected error processing frame")
            self._finish(False)

    def stop(self):
        self._stop.set()
