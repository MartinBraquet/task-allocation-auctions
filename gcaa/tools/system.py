import platform
import sys


def is_windows() -> bool:
    return sys.platform == "win32"


def is_linux() -> bool:
    return platform.system() == "Linux"
