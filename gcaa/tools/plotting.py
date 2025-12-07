import matplotlib.pyplot as plt


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
        plt.plot(xx[0, :], xx[1, :], ':', color=colors[i], linewidth=2,
                 label=name)
