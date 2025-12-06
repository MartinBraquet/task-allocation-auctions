from contextlib import contextmanager
from time import perf_counter


def pretty_print_time(seconds):
    # Calculate minutes and seconds
    minutes, secs = divmod(seconds, 60)
    # Format the time as mm:ss
    return f"{int(minutes):02d}:{int(secs):02d}"


@contextmanager
def timing(name="Block"):
    start = perf_counter()
    yield
    end = perf_counter()
    print(f"[{name}] took {end - start:.6f} seconds")
