import functools
import logging
from collections import namedtuple
from dataclasses import dataclass
from enum import Enum
from pathlib import Path

import tomllib

DEFAULT_CONFIG_PATH = Path(__file__).parent.parent / "pyproject.toml"

logger = logging.getLogger()

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


DetectionLevel = namedtuple("DetectionLevel", ["name", "top_points", "bottom_points"])

DETECTION_LEVELS: list[DetectionLevel] = [
    DetectionLevel(
        "nose_ankles", [BodyPart.Nose], [BodyPart.Left_Ankle, BodyPart.Right_Ankle]
    ),
    DetectionLevel(
        "nose_hips", [BodyPart.Nose], [BodyPart.Left_Hip, BodyPart.Right_Hip]
    ),
    DetectionLevel(
        "shoulders_hips",
        [BodyPart.Left_Shoulder, BodyPart.Right_Shoulder],
        [BodyPart.Left_Hip, BodyPart.Right_Hip],
    ),
    DetectionLevel(
        "nose_shoulders",
        [BodyPart.Nose],
        [BodyPart.Left_Shoulder, BodyPart.Right_Shoulder],
    ),
    DetectionLevel("eyes", [BodyPart.Left_Eye], [BodyPart.Right_Eye]),
]

@dataclass(frozen=True)
class DetectionConfig:
    near_height: float
    far_height: float
    person_confidence: float
    keypoint_confidence: float
    time_no_presence: float
    max_fps: float
    scaling_factors: dict[str, float]    
    max_consecutive_erros: int = 0

@functools.cache
def load_detection_config(config_path: Path = DEFAULT_CONFIG_PATH) -> DetectionConfig:

    with open(config_path, "rb") as fl:
        config = tomllib.load(fl)["detection"]

    factors: dict = config["scaling_factors"]

    # Comprobación que todos los sacling factor requiridos están presentes.
    required = {level.name for level in DETECTION_LEVELS}
    present = factors.keys()
    if faltan := required - present:
        raise ValueError(
            f"Faltan factores de escala en {config_path}: {sorted(faltan)}"
        )
    if sobran := present - required:
        logger.warning(f"Ignored unknown factors: {sorted(sobran)}")

    scaling_factors = {}
    for k, v in factors.items():
        scaling_factors[k] = float(v)
        if v <= 0:
            logger.warning(
                f"The scaling factor for {k} is {v}. All scaling factors "
                + "have to be greater than zero in order to work properly. Please fix "
                + "this issue in the configuration section [detection.scaling_factors]."
            )

    near_height = float(config["near_height"])
    far_height = float(config["far_height"])
    person_confidence = float(config["confidence_threshold"])
    keypoint_confidence = float(config["confidence_keypoint"])
    time_no_presence = float(config["time_no_presence"])
    max_fps = float(config["max_fps"])
    max_consecutive_erros = int(config["max_consecutive_erros"])

    if near_height <= far_height:
        logger.warning(
            "near_height has to be greater than far_height, however right now near_height "
            + f"is {near_height!s} and far_height is {far_height!s}. It is advised to fix this "
            + "issue in the configuration, section [detection], in order for the program to work as intended."
        )

    return DetectionConfig(
        near_height,
        far_height,
        person_confidence,
        keypoint_confidence,
        time_no_presence,
        max_fps,        
        scaling_factors,
        max_consecutive_erros,
    )


if __name__ == "__main__":
    a = load_detection_config()
    print(a.near_height)
    print(a.far_height)
    print(a.person_confidence)
    print(a.keypoint_confidence)
    print(a.time_no_presence)
    print(a.scaling_factors)
    b = load_detection_config()
    print(a is b)
