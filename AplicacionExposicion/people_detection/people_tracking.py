# Original code by Ultralytics
# Edits to original by Alfredo Marquina Meseguer

import cv2
import numpy as np
from ultralytics import YOLO
from ultralytics.utils.plotting import colors
from collections import defaultdict
from pathlib import Path
from people_detection.utils import calculateHeight
from people_detection.config import load_detection_config, POSE_LINES, DetectionConfig
import time
MODEL_DIR = Path(__file__).parent
REFERENCES_FOLDER = Path(__file__).parent / "test_references"

class PeopleTracking:
    """Object Tracking using Ultralytics YOLO26: https://docs.ultralytics.com/models/yolo26/"""

    def __init__(self, model="yolo26n-pose.pt", source="path/to/video.mp4", debug:bool = False, save:bool = False):

        self.model = YOLO(model)  # Model initialization
        self.names = self.model.names  # Store model classes names

        # Video capturing module
        self.cap = cv2.VideoCapture(source)
        assert self.cap.isOpened(), "Error reading video file"

        # Video writing module
        self.save = save
        self.frame_width, self.frame_height, fps = (
            int(self.cap.get(x))
            for x in (
                cv2.CAP_PROP_FRAME_WIDTH,
                cv2.CAP_PROP_FRAME_HEIGHT,
                cv2.CAP_PROP_FPS))
        if self.save:
            self.writer = cv2.VideoWriter(
                "people_tracking_debug.avi",
                cv2.VideoWriter_fourcc(*"mp4v"),
                fps,
                (self.frame_width, self.frame_height)
                )

        self.track_history = defaultdict(lambda: [])  # Store the track history

        # Display settings
        self.debug = debug # Only show window is this is True
        self.rect_width=2
        self.font = 1.0
        self.text_width=2
        self.padding = 12
        self.margin = 10
        self.circle_thickness=5
        self.polyline_thickness=2

        # Window setup
        self.window_name = "YOLO Tracking"
        if self.debug:
            cv2.namedWindow(self.window_name, cv2.WINDOW_NORMAL)

        # Detection
        self.presence_near = False
        self.detection_config = load_detection_config()
        self.time_no_presence = time.time()

    def draw_bbox(self, im0, box, track_id, height: float):
        """Draw bounding box with label at TOP-LEFT, but TEXT CENTERED in its box."""

        x1, y1, x2, y2 = map(int, box)

        color = colors(0, True)

        # Draw main bounding box
        cv2.rectangle(im0, (x1, y1), (x2, y2), color, self.rect_width)

        # Prepare label
        label = f"{int(track_id):}:{float(height):.2f}"

        # Get text size
        (tw, th), _ = cv2.getTextSize(
            label, cv2.FONT_HERSHEY_SIMPLEX, self.font, self.text_width
        )

        bg_x1 = x1  # left edge of bbox
        bg_x2 = bg_x1 + (tw + 2 * self.padding)

        bg_y2 = y1  # top of bbox
        bg_y1 = bg_y2 - (th + 2 * self.margin)

        # Draw filled background rectangle (top-left)
        cv2.rectangle(
            im0,
            (bg_x1, bg_y1),
            (bg_x2, bg_y2),
            color,
            -1,
        )

        text_x = bg_x1 + ((bg_x2 - bg_x1) - tw) // 2
        text_y = bg_y1 + ((bg_y2 - bg_y1) + th) // 2 - 2  # small vertical tweak

        cv2.putText(
            im0,
            label,
            (text_x, text_y),
            cv2.FONT_HERSHEY_SIMPLEX,
            self.font,
            (255, 255, 255) ,  # white text
            self.text_width,
            cv2.LINE_AA,
        )


    def draw_pose(self, im0, keypoints):
        """Dibujar los puntos y lineas de las poses"""
        
        for p1_index, p2_index, color in POSE_LINES:
            cv2.line(im0,
                 keypoints[int(p1_index)],
                 keypoints[int(p2_index)],
                 colors(color, True),
                 1)
            
    def putText(self, img, string, orig=(5,16), color=(0,0,0), scale=1, thickness=1):
        (x,y) = orig
        (w,h), b = cv2.getTextSize(string, cv2.FONT_HERSHEY_PLAIN, scale, thickness)
        cv2.rectangle(img, (x-3, y-h-4), (x+w+3, y+b), (255, 255, 255), -1)
        cv2.putText(img, string, (x,y), cv2.FONT_HERSHEY_PLAIN, scale, color, thickness, cv2.LINE_AA)
        
    def _update_presence(self, people_heights):
        # NOTE: llamar al controler cada vez que cambia no siempre.
        if people_heights:
            max_height = max(people_heights)
            if not self.presence_near and  max_height > self.detection_config.near_height:
                self.presence_near = True
                # TODO: Aquí se llamaría al controler
            elif self.presence_near and max_height < self.detection_config.far_height:
                self.presence_near = False
                # TODO: Aquí se llamaría al controler
            self.time_no_presence = time.time()        
        elif time.time() - self.time_no_presence > self.detection_config.time_no_presence \
            and self.presence_near == True:
                self.presence_near = False
                # TODO: Aquí se llamaría al controler
        
        
    def run(self):
        """Function to run object tracking on video file or webcam."""        
        while self.cap.isOpened():
            success, im0 = self.cap.read()

            if not success:
                print("End of video or failed to read image.")
                break

            results = self.model.track(im0, persist=True, conf = self.detection_config.person_confidence)  # Object tracking
            people_heights: list[float] = []
            
            if results and len(results) > 0:
                result = results[0]
                

                if result.boxes is not None and result.boxes.id is not None:
                    boxes = result.boxes.xyxy.cpu()
                    ids = result.boxes.id.cpu()
                    keypoints = result.keypoints.xy.tolist()
                    keypoints_conf = result.keypoints.conf.tolist()

                    if boxes is not None and ids is not None:
                        for box, id, k_point, conf in zip(boxes, ids.tolist(), keypoints, keypoints_conf):                            
                            
                            person_height = calculateHeight(k_point, conf, self.detection_config) 
                            if person_height is None:
                                continue
                            
                            person_height_norm = person_height / self.frame_height
                            people_heights.append(person_height_norm)
                            
                            if self.debug or self.save:
                                keypoint_int = [[int(x), int(y)] for x, y in k_point]
                                self.draw_bbox(im0, box, id, person_height_norm)
                                self.draw_pose(im0, keypoint_int)                                                        

                                x1, y1, x2, y2 = box
                                track = self.track_history[id]

                                # append box centroid
                                track.append(
                                    (float((x1+x2)/2), 
                                    float((y1+y2)/2))
                                    )  
                                if len(track) > 30:  # retain 30 tracks for 30 frames
                                    track.pop(0)
        
                                # draw the tracking lines
                                points = np.hstack(track).astype(np.int32).reshape((-1, 1, 2))
                                
                                cv2.circle(
                                    im0,
                                    (int(track[-1][0]), int(track[-1][1])),
                                    5,
                                    colors(0, True),
                                    -1
                                )

                                cv2.polylines(
                                    im0, 
                                    [points], 
                                    isClosed=False, 
                                    color=colors(0, True), 
                                    thickness=self.polyline_thickness
                                    )
                            
                        # Only call the controller when the presence is changed
                        
            
            self._update_presence(people_heights)
            
            if self.debug or self.save:
                self.putText(im0, "Near" if self.presence_near else "Far")
                
            if self.save:
                self.writer.write(im0)
                
            if self.debug:
                cv2.imshow(self.window_name, im0)  # Display and handle input

                key = cv2.waitKey(1) & 0xFF
                if key == ord('q'):
                    break

        # Cleanup
        self.cap.release()
        if self.save:
            self.writer.release()
        cv2.destroyAllWindows()


if __name__ == "__main__":
    # Initialize and run tracker
    tracker = PeopleTracking(
        model= MODEL_DIR / "yolo26n-pose.pt",
        #source= REFERENCES_FOLDER / "street_walking.mp4",        
        source= 0,
        debug=True,
        save=False,
    )
    tracker.run()
