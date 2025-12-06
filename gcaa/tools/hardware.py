import platform
import subprocess

import psutil


def get_cpu_info():
    # CPU brand and speed (cross-platform)
    cpu = platform.processor() or "Unknown CPU"
    try:
        import cpuinfo
        cpu = cpuinfo.get_cpu_info()['brand_raw']
    except ImportError:
        print("Note: You can 'pip install py-cpuinfo' for better CPU info")
        pass

    # Core/thread info
    cores = psutil.cpu_count(logical=False) or 0
    threads = psutil.cpu_count(logical=True) or 0

    return f"{cpu} ({cores} cores, {threads} threads)"


def get_ram_info():
    mem = psutil.virtual_memory()
    total_gb = round(mem.total / (1024 ** 3), 2)
    return f"{total_gb} GB RAM"


def get_gpu_info():
    # Try NVIDIA first (requires nvidia-smi)
    try:
        result = subprocess.run(
            ["nvidia-smi", "--query-gpu=name,memory.total,driver_version", "--format=csv,noheader"],
            stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True, check=True
        )
        gpus = []
        for line in result.stdout.strip().splitlines():
            name, mem, driver = [x.strip() for x in line.split(",")]
            gpus.append(f"{name} ({mem} VRAM, Driver {driver})")
        return "; ".join(gpus)
    except Exception:
        return "No NVIDIA GPU detected"


def get_os_info():
    return f"{platform.system()} {platform.release()} ({platform.version()})"


def get_python_info():
    return f"Python {platform.python_version()} ({platform.python_implementation()})"


def get_library_versions():
    libs = {}
    for lib in ["numpy", "torch", "tensorflow"]:
        try:
            module = __import__(lib)
            libs[lib] = module.__version__
        except ImportError:
            libs[lib] = "Not installed"
    return libs


def get_system_report():
    report = {
        "CPU": get_cpu_info(),
        "GPU": get_gpu_info(),
        "RAM": get_ram_info(),
        "OS": get_os_info(),
        "Python": get_python_info(),
        "Libraries": get_library_versions(),
    }
    return report
