import numpy as np


def remove_completed_tasks(pos_t: np.ndarray, ind):
    """
    pos_t: (nt, 2) array of task positions
    ind: list/array of completed task indices (1-based in MATLAB)
    """

    # Convert MATLAB's 1-based indices → Python 0-based
    ind_set = {ind}

    # Keep only rows whose index is NOT in ind_set
    mask = [i not in ind_set for i in range(pos_t.shape[0])]
    pos_t_new = pos_t[mask, :]

    return pos_t_new


def update_path(p, pos_a, pos_t, time_step, agents, nt):
    """
    p: list of lists of task indices (0-based)
    pos_a: (na, 2) agent positions
    pos_t: (nt, 2) task positions
    agents: object with Speed and Lt fields
    nt: number of remaining tasks
    """

    ind_completed_tasks = []

    for i in range(pos_a.shape[0]):

        if len(p[i]) == 0:
            continue  # no remaining tasks for agent i

        # Next task index (Python 0-based)
        task_idx = p[i][0]

        d_a_t = pos_t[task_idx] - pos_a[i]
        dist = np.linalg.norm(d_a_t)

        # Can agent reach this task within this timestep?
        if dist < time_step * agents.Speed[i]:

            # Snap agent to task
            pos_a[i] = pos_t[task_idx]

            nt -= 1
            agents.Lt[i] -= 1

            # Record completed task
            ind_completed_tasks.append(p[i][0])

            # Remove completed task from path
            p[i] = p[i][1:]

        else:
            # Move agent toward task
            direction = d_a_t / dist
            pos_a[i] = pos_a[i] + direction * time_step * agents.Speed[i]

    return p, pos_a, ind_completed_tasks, nt, agents
