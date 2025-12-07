from pathlib import Path

from gcaa.tools.disk import mkdir

BASE_DIR = Path(__file__).parent
SIMU_DIR = BASE_DIR / "simulations"
mkdir(SIMU_DIR)