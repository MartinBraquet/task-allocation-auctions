function [rin, vt, U] = CalcUtility(agent_pos, agent_va, task_pos, task_v, task_type, task_radius, task_tloiter, task_tf, task_value, b, i, prob_a_t, N, winners, lambda, kdrag)
    U = 0;
    old_tf = 0;
       
    % No assignment if same end time for two tasks in the sequence
    for j = 1:length(b)
        if j ~= 1 && task_tf(b(j)) == task_tf(b(j-1))
            return;
        end
    end
    
%     winners_without_curr_agent = winners;
%     winners_without_curr_agent(i,:) = zeros(1,size(winners,2));
    
    for j = b
        [rin, vt, dU] = compute_dU(winners, j, agent_pos, agent_va, task_pos, task_v, task_type, task_radius, task_tloiter, task_tf, task_value, i, prob_a_t, N, lambda, old_tf, kdrag);
%         other_agents = find(winners(:,j)==1);
%         
%         for i in other_agents
%             dU_others(i) = compute_dU(winners_without_curr_agent);
%         end
%         dU_sum_others = sum(dU_others);
        
        U = U + dU;
    end
end

function [rin, vt, dU] = compute_dU(allocations, j, agent_pos, agent_va, task_pos, task_v, task_type, task_radius, task_tloiter, task_tf, task_value, i, prob_a_t, N, lambda, old_tf, kdrag)
    prod_others = prod(1 - allocations([1:(i-1) (i+1):N],j).*prob_a_t([1:(i-1) (i+1):N],j));
    r_without_a = task_value(j) * (1 - prod_others);
    r_with_a = task_value(j) * (1 - prod_others * (1 - prob_a_t(i,j)));

    tf = task_tf(j) - old_tf;
    old_tf = old_tf + tf;
    if task_type(j) == 0
        [~, ~, ~, ~, rho] = ComputeCommandParamsWithVelocity(agent_pos', agent_va', task_pos(j,:)', task_v(j,:)', tf, [], kdrag);
        rin = task_pos(j,:)';
        vt = task_v(j,:)';
    else
        [rin, vt, rho] = MinimumCostAlongLoitering(agent_pos, agent_va, task_pos, task_radius, task_tloiter, task_tf, j, kdrag);
    end

    dU = (r_with_a - r_without_a) - lambda * rho;
end

function [rin, vt, rho] = MinimumCostAlongLoitering(agent_pos, agent_va, task_pos, task_radius, task_tloiter, task_tf, j, kdrag)
    norm_vt = 2*pi * task_radius(j) / task_tloiter(j);
    rho = 1e16;
    for theta = linspace(0.05, 2*pi*0.9, 10)
        rin_new = task_pos(j,:)' + task_radius(j) * [cos(theta); sin(theta)];
        for rot_turn = [-1 1]
            vt_new = rot_turn * [0 1; -1 0] * (rin_new - task_pos(j,:)') * norm_vt / norm(rin_new - task_pos(j,:)');
            [u, ~, ~, ~, rho_new] = ComputeCommandParamsWithVelocity(agent_pos', agent_va', rin_new, vt_new, task_tf(j) - task_tloiter(j), [], kdrag);
            if rho_new < rho
                rho = rho_new;
                rin = rin_new;
                vt = vt_new;
                u_opt = u;
            end
        end
    end
    norm_a = norm(vt)^2 / task_radius(j);
    rho = rho + 1/2 * (norm_a)^2 * task_tloiter(j);
end
