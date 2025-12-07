import numpy as np

def winner_vector_to_matrix(N, M, winners):
    winners_matrix = np.zeros((N, M), dtype=int)
    for i in range(N):
        w = winners[i]
        if w > 0:
            winners_matrix[i, w - 1] = 1
    return winners_matrix
