import numpy as np

from gcaa.core.control import ComputeCommandParamsWithVelocity


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
