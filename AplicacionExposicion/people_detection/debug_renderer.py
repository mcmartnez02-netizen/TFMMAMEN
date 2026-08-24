from pathlib import Path

import cv2
from ultralytics.utils.plotting import colors

# Local imports
from people_detection.config import BodyPart
from people_detection.utils import Detection

POSE_LINES = [(BodyPart.Nose.value, BodyPart.Left_Eye.value, 1),
                (BodyPart.Nose.value, BodyPart.Right_Eye.value, 1),
                (BodyPart.Left_Eye.value, BodyPart.Right_Eye.value, 1),
                (BodyPart.Left_Eye.value, BodyPart.Left_Ear.value, 1),
                (BodyPart.Right_Eye.value, BodyPart.Right_Ear.value, 1),
                (BodyPart.Left_Ear.value, BodyPart.Left_Shoulder.value, 1),
                (BodyPart.Right_Ear.value, BodyPart.Right_Shoulder.value, 1),
                (BodyPart.Left_Shoulder.value, BodyPart.Right_Shoulder.value, 2),
                (BodyPart.Left_Shoulder.value, BodyPart.Left_Elbow.value, 2),
                (BodyPart.Right_Shoulder.value, BodyPart.Right_Elbow.value, 2),
                (BodyPart.Left_Elbow.value, BodyPart.Left_Wrist.value, 2),
                (BodyPart.Right_Elbow.value, BodyPart.Right_Wrist.value, 2),
                (BodyPart.Left_Shoulder.value, BodyPart.Left_Hip.value, 3),
                (BodyPart.Right_Shoulder.value, BodyPart.Right_Hip.value, 3),
                (BodyPart.Left_Hip.value, BodyPart.Right_Hip.value, 3),
                (BodyPart.Left_Hip.value, BodyPart.Left_Knee.value, 5),
                (BodyPart.Right_Hip.value, BodyPart.Right_Knee.value, 5),
                (BodyPart.Left_Knee.value, BodyPart.Left_Ankle.value, 5),
                (BodyPart.Right_Knee.value, BodyPart.Right_Ankle.value, 5)]

class DebugRenderer:
    
    def __init__(self, frame_width, frame_height, fps, output_path: Path = Path(__file__).parent / "debug_output.avi", show:bool = False, save:bool = False):
        # Video writing module
        self.save = save
        self.writer = cv2.VideoWriter(
            str(output_path),
            cv2.VideoWriter_fourcc(*"mp4v"),
            fps,
            (frame_width, frame_height)
            ) if self.save else  None

        # Display settings
        self.show = show # Only show window is this is True
        self.rect_width=2
        self.font = 1.0
        self.text_width=2
        self.padding = 12
        self.margin = 10

        # Window setup
        self.window_name = "YOLO Tracking"
        if self.show:
            cv2.namedWindow(self.window_name, cv2.WINDOW_NORMAL)

    def draw_bbox(self, im0, box, height: float):
        """Draw bounding box with label at TOP-LEFT, but TEXT CENTERED in its box."""

        x1, y1, x2, y2 = map(int, box)

        color = colors(0, True)

        # Draw main bounding box
        cv2.rectangle(im0, (x1, y1), (x2, y2), color, self.rect_width)

        # Prepare label
        label = f"{float(height):.2f}" if height is not None else "None"

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
            
    def draw_text(self, img, string, orig=(5,16), color=(0,0,0), scale=1, thickness=1):
        (x,y) = orig
        (w,h), b = cv2.getTextSize(string, cv2.FONT_HERSHEY_PLAIN, scale, thickness)
        cv2.rectangle(img, (x-3, y-h-4), (x+w+3, y+b), (255, 255, 255), -1)
        cv2.putText(img, string, (x,y), cv2.FONT_HERSHEY_PLAIN, scale, color, thickness, cv2.LINE_AA)
        
    def render(self, im0, detections:list[Detection], presence_near):
        for detection in detections:              
            keypoint_int = [[int(x), int(y)] for x, y in detection.keypoints]
            self.draw_bbox(im0, detection.box, detection.height)
            self.draw_pose(im0, keypoint_int)                        
                    
        self.draw_text(im0, "Near" if presence_near else "Far")
        
        if self.show:
            cv2.imshow(self.window_name, im0)  # Display and handle input    
            
        if self.save:
            self.writer.write(im0)
    
    def should_quit(self):
        if not self.show: return False
        key = cv2.waitKey(1) & 0xFF
        return key == ord('q')
            
    
    def cleanup(self):
        if self.save:
            self.writer.release()
        if self.show:
            cv2.destroyWindow(self.window_name)