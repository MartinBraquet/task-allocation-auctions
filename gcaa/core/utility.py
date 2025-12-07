import numpy as np

from gcaa.core.control import ComputeCommandParamsWithVelocity
from gcaa.tools.arrays import box


def CalcTaskUtility(agent_pos, agent_va, task_pos, task_vt,
                    task_tf, task_value, j,
                    prob_a_t, winners, lambda_, kdrag):
    """
    Direct translation of the MATLAB function:
    function [U] = CalcTaskUtility(...)
    """

    # MATLAB: prod_all = prod(1 - winners(:,j).*prob_a_t(:,j));
    prod_all = np.prod(1 - winners[:, j] * prob_a_t[:, j])

    # MATLAB: rt = task_value * (1 - prod_all);
    rt = task_value * (1 - prod_all)

    Rt = 0.0

    # MATLAB: assigned_agents = find(winners(:,j) == 1)';
    assigned_agents = np.where(winners[:, j] == 1)[0]

    # MATLAB: if isempty(assigned_agents), U = 0;
    if assigned_agents.size == 0:
        return 0.0

    # MATLAB loop over assigned agents
    for i in assigned_agents:
        # Call trajectory cost integrator
        _, _, _, _, rho = ComputeCommandParamsWithVelocity(
            agent_pos[i, :].reshape(2, 1),
            agent_va[i, :].reshape(2, 1),
            task_pos.reshape(2, 1),
            task_vt.reshape(2, 1),
            task_tf,
            [],  # MATLAB empty array
            kdrag
        )
        Rt += rho

    # MATLAB: U = rt - lambda * Rt;
    U = rt - lambda_ * Rt

    return U


def CalcUtility(agent_pos, agent_va, task_pos, task_v, task_type, task_radius,
                task_tloiter, task_tf, task_value, b, i, prob_a_t, N, winners,
                lambda_, kdrag):
    """
    Compute total utility for agent i given its candidate task(s) b.

    Parameters
    ----------
    agent_pos : np.ndarray (2,)
    agent_va : np.ndarray (2,)
    task_pos : np.ndarray (M,2)
    task_v : np.ndarray (M,2)
    task_type, task_radius, task_tloiter, task_tf, task_value : np.ndarray (M,)
    b : list or array
        Candidate task indices for the agent
    i : int
        Agent index (0-based)
    prob_a_t : np.ndarray (N,M)
    winners : np.ndarray (N,M)
    N : int
        Number of agents
    lambda_ : float
    kdrag : float

    Returns
    -------
    rin : np.ndarray (2,)
        Reference position for the last task
    vt : np.ndarray (2,)
        Reference velocity for the last task
    U : float
        Total utility for this sequence of tasks
    """
    U = 0
    old_tf = 0
    rin = np.zeros(2)
    vt = np.zeros(2)
    b = box(b)

    # Reject sequences where two consecutive tasks have same end time
    if len(b) > 1:
        for j_idx in range(1, len(b)):
            if task_tf[b[j_idx]] == task_tf[b[j_idx - 1]]:
                return rin, vt, 0.0

    for j in b:
        rin, vt, dU = compute_dU(
            winners, j, agent_pos, agent_va, task_pos,
            task_v,
            task_type, task_radius, task_tloiter, task_tf,
            task_value, i, prob_a_t, N, lambda_, old_tf,
            kdrag
        )
        U += dU
        old_tf += task_tf[j] - old_tf  # update for next iteration

    return rin, vt, U


def compute_dU(allocations, j, agent_pos, agent_va, task_pos, task_v, task_type,
               task_radius, task_tloiter, task_tf, task_value, i, prob_a_t, N,
               lambda_, old_tf, kdrag):
    # Compute reward difference
    other_agents = [x for x in range(N) if x != i]
    prod_others = np.prod(
        1 - allocations[other_agents, j] * prob_a_t[other_agents, j])
    r_without_a = task_value[j] * (1 - prod_others)
    r_with_a = task_value[j] * (1 - prod_others * (1 - prob_a_t[i, j]))

    tf = task_tf[j] - old_tf

    if task_type[j] == 0:  # regular task
        _, _, _, _, rho = ComputeCommandParamsWithVelocity(
            agent_pos, agent_va,
            task_pos[j], task_v[j],
            tf, None, kdrag
        )
        rin = task_pos[j]
        vt = task_v[j]
    else:  # loitering task
        rin, vt, rho = MinimumCostAlongLoitering(
            agent_pos, agent_va, task_pos,
            task_radius, task_tloiter,
            task_tf, j, kdrag
        )

    dU = (r_with_a - r_without_a) - lambda_ * rho
    return rin, vt, dU


def MinimumCostAlongLoitering(agent_pos, agent_va, task_pos, task_radius,
                              task_tloiter, task_tf, j, kdrag):
    norm_vt = 2 * np.pi * task_radius[j] / task_tloiter[j]
    rho = 1e16
    rin_opt = None
    vt_opt = None

    for theta in np.linspace(0.05, 2 * np.pi * 0.9, 10):
        rin_new = task_pos[j] + task_radius[j] * np.array(
            [np.cos(theta), np.sin(theta)])
        for rot_turn in [-1, 1]:
            vt_new = rot_turn * np.array([[0, 1], [-1, 0]]) @ (
                rin_new - task_pos[j]) * norm_vt / np.linalg.norm(
                rin_new - task_pos[j])
            u, _, _, _, rho_new = ComputeCommandParamsWithVelocity(
                agent_pos,
                agent_va,
                rin_new,
                vt_new,
                task_tf[j] - task_tloiter[j],
                None,
                kdrag
            )
            if rho_new < rho:
                rho = rho_new
                rin_opt = rin_new
                vt_opt = vt_new

    # Add loitering cost
    norm_a = np.linalg.norm(vt_opt) ** 2 / task_radius[j]
    rho += 0.5 * (norm_a ** 2) * task_tloiter[j]

    return rin_opt, vt_opt, rho
