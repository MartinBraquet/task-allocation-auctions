import numpy as np

def winner_vector_to_matrix(N, M, winners):
    """
    Converts a winner vector to a matrix (0-based indexing).

    Parameters
    ----------
    N : int
        Number of agents
    M : int
        Number of tasks
    winners : array-like of int, shape (N,)
        Each entry is the index (0-based) of the task assigned to the agent,
        or -1 / None / 0 if no task is assigned.

    Returns
    -------
    winners_matrix : ndarray, shape (N, M)
        Binary matrix where winners_matrix[i,j] = 1 if agent i is assigned to task j.
    """
    winners_matrix = np.zeros((N, M), dtype=int)
    for i in range(N):
        task_id = winners[i]
        if task_id >= 0:
            winners_matrix[i, task_id] = 1
    return winners_matrix
