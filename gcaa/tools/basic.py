from collections import defaultdict

import numpy as np

class PrettyDict(dict):
    def __repr__(self):
        return ', '.join([f"{k}={v:.1f}" for k, v in self.items()])

    def __getattr__(self, item):
        return self[item]

    def __setattr__(self, key, value):
        self[key] = value

    def copy(self):
        return PrettyDict(self)


def dict_factory():
    return defaultdict(dict_factory)


def check_nan(data):
    """
    >>> check_nan(None)
    >>> check_nan(np.array([1, 2, 3]))
    >>> check_nan(np.array([1, float('nan'), 3]))
    Traceback (most recent call last):
       ...
    RuntimeError: NaN detected in: [ 1. nan  3.]
    """
    if data is None:
        return
    if isinstance(data, np.ndarray) and not np.isnan(data).any():
        return
    raise RuntimeError(f"NaN detected in: {data}")
