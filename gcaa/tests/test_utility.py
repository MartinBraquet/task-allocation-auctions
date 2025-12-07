import numpy as np

from gcaa.core.utility import MinimumCostAlongLoitering


def test_minimum_cost_along_loitering_basic():
    agent_pos = np.array([0.0, 0.0])
    agent_va = np.array([0.0, 0.0])

    task_pos = np.array([
        [1.0, 1.0],
        [2.0, -1.0]
    ])

    task_radius = np.array([0.5, 1.0])
    task_tloiter = np.array([1.0, 2.0])
    task_tf = np.array([5.0, 10.0])
    kdrag = 0.1
    j = 0

    rin, vt, rho = MinimumCostAlongLoitering(
        agent_pos,
        agent_va,
        task_pos,
        task_radius,
        task_tloiter,
        task_tf,
        j,
        kdrag
    )

    assert rin.shape == (2,)
    assert vt.shape == (2,)
    assert np.isfinite(rho)
    assert rho > 0


def test_minimum_cost_monotonic_radius():
    agent_pos = np.array([0.0, 0.0])
    agent_va = np.array([0.0, 0.0])
    task_pos = np.array([[1.0, 0.0]])
    task_tloiter = np.array([1.0])
    task_tf = np.array([5.0])
    kdrag = 0.1
    j = 0

    r_small = np.array([0.2])
    r_large = np.array([2.0])

    _, _, rho_small = MinimumCostAlongLoitering(
        agent_pos, agent_va, task_pos,
        r_small, task_tloiter, task_tf, j, kdrag
    )
    _, _, rho_large = MinimumCostAlongLoitering(
        agent_pos, agent_va, task_pos,
        r_large, task_tloiter, task_tf, j, kdrag
    )

    # Larger radius → longer loiter → higher cost
    assert rho_large > rho_small


def test_minimum_cost_repeatability():
    # Ensure deterministic behavior (no randomness)
    agent_pos = np.array([0.0, 0.0])
    agent_va = np.array([0.0, 0.0])
    task_pos = np.array([[0.5, 0.8]])
    radius = np.array([1.0])
    tloiter = np.array([1.2])
    tf = np.array([4.0])
    j = 0
    kdrag = 0.2

    r1 = MinimumCostAlongLoitering(agent_pos, agent_va, task_pos,
                                   radius, tloiter, tf, j, kdrag)
    r2 = MinimumCostAlongLoitering(agent_pos, agent_va, task_pos,
                                   radius, tloiter, tf, j, kdrag)

    assert np.allclose(r1[0], r2[0])
    assert np.allclose(r1[1], r2[1])
    assert np.isclose(r1[2], r2[2])
