function [U] = CalcUtility(agent_pos, agent_va, task_pos, task_v, task_type, task_radius, task_tloiter, task_tf, task_value, b, i, prob_a_t, N, winners, lambda)
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
        dU = compute_dU(winners);
        
%         other_agents = find(winners(:,j)==1);
%         
%         for i in other_agents
%             dU_others(i) = compute_dU(winners_without_curr_agent);
%         end
%         dU_sum_others = sum(dU_others);
        
        U = U + dU;
    end
    
    function dU = compute_dU(allocations)
        prod_others = prod(1 - allocations([1:(i-1) (i+1):N],j).*prob_a_t([1:(i-1) (i+1):N],j));
        r_without_a = task_value(j) * (1 - prod_others);
        r_with_a = task_value(j) * (1 - prod_others * (1 - prob_a_t(i,j)));
        
        tf = task_tf(j) - old_tf;
        old_tf = old_tf + tf;
        [~, ~, rho] = ComputeCommandParams(agent_pos, agent_va, task_pos(j,:), tf);
        
        dU = (r_with_a - r_without_a) - lambda * rho;
    end
end
