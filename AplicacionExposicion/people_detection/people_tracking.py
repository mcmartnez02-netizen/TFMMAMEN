# Original code by Ultralytics
# Edits to original by Alfredo Marquina Meseguer

import time
import cv2
from ultralytics import YOLO
from ultralytics.engine.results import Results
from pathlib import Path

#Local imports 
from people_detection.utils import calculateHeight, Detection
from people_detection.config import load_detection_config,  DetectionConfig
from people_detection.debug_renderer import DebugRenderer
 
MODEL_DIR = Path(__file__).parent
REFERENCES_FOLDER = Path(__file__).parent / "test_references"

def grab_fresh(cap:cv2.VideoCapture, stale_threshold=0.005, max_buffer=8):
    """Discard buffered frames, decode only the freshest one."""
    # Suponemos que tamaño de buffer max es default de max_drops
    for _ in range(max_buffer):
        t0 = time.monotonic()
        if not cap.grab():
            return False, None
        # Suponemos: Instantaneo -> de buffer y superior a threshold -> reciente
        if time.monotonic() - t0 > stale_threshold:
            break                      
    return cap.retrieve()

class PeopleTracking:
    """Object Tracking using Ultralytics YOLO26: https://docs.ultralytics.com/models/yolo26/"""

    def __init__(self, model_path="yolo26n-pose_ncnn_model", source_path="path/to/video.mp4", output_path: Path = Path(__file__).parent / "output_debug.avi",
                 debug:bool = False, save:bool = False):

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
                cv2.CAP_PROP_FPS))

        # Detection        
        self.presence_near = False
        self.detection_config: DetectionConfig = load_detection_config()
        self.time_no_presence = time.monotonic()
        
        # Window setup
        temp_fps = min(self.fps, self.detection_config.max_fps) if self.fps > 0  else self.detection_config.max_fps
        self.renderer = DebugRenderer(self.frame_width, self.frame_height, temp_fps, 
                        output_path, debug, save) if debug or save else None

    
        
    def _update_presence(self, detections:list[Detection]):
        # NOTE: llamar al controler cada vez que cambia no siempre.
        people_heights = [detection.height for detection in detections if detection.height is not None]
        if people_heights:
            max_height = max(people_heights)
            if not self.presence_near and  max_height > self.detection_config.near_height:
                self.presence_near = True
                # TODO: Aquí se llamaría al controler
            elif self.presence_near and max_height < self.detection_config.far_height:
                self.presence_near = False
                # TODO: Aquí se llamaría al controler
            self.time_no_presence = time.monotonic()
        elif time.monotonic() - self.time_no_presence > self.detection_config.time_no_presence \
            and self.presence_near == True:
                self.presence_near = False
                # TODO: Aquí se llamaría al controler
    
        
    
    def process_results(self, result: Results) -> list[Detection]:
        """Calculamos con el """
        detections: list[Detection] = []
        if result.keypoints is not None:
            boxes = result.boxes.xyxy.cpu()
            keypoints = result.keypoints.xy.tolist()
            keypoints_conf = result.keypoints.conf.tolist()
            
            for box, k_point, conf in zip(boxes, keypoints, keypoints_conf):
                person_height = calculateHeight(k_point, conf, self.detection_config)                 
                person_height_norm = person_height / self.frame_height if person_height is not None else None
                detections.append(Detection(box, k_point, person_height_norm))
        
        return detections
            
        
    def run(self):
        """Function to run object tracking on video file or webcam."""        
        next_frame_at = time.monotonic()
        
        # time between frames
        min_period = 1 / self.detection_config.max_fps
        
        try:
            while self.cap.isOpened():
                now = time.monotonic()
                
                if now < next_frame_at:
                    time.sleep(next_frame_at - now)
                    now = time.monotonic()
                
                # Get frame
                #success, im0 = grab_fresh(self.cap)
                success, im0 = self.cap.read()
                if not success:
                    # TODO: put real logger
                    print("End of video or failed to read image.")
                    break    
                
                # Detect people
                results = self.model(im0, conf = self.detection_config.person_confidence)           
                if results and len(results) > 0:                        
                    detections = self.process_results(results[0])                    
                    self._update_presence(detections)
                    
                if self.renderer:
                    self.renderer.render(im0, detections, self.presence_near)
                    if self.renderer.should_quit():
                        break
                                
                next_frame_at = now + min_period
        finally:
            # Cleanup
            if self.renderer:
                self.renderer.cleanup()
            
            self.cap.release()

if __name__ == "__main__":
    # Initialize and run tracker
    tracker = PeopleTracking(
        model_path= MODEL_DIR / "yolo26n-pose_ncnn_model",
        #source= REFERENCES_FOLDER / "street_walking.mp4",        
        source_path= 1,
        debug=True,
        save=False,
    )
    tracker.run()
