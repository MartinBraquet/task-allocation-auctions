import builtins
import sys
from types import SimpleNamespace

from gcaa.tools import hardware


def test_get_cpu_info_with_cpuinfo(monkeypatch):
    # fake cpuinfo module
    monkeypatch.setitem(sys.modules, "cpuinfo", SimpleNamespace(
        get_cpu_info=lambda: {"brand_raw": "Intel Xeon"}))

    def fake_cpu_count(logical=True):
        return 8 if logical else 4

    monkeypatch.setattr("gcaa.tools.hardware.psutil.cpu_count", fake_cpu_count)
    res = hardware.get_cpu_info()
    assert "Intel Xeon" in res
    assert "(4 cores, 8 threads)" in res

    hardware.get_os_info()
    hardware.get_python_info()


def test_get_cpu_info_without_cpuinfo_prints_note(monkeypatch, capsys):
    # force ImportError for cpuinfo only
    real_import = builtins.__import__

    def fake_import(name, globals=None, locals=None, fromlist=(), level=0):
        if name == "cpuinfo":
            raise ImportError("no cpuinfo")
        return real_import(name, globals, locals, fromlist, level)

    monkeypatch.setattr(builtins, "__import__", fake_import)
    # ensure cpu counts deterministic
    monkeypatch.setattr("gcaa.tools.hardware.psutil.cpu_count",
                        lambda logical=True: 1 if logical else 1)
    monkeypatch.setattr("gcaa.tools.hardware.platform.processor",
                        lambda: "PlatCPU")
    res = hardware.get_cpu_info()
    captured = capsys.readouterr()
    assert "pip install py-cpuinfo" in captured.out or "py-cpuinfo" in captured.out
    assert "PlatCPU" in res


def test_get_ram_info(monkeypatch):
    monkeypatch.setattr("gcaa.tools.hardware.psutil.virtual_memory",
                        lambda: SimpleNamespace(total=8 * 1024 ** 3))
    assert hardware.get_ram_info() == "8.0 GB RAM"


def test_get_gpu_info_success(monkeypatch):
    def fake_run(*a, **k):
        return SimpleNamespace(stdout="GeForce RTX 3080, 10240 MiB, 470.57\n")

    monkeypatch.setattr("gcaa.tools.hardware.subprocess.run", fake_run)
    out = hardware.get_gpu_info()
    assert "GeForce RTX 3080" in out
    assert "10240 MiB" in out
    assert "Driver 470.57" in out


def test_get_gpu_info_failure(monkeypatch):
    monkeypatch.setattr("gcaa.tools.hardware.subprocess.run",
                        lambda *a, **k: (_ for _ in ()).throw(
                            Exception("no nvidia")))
    assert hardware.get_gpu_info() == "No NVIDIA GPU detected"


def test_get_library_versions(monkeypatch):
    # provide numpy and torch, leave tensorflow absent
    monkeypatch.setitem(sys.modules, "numpy",
                        SimpleNamespace(__version__="1.21.0"))
    monkeypatch.setitem(sys.modules, "torch",
                        SimpleNamespace(__version__="1.9.0"))
    sys.modules.pop("tensorflow", None)
    libs = hardware.get_library_versions()
    assert libs["numpy"] == "1.21.0"
    assert libs["torch"] == "1.9.0"
    assert libs["tensorflow"] == "Not installed"


def test_get_system_report_aggregates(monkeypatch):
    monkeypatch.setattr("gcaa.tools.hardware.get_cpu_info", lambda: "CPUX")
    monkeypatch.setattr("gcaa.tools.hardware.get_gpu_info", lambda: "GPUX")
    monkeypatch.setattr("gcaa.tools.hardware.get_ram_info", lambda: "RAMX")
    monkeypatch.setattr("gcaa.tools.hardware.get_os_info", lambda: "OSX")
    monkeypatch.setattr("gcaa.tools.hardware.get_python_info", lambda: "PyX")
    monkeypatch.setattr("gcaa.tools.hardware.get_library_versions",
                        lambda: {"numpy": "v"})
    rpt = hardware.get_system_report()
    assert rpt == {
        "CPU": "CPUX",
        "GPU": "GPUX",
        "RAM": "RAMX",
        "OS": "OSX",
        "Python": "PyX",
        "Libraries": {"numpy": "v"},
    }
