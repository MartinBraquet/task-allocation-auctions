function [U] = CalcTaskUtility(agent_pos, agent_va, task_pos, task_tf, task_value, j, prob_a_t, winners, lambda)
    prod_all = prod(1 - winners(:,j).*prob_a_t(:,j));
    
    rt = task_value * (1 - prod_all);
    
    Rt = 0;
    
    assigned_agents = find(winners(:,j) == 1)';
    if isempty(assigned_agents)
        U = 0;
    else
        for i = assigned_agents
            [~, ~, rho] = ComputeCommandParams(agent_pos(i,:), agent_va(i,:), task_pos, task_tf);
            Rt = Rt + rho;
        end
        U = rt - lambda * Rt;
    end
end
