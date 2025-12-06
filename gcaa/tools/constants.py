import sys
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path

import gcaa

EPS = 1e-12


@dataclass
class DefaultParams:
    time_out = 3600.0

    def __str__(self):
        return str(self.__dict__)

    @classmethod
    def attributes(cls):
        return {
            k: getattr(cls, k)
            for k in dir(cls)
            if not k.startswith('_') and not callable(getattr(cls, k))
        }

    @classmethod
    def print(cls):
        print(cls.attributes())

    @classmethod
    @contextmanager
    def update(cls, **kwargs):
        old = cls.attributes()
        for key, value in kwargs.items():
            setattr(cls, key, value)
        try:
            yield
        finally:
            for key, value in old.items():
                setattr(cls, key, value)


RESOURCE_PATH = Path(gcaa.__file__).parent / 'resources'
DATA_PATH = Path(gcaa.__file__).parent / 'data'
MAX_INT = sys.maxsize
inf = float("inf")
