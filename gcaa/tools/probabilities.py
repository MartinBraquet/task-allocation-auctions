import random

import numpy as np
import torch

from squadro.tools.constants import EPS


def set_seed(seed=0):
    random.seed(seed)
    np.random.seed(seed)
    torch.random.manual_seed(seed)


def get_random_index(probs: np.ndarray):
    """
    Get a random index from a probability distribution

    >>> get_random_index(np.array([1, 0]))
    np.int64(0)

    >>> get_random_index(np.array([0, 1]))
    np.int64(1)

    >>> np.random.seed(0)
    >>> get_random_index(np.array([.01] * 100))
    np.int64(52)
    """
    probs = probs.astype(np.float64)
    probs /= np.sum(probs)
    samples = np.random.multinomial(1, probs)
    index = np.where(samples == 1)[0][0]
    return index


def get_entropy(probs: np.ndarray | torch.Tensor):
    """
    Get the entropy of a probability distribution

    >>> np.testing.assert_almost_equal(get_entropy(np.array([1, 0])), 0.)
    >>> np.testing.assert_almost_equal(get_entropy(np.array([1/2, 1/2])), np.log(2))
    """
    if isinstance(probs, torch.Tensor):
        return - torch.sum(probs * torch.log(probs + EPS), dim=-1)
    if isinstance(probs, list):
        probs = np.array(probs)
    return np.sum(- probs * np.log(probs + EPS))


def categorical_cross_entropy(y_pred, y_true):
    y_pred = torch.clamp(y_pred, EPS, 1 - EPS)
    y_true = torch.clamp(y_true, EPS, 1 - EPS)
    return (y_true * torch.log(y_true / y_pred)).sum(dim=1).mean()
