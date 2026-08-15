from enum import Enum
from collections import namedtuple
import math
import tomllib
from pathlib import Path
import statistics

CONFIG_FILE = Path(__file__).parent.parent / "pyproject.toml"

DetectionLevel = namedtuple("DetectionLevel", ["top_points", "bottom_points", "scaling_factor"])

class BodyPart(Enum):
    Nose = 0
    Left_Eye = 1
    Right_Eye = 2
    Left_Ear = 3
    Right_Ear = 4
    Left_Shoulder = 5
    Right_Shoulder = 6
    Left_Elbow = 7
    Right_Elbow = 8
    Left_Wrist = 9
    Right_Wrist = 10
    Left_Hip = 11
    Right_Hip = 12
    Left_Knee = 13
    Right_Knee = 14
    Left_Ankle = 15
    Right_Ankle = 16    


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

# TODO: Jugar con los factores de escalada para encontrar uno correcto
DETECTION_LEVELS: list[DetectionLevel] = [
    DetectionLevel([BodyPart.Nose], [BodyPart.Left_Ankle, BodyPart.Right_Ankle] ,  1.0),
    DetectionLevel([BodyPart.Nose], [BodyPart.Left_Hip, BodyPart.Right_Hip] ,  2),
    DetectionLevel([BodyPart.Left_Shoulder, BodyPart.Right_Shoulder], [BodyPart.Left_Hip, BodyPart.Right_Hip], 2.8),
    DetectionLevel([BodyPart.Nose] , [BodyPart.Left_Shoulder, BodyPart.Right_Shoulder], 7.3),
    DetectionLevel([BodyPart.Left_Eye], [BodyPart.Right_Eye], 65.375)
]

def middle_point(points: list[list[int]]) -> tuple[int, int]:
    if len(points) == 0 or len(points) > 2: return None
    if len(points) == 1: return points[0]
    return [(points[0][0] + points[1][0]) // 2, (points[0][1] + points[1][1]) // 2] 

CONF_THRESHOLD = None # Needs to be loaded from config when used frist time

def calculateHeight(keypoints: list[list[float]], conf:list[float]) -> float | None:
    global CONF_THRESHOLD

    if CONF_THRESHOLD == None:
        with open(CONFIG_FILE, mode="rb") as fp:
            config = tomllib.load(fp)
            CONF_THRESHOLD = float(config['detection']['confidence_keypoint'])

    conf_bool: list[bool] = [True if x > CONF_THRESHOLD else False for x in conf]
    scalated_values : list[float]= list()
    for i, value in enumerate(DETECTION_LEVELS):
        p1_indexes, p2_indexes, scalar_factor = value
        p1 = middle_point([keypoints[i.value] for i in p1_indexes if conf_bool[i.value]])
        p2 = middle_point([keypoints[i.value] for i in p2_indexes if conf_bool[i.value]])

        if p1 != None and p2 != None:            
            scalated_values.append(math.dist(p1, p2) * scalar_factor)

    return statistics.median(scalated_values) if len(scalated_values) > 0  else 0


if __name__ == "__main__":
    test_keypoints = [[147, 136], [145, 133], [147, 133], [134, 134], [148, 134], [124, 151], [154, 153], [117, 176], [159, 179], [120, 193], [159, 198], [127, 198], [148, 199], [124, 232], [147, 233], [123, 264], [144, 269]]
    calculateHeight(test_keypoints, [0.5,0.2,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.1])
