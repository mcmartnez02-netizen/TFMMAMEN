from ultralytics import YOLO


token = {
	"session_token": "QUM4Zm9rUWlGX0Vtcm5GVVFNN2F4T2YxeGp4YnxBR3JiS2FrSW1Na0hqVUE3M08xZERqTG9kdy1hQ1hfU2RLWTNwbW4zMkxMVFU0WWNlRDRvRUlCb3NUMEpha3JkRFhtaTNGYnZnUUZNRmxHUU1SSlVieVdYRmlVUFdmSU1acVk="
}
# Load a COCO-pretrained YOLO11n model
model = YOLO("yolo11n-pose.pt")


# Run inference with the YOLO11n model on the 'bus.jpg' image
results = model.predict("street_walking.mp4", stream=True, show=True)

for i, resul in enumerate(results):
    print(resul)
    print("+++++++++++++++++++++++++++++++++++++")

