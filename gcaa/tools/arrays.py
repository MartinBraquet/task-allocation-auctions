import numpy as np


def box(x):
    if isinstance(x, list):
        return x
    return [x]


def unbox(x):
    if isinstance(x, list) and len(x) == 1:
        x = x[0]
    return x


def array2string(arr):
    formatter = {'float_kind': lambda x: f"{x:.2f}"}
    return np.array2string(
        arr,
        formatter=formatter  # noqa
    )
