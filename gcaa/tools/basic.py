from collections import defaultdict

import numpy as np
import torch


class PrettyDict(dict):
    def __repr__(self):
        return ', '.join([f"{k}={v:.1f}" for k, v in self.items()])


def dict_factory():
    return defaultdict(dict_factory)


def check_nan(data):
    """
    >>> check_nan(torch.Tensor([1, 2, 3]))
    >>> check_nan(np.array([1, 2, 3]))
    >>> check_nan(None)
    >>> check_nan(torch.Tensor([1, float('nan'), 3]))
    Traceback (most recent call last):
       ...
    RuntimeError: NaN detected in: tensor([1., nan, 3.])
    >>> check_nan(np.array([1, float('nan'), 3]))
    Traceback (most recent call last):
       ...
    RuntimeError: NaN detected in: [ 1. nan  3.]
    """
    if data is None:
        return
    if isinstance(data, torch.Tensor) and not torch.isnan(data).any():
        return
    if isinstance(data, np.ndarray) and not np.isnan(data).any():
        return
    raise RuntimeError(f"NaN detected in: {data}")
