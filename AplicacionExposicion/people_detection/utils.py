
import math
import time
import cv2
from dataclasses import dataclass
import statistics
from torch import Tensor

# Local imports
from people_detection.config import DetectionConfig, DETECTION_LEVELS

def middle_point(points: list[list[int]]) -> tuple[int, int]:
    if len(points) == 0: return None
    if len(points) == 1: return points[0]
    return [sum([p[0] for p in points]) / len(points), sum([p[1] for p in points]) / len(points)]
    #return [(points[0][0] + points[1][0]) / 2, (points[0][1] + points[1][1]) / 2] 

def calculateHeight(keypoints: list[list[float]], conf:list[float],  config: DetectionConfig) -> float | None:
    conf_bool: list[bool] = [x > config.keypoint_confidence for x in conf]
    scalated_values : list[float]= list()
    for name, p1_indexes, p2_indexes in DETECTION_LEVELS:
        factor = config.scaling_factors[name]
        p1 = middle_point([keypoints[i.value] for i in p1_indexes if conf_bool[i.value]])
        p2 = middle_point([keypoints[i.value] for i in p2_indexes if conf_bool[i.value]])

        if p1 is not None and p2 is not None:            
            scalated_values.append(math.dist(p1, p2) * factor)

    return statistics.median(scalated_values) if len(scalated_values) > 0  else None


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

@dataclass
class Detection:
    box: Tensor
    keypoints : list[list[float]]
    height: float | None = None

if __name__ == "__main__":
    #test_keypoints = [[147, 136], [145, 133], [147, 133], [134, 134], [148, 134], [124, 151], [154, 153], [117, 176], [159, 179], [120, 193], [159, 198], [127, 198], [148, 199], [124, 232], [147, 233], [123, 264], [144, 269]]
    # test_keypoints = [[147.6886749267578, 136.1213836669922], [145.57217407226562, 133.49203491210938], [147.82275390625, 133.49005126953125], [134.4085693359375, 134.40216064453125], [148.25918579101562, 134.9506072998047], [124.36705017089844, 151.7210235595703], [154.5889129638672, 153.3213653564453], [117.6448745727539, 176.6103973388672], [159.687255859375, 179.4474334716797], [120.05924224853516, 193.50595092773438], [159.29505920410156, 198.2004852294922], [127.79393768310547, 198.81988525390625], [148.35316467285156, 199.6105499267578], [124.43600463867188, 232.66954040527344], [147.2120819091797, 233.94400024414062], [123.37853240966797, 264.82440185546875], [144.04010009765625, 269.6674499511719]]
    test_keypoints =[[184.0959,  56.0840],
         [194.6167,  44.7845],
         [175.1545,  49.5039],
         [219.6753,  49.8614],
         [170.2520,  59.9684],
         [254.2164, 115.4710],
         [161.6452, 118.6045],
         [280.0964, 192.0184],
         [115.7494, 166.7796],
         [245.2537, 257.4726],
         [147.2064, 112.3354],
         [229.5927, 282.0424],
         [168.2084, 281.7830],
         [235.9875, 399.8739],
         [164.0824, 397.5595],
         [243.3983, 500.7520],
         [175.7904, 501.1375]]
    test_conf = [0.9978, 0.9991, 0.9819, 0.9882, 0.1985, 0.9977, 0.9991, 0.9848, 0.9930, 0.9958, 0.9920, 0.9988, 0.9990, 0.9983, 0.9986, 0.8379, 0.8712]
    test_result = calculateHeight(test_keypoints, test_conf)
    print(test_result)
