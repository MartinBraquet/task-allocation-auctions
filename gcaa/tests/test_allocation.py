import numpy as np

from gcaa.core.allocation import remove_completed_tasks, update_path


def test_remove_completed_tasks_single_index_removal():
    pos_t = np.array([
        [0.0, 0.0],  # 0
        [1.0, 1.0],  # 1
        [2.0, 2.0],  # 2
    ])

    # Current implementation treats 'ind' as a single 0-based index
    out = remove_completed_tasks(pos_t, 1)
    # Expect row index 1 removed
    expected = np.array([[0.0, 0.0], [2.0, 2.0]])
    assert np.array_equal(out, expected)

    # Index that doesn't match any (e.g., outside range) should keep mask true for all
    out2 = remove_completed_tasks(pos_t, 5)
    assert np.array_equal(out2, pos_t)


def test_update_path_completion_and_motion():
    # Two agents, three tasks
    pos_a = np.array([
        [0.0, 0.0],   # agent 0 near task 0
        [0.0, 0.0],   # agent 1 far from task 2
    ], dtype=float)

    pos_t = np.array([
        [0.05, 0.0],  # task 0 close to agent 0
        [1.0, 0.0],   # task 1 (unused)
        [1.0, 0.0],   # task 2 targeted by agent 1
    ], dtype=float)

    # Paths: agent 0 -> task 0, agent 1 -> task 2
    p = [[0], [2]]

    class AgentsStub:
        def __init__(self):
            self.Speed = np.array([1.0, 0.1])  # agent 0 fast, agent 1 slow
            self.Lt = np.array([1, 1])

    agents = AgentsStub()

    time_step = 0.1
    nt = 3

    p2, pos_a2, completed, nt2, agents2 = update_path(p, pos_a.copy(), pos_t, time_step, agents, nt)

    # Agent 0 should complete task 0 since dist=0.05 < time_step*Speed=0.1
    assert 0 in completed
    assert np.allclose(pos_a2[0], pos_t[0])
    assert p2[0] == []
    assert agents2.Lt[0] == 0

    # Agent 1 should move towards task 2 but not reach it
    # Initial dist is 1.0; step size is 0.1*0.1 = 0.01 along x-axis
    assert 2 not in completed
    assert np.allclose(pos_a2[1], [0.01, 0.0])
    assert p2[1] == [2]

    # nt reduced by number of completed tasks (1)
    assert nt2 == nt - 1
