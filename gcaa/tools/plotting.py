import matplotlib.pyplot as plt
import numpy as np


def plotMapAllocation(X, n_rounds, na, colors, name):
    """
    Plot agent trajectories from X.

    Parameters
    ----------
    X : ndarray
        3D array of shape (4, na, n_rounds+1) containing [x, y, vx, vy] for each agent over time.
    n_rounds : int
        Number of simulation rounds.
    na : int
        Number of agents.
    colors : ndarray
        Array of shape (na, 3) with RGB colors for each agent.
    name : str
        Label for the plotted trajectories.
    """
    for i in range(na):
        # Extract trajectory: X[0,:] = x positions, X[1,:] = y positions
        xx = X[:, i, :].reshape(4, n_rounds + 1)
        plt.plot(
            xx[0, :],
            xx[1, :],
            ':',
            color=colors[i % len(colors)],
            linewidth=2,
            label=name
        )


def PlotAgentRange(pos_a, comm_distance, color, name):
    n = 50
    theta = np.linspace(0, 2 * np.pi, n)

    for i in range(pos_a.shape[0]):
        # circle points
        dx = comm_distance * np.cos(theta)
        dy = comm_distance * np.sin(theta)
        pos = np.column_stack((pos_a[i, 0] + dx, pos_a[i, 1] + dy))

        plt.plot(pos[:, 0], pos[:, 1], '--',
                 color=color[i],
                 linewidth=1,
                 alpha=0.3,
                 label=name)
