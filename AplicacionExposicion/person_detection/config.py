from pathlib import Path
import tomllib

CONFIG_FILE = Path(__file__).parent.parent / "pyproject.toml"

SCALING_FACTORS = ["nose_ankles",
                   "nose_hips",
                   "shoulders_hips",
                   "nose_shoulders",
                   "eyes",
                   ]

class DetectionConfig:
    _INSTANCE = None
    _INSTANCIATED: bool = False

    near_height: float
    far_height: float
    person_confidence: float
    keypoint_confidence: float
    scaling_factors: dict[str, float]

    def __new__(cls):
        if cls._INSTANCE is None:            
            cls._INSTANCE = super().__new__(cls)
        return cls._INSTANCE


    def __init__(self, config_path: Path = CONFIG_FILE):

        if not self._INSTANCIATED:
            with open(config_path, "rb") as fl:
                config = tomllib.load(fl)["detection"]           

            factors:dict = config["scaling_factors"]
            assert SCALING_FACTORS, factors.keys()
            self.scaling_factors = {}
            for k, v in factors.items():
                self.scaling_factors[k] = float(v)

            self.near_height = float(config["near_height"])
            self.far_height  = float(config["far_height"])
            self.person_confidence = float(config["confidence_threshold"])
            self.keypoint_confidence  = float(config["confidence_keypoint"])



if __name__ == "__main__":
    a = DetectionConfig()
    print(a.near_height)
    print(a.far_height)
    print(a.person_confidence)
    print(a.keypoint_confidence)
    print(a.scaling_factors)
    b = DetectionConfig()
    print(a is b)
