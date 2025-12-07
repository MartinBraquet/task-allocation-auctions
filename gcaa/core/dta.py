import time
from dataclasses import dataclass

import matplotlib.pyplot as plt
import numpy as np

from gcaa.core.control import ComputeCommandParamsWithVelocity, \
    OptimalControlSolution
from gcaa.core.utility import CalcTaskUtility
from gcaa.tools.plotting import plotMapAllocation


@dataclass
class Tasks:
    r_bar: np.ndarray
    prob_a_t: np.ndarray
    task_type: np.ndarray


@dataclass
class Agents:
    N: int
    Lt: np.ndarray
    v_a: np.ndarray
    previous_task: np.ndarray
    previous_winnerBids: np.ndarray
    rin_task: np.ndarray
    vin_task: np.ndarray
    kdrag: float


@dataclass
class SimuParams:
    n_rounds: int
    time_step: float
    map_width: float
    comm_distance: float
    simu_time: float
    colors: np.ndarray
    pos_a_init: np.ndarray
    max_speed: float
    v_a: np.ndarray
    pos_t: np.ndarray
    max_speed_task: float
    v_t: np.ndarray
    radius_t: np.ndarray
    task_type: np.ndarray
    nt_loiter: int
    na: int
    nt: int
    tf_t: np.ndarray
    tloiter_t: np.ndarray
    R: float
    r_nom: float
    r_bar: np.ndarray
    lambda_: float
    prob_a_t: np.ndarray
    kdrag: float


def remove_completed_tasks(pos_t: np.ndarray, ind):
    """
    pos_t: (nt, 2) array of task positions
    ind: list/array of completed task indices (1-based in MATLAB)
    """

    # Convert MATLAB's 1-based indices → Python 0-based
    ind_set = {i - 1 for i in ind}

    # Keep only rows whose index is NOT in ind_set
    mask = [i not in ind_set for i in range(pos_t.shape[0])]
    pos_t_new = pos_t[mask, :]

    return pos_t_new


def update_path(p, pos_a, pos_t, time_step, agents, nt):
    """
    p: list of lists of task indices (MATLAB 1-based)
    pos_a: (na, 2) agent positions
    pos_t: (nt, 2) task positions
    agents: object with Speed and Lt fields
    nt: number of remaining tasks
    """

    ind_completed_tasks = []

    for i in range(pos_a.shape[0]):

        if len(p[i]) == 0:
            continue  # no remaining tasks for agent i

        # Next task index (convert from MATLAB 1-based to Python 0-based)
        task_idx = p[i][0] - 1

        d_a_t = pos_t[task_idx] - pos_a[i]
        dist = np.linalg.norm(d_a_t)

        # Can agent reach this task within this timestep?
        if dist < time_step * agents.Speed[i]:

            # Snap agent to task
            pos_a[i] = pos_t[task_idx]

            nt -= 1
            agents.Lt[i] -= 1

            # Record completed task (keep MATLAB style index)
            ind_completed_tasks.append(p[i][0])

            # Remove completed task from path
            p[i] = p[i][1:]

        else:
            # Move agent toward task
            direction = d_a_t / dist
            pos_a[i] = pos_a[i] + direction * time_step * agents.Speed[i]

    return p, pos_a, ind_completed_tasks, nt, agents


def optimal_control_dta():
    """
    Optimal Control Dynamic Task Assignment (DTA)
    MATLAB equivalent: optimal_control_DTA.m
    """

    simu_number = 7
    simu_name = "Dynamics"

    use_GCAA = 0
    uniform_agents = 1
    uniform_tasks = 1
    plot_range = 0

    na = 5
    nt = 4
    n_rounds = 50

    Lt = 1
    nt_loiter = int(np.ceil(0.5 * nt))
    task_type = np.zeros(nt, dtype=int)
    task_type[:nt_loiter] = 1
    lambda_ = 1

    map_width = 1
    comm_distance = 0.5 * map_width

    simu_time = 10
    time_step = simu_time / n_rounds
    time_start = 0
    colors = np.random.rand(na, 3).tolist()

    # Random positions
    pos_a = (0.1 + 0.8 * np.random.rand(na, 2)) * map_width
    pos_t = (0.1 + 0.8 * np.random.rand(nt, 2)) * map_width

    # Task finish and loiter times
    tf_t = simu_time * np.ones(nt) # * (0.95 + 0.05 * np.random.rand(nt))
    tloiter_t = simu_time * (0.2 + 0.05 * np.random.rand(nt))
    tloiter_t[task_type == 0] = 0

    # Sort tasks by finishing time
    idx = np.argsort(tf_t)
    tf_t = tf_t[idx]
    pos_t = pos_t[idx, :]
    pos_t_initial = pos_t.copy()

    # Drag coefficient
    kdrag = 3 / simu_time

    # Agent velocities
    max_speed = 0.1
    if uniform_agents:
        v_a = np.zeros((na, 2))
    else:
        v_a = (2 * np.random.rand(na, 2) - 1) * max_speed

    # Task velocities
    max_speed_task = 0.1
    if uniform_tasks:
        v_t = np.zeros((nt, 2))
    else:
        v_t = (2 * np.random.rand(nt, 2) - 1) * max_speed_task

    # Task radii
    R = 0.04 * map_width
    if uniform_tasks:
        radius_t = R * np.ones(nt)
    else:
        radius_t = (0.2 * np.random.rand(nt) + 1) * R

    # Reward after task completion
    r_nom = 0.2
    if uniform_tasks:
        r_bar = r_nom * np.ones(nt)
    else:
        r_bar = r_nom * np.random.rand(nt)

    r_bar[task_type == 1] = 5 * r_bar[task_type == 1]

    # Probability of agent completing task
    if uniform_agents:
        prob_a_t = 0.7 * np.ones((na, nt))
    else:
        prob_a_t = np.random.rand(na, nt)

    # ----------------------------
    # Create Task and Agent objects
    # ----------------------------

    tasks = Tasks(
        r_bar=r_bar,
        prob_a_t=prob_a_t,
        task_type=task_type
    )

    agents = Agents(
        N=na,
        Lt=Lt * np.ones(na),
        v_a=v_a,
        previous_task=np.zeros(na, dtype=int),
        previous_winnerBids=np.zeros(na, dtype=int),
        rin_task=np.zeros((na, 2)),
        vin_task=np.zeros((na, 2)),
        kdrag=kdrag
    )

    # ----------------------------
    # Simulation parameters object
    # ----------------------------

    # You had a variable “colors” in MATLAB but never defined it.
    # You must define it externally before passing it here.

    SimuParamsObj = SimuParams(
        n_rounds=n_rounds,
        time_step=time_step,
        map_width=map_width,
        comm_distance=comm_distance,
        simu_time=simu_time,
        colors=colors,
        pos_a_init=pos_a,
        max_speed=max_speed,
        v_a=v_a,
        pos_t=pos_t,
        max_speed_task=max_speed_task,
        v_t=v_t,
        radius_t=radius_t,
        task_type=task_type,
        nt_loiter=nt_loiter,
        na=na,
        nt=nt,
        tf_t=tf_t,
        tloiter_t=tloiter_t,
        R=R,
        r_nom=r_nom,
        r_bar=r_bar,
        lambda_=lambda_,
        prob_a_t=prob_a_t,
        kdrag=kdrag
    )

    for CommLimit in (0,):

        # Clear / reset variables used in loop
        J = None
        J_to_completion_target = None
        X_full_simu = None
        p_GCAA_full_simu = None
        S_GCAA_ALL = None
        X = None

        n_rounds_loop = n_rounds
        simu_time_loop = simu_time
        time_start_loop = time_start
        tf_t_loop = tf_t.copy()
        pos_a_loop = pos_a.copy()
        v_a_loop = v_a.copy()

        U_next_tot = np.zeros(n_rounds)
        U_tot = np.zeros(n_rounds)
        U_completed_tot = 0.0

        completed_tasks_round = []
        completed_tasks = []
        rt_completed = 0.0

        # Preallocate lists (MATLAB cell arrays)
        X_full_simu = [None] * n_rounds
        p_GCAA_full_simu = [None] * n_rounds

        S_GCAA_ALL_full_simu = np.zeros((n_rounds, nt))
        rt_full_simu = np.zeros((n_rounds, nt))

        J = np.zeros(
            (n_rounds, na))  # MATLAB had n_rounds x na (indexing shifted)
        J_to_completion_target = np.zeros((n_rounds, na))

        # cost/reward/utility arrays reused each round
        costs = np.zeros((na, nt))
        rewards = np.zeros((na, nt))
        utility = np.zeros((na, nt))

        # Fully connected graph initially (no self links)
        G = ~np.eye(na, dtype=bool)

        for i_round in range(n_rounds):  # corresponds to MATLAB 1:n_rounds

            plt.clf()
            plt.xlim(0, map_width)
            plt.ylim(0, map_width)
            plt.xlabel("x [m]")
            plt.ylabel("y [m]")
            plt.title("Task-Agent allocation")

            # plot agents
            for i in range(na):
                c = colors[i]
                plt.plot(pos_a_loop[i, 0], pos_a_loop[i, 1], marker='*',
                         markersize=10,
                         label='agents' if i == 0 else "", color=c)

            # plot tasks
            plt.plot(pos_t[:, 0], pos_t[:, 1], 'rs', markersize=10,
                     label='Targets', markerfacecolor=(1, 0.6, 0.6))

            # if plot_range:
                # external function; kept as-is
                # PlotAgentRange(pos_a_loop, comm_distance, colors, "Comm Range")

            # external plotting for loitering
            # PlotTaskLoitering(pos_t, radius_t, Tasks.task_type, 'r--',
            #                   'Task loitering')

            # Update agents and Tasks objects used by algorithms
            agents.Pos = pos_a_loop
            agents.v_a = v_a_loop

            tasks.Pos = pos_t
            tasks.Speed = v_t
            tasks.N = nt
            tasks.tf = tf_t_loop
            tasks.lambda_ = lambda_
            tasks.task_type = task_type
            tasks.tloiter = tloiter_t
            tasks.radius = radius_t

            # Compute costs / rewards / utilities for each agent-task pair (active tasks)
            for j in range(nt):
                if tf_t_loop[j] > 0:
                    for i in range(na):
                        # Keep parameter order identical to MATLAB call; pass None for the '[]' arg
                        _, _, _, _, costs[i, j] = ComputeCommandParamsWithVelocity(
                            pos_a_loop[i, :].reshape(2, 1),
                            v_a_loop[i, :].reshape(2, 1),
                            pos_t[j, :].reshape(2, 1),
                            v_t[j, :].reshape(2, 1),
                            tf_t_loop[j],
                            None,
                            kdrag
                        )
                        rewards[i, j] = r_bar[j] * prob_a_t[i, j]

                        winners = np.zeros((na, nt), dtype=int)
                        winners[i, j] = 1

                        utility[i, j] = CalcTaskUtility(
                            pos_a_loop, v_a_loop, pos_t[j, :], v_t[j, :],
                            tf_t_loop[j], r_bar[j], j, prob_a_t, winners,
                            lambda_, kdrag
                        )

            # Communication graph update if CommLimit active
            if CommLimit:
                for i in range(na):
                    for j in range(i + 1, na):
                        connected = np.linalg.norm(
                            pos_a_loop[i, :] - pos_a_loop[j, :]) < comm_distance
                        G[i, j] = connected
                        G[j, i] = connected

            # Solve allocation with chosen method(s)
            if use_GCAA:
                t0 = time.perf_counter()
                S_GCAA, p_GCAA, S_GCAA_ALL, rt_curr, agents = GCAASolution(
                    agents, G, tasks)
                rt_full_simu[i_round, :] = rt_curr
                t1 = time.perf_counter()
                print(f"GCAASolution round {i_round+1} took {t1-t0:.2f}s")
            else:
                # test fixed task allocation
                p_GCAA = [[0], [1], [3], [1], [2]][:na]
                S_GCAA = 1
                S_GCAA_ALL = np.zeros(nt)
                rt_curr = np.zeros(nt)
                for i in range(na):
                    task_index = p_GCAA[i][0]  # first task for agent i
                    agents.rin_task[i, :] = pos_t[task_index, :]

            U_next_tot[i_round] = S_GCAA
            U_tot[i_round] = U_next_tot[i_round] + U_completed_tot

            # Find the optimal control trajectory for the allocation p_GCAA
            X, completed_tasks_round, J_curr, J_to_completion_target[
                i_round] = OptimalControlSolution(
                pos_a_loop, v_a_loop, pos_t, v_t, radius_t, p_GCAA, agents,
                tf_t_loop,
                tloiter_t, time_step, n_rounds_loop, na, kdrag
            )

            X_full_simu[i_round] = X
            p_GCAA_full_simu[i_round] = p_GCAA
            S_GCAA_ALL_full_simu[i_round, :] = S_GCAA_ALL

            # MATLAB did J(i_round+1,:) = J(i_round,:) + J_curr
            # We emulate that shift: J row i_round accumulates previous J row (if i_round>0)
            if i_round == 0:
                J[i_round, :] = J_curr
            else:
                J[i_round, :] = J[i_round - 1, :] + J_curr

            # plot map allocation
            plotMapAllocation(X, n_rounds_loop, na, colors, "GCAA solution")

            # accumulate completed tasks reward-time if any
            for j in completed_tasks_round:
                # j are MATLAB-style 1-based indices in the returned list (kept from earlier functions)
                j0 = j - 1
                rt_completed += rt_curr[j0]

            # reset for next round (as in MATLAB)
            completed_tasks_round = []

            # unique legend and draw
            plt.legend()
            plt.draw()
            plt.pause(0.001)

            # Update agent positions and velocities from X:
            # MATLAB used: pos_a_loop = X(1:2,:,2)'; v_a_loop = X(3:4,:,2)';
            # Assuming X is a numpy array shaped (4, na, n_horizon) and MATLAB-like indexing:
            # take timestep index 1 (MATLAB 2) -> Python index 1
            try:
                pos_a_loop = X[0:2, :, 1].T.copy()
                v_a_loop = X[2:4, :, 1].T.copy()
            except Exception:
                # If X has a different structure, this may raise; keep consistent with MATLAB intent.
                raise

            # Update remaining time / rounds / task times
            simu_time_loop -= time_step
            time_start_loop += time_step
            n_rounds_loop -= 1
            tf_t_loop = tf_t_loop - time_step

        U_tot_final = rt_completed - np.sum(J[-1, :])
        print("U_tot_final:", U_tot_final)

    print("Simulation finished successfully.")


if __name__ == "__main__":
    optimal_control_dta()
