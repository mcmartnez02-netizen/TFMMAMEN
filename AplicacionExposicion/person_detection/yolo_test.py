from ultralytics import YOLO
from pathlib import Path

MODEL_DIR = Path(__file__).parent  

# Load a COCO-pretrained YOLO11n model

model = YOLO(MODEL_DIR / "yolo26n-pose.pt")

# Run inference with the YOLO11n model on the 'bus.jpg' image
results = model.track(MODEL_DIR / "person.jpeg", stream=True, show=True, conf = 0.1)
#results = model.track(MODEL_DIR / "street_walking.mp4", stream=True, show=True, conf = 0.1, tracker="bytetrack.yaml")

for i, resul in enumerate(results):
    print(resul)    
    print("+++++++++++++++++++++++++++++++++++++")
    print(resul.keypoints)
    print("+++++++++++++++++++++++++++++++++++++")
    print(resul)
    input()
