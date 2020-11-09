%% Optimal control solution 
% for a double integrator dynamics and minimizing the square of the input command along the path
% Params: p_CBBA: task allocation
% Output: X: (n_rounds x na x 4) matrix corresponding to the (x,y) position and velocity of
%            each agents for each round (n_rounds = tf/time_step)
function [X, completed_tasks, J, J_to_completion_target] = OptimalControlSolution(pos_a, v_a, pos_t, v_t, radius_t, p_CBBA, Agents, tf_t, tloiter_t, time_step, n_rounds, na, kdrag)
    X = zeros(4, na, n_rounds+1);
    J = [zeros(1,na)];
    J_to_completion_target = [zeros(1,na)];
    A = [zeros(2,2) eye(2,2); zeros(2,2) zeros(2,2)];
    B = [zeros(2,2); eye(2,2)];
    completed_tasks = [];
    for i = 1:na
        X(:, i, 1) = [pos_a(i,:) v_a(i,:)];
        if (isempty(p_CBBA{i}) || p_CBBA{i} == 0)
            p_CBBA{i} = [];
            for k = 1:size(X,3)-1
                if k == 1
                    u = - kdrag * X(3:4, i, k);
                    X(:, i, k+1) = X(:, i, k) + time_step * (A * X(:, i, k) + B * u);
                else
                    X(:, i, k+1) = X(:, i, k);
                end
            end
        end
        for j = 1:size(p_CBBA{i},2)
            k = 0;
            ind_task = p_CBBA{i}(j);
            tf = tf_t(ind_task);
            if j > 1
                tf = tf - tf_t(p_CBBA{i}(j-1));
            end
            pos_t_curr = pos_t(ind_task,:)';
            v_t_curr = v_t(ind_task,:)';
            pos_a_curr = X(1:2, i, k+1);
            v_a_curr = X(3:4, i, k+1);

            J_to_completion_target_curr = 0;
            if tf > tloiter_t(ind_task) + time_step
                t_to_target = 0:time_step:(tf-tloiter_t(ind_task));
                [uparams, rparams, vparams, tparams, J_to_completion_target_curr] = ComputeCommandParamsWithVelocity(pos_a_curr, v_a_curr, Agents.rin_task(i,:)', Agents.vin_task(i,:)', tf - tloiter_t(ind_task), t_to_target, Agents.kdrag);
            end
            J_to_completion_target(i) = J_to_completion_target_curr;
            R = radius_t(ind_task);
            norm_vt = 2*pi * R / tloiter_t(ind_task);
            norm_a = norm_vt^2 / R;
            
            if tloiter_t(ind_task) > 0 && tf > 0
                J_to_completion_target(i) = J_to_completion_target(i) + 1/2 * norm_a^2 * min(tloiter_t(ind_task), tf);
            end
                
            t = 0;
            while t + time_step <= tf
                %diff_t = tparams-t;
                %diff_t(diff_t <= 0) = 1e16;
                %[~, idx] = min(diff_t); idx = idx - 1;
                %u = uparams(idx,:) + (uparams(idx+1,:) - uparams(idx,:)) * (t - tparams(idx)) / (tparams(idx+1) - tparams(idx));
                u = 0;
                if tf > tloiter_t(ind_task) + time_step
                    if k + 1 <= length(t_to_target)
                        u = uparams(k+1,:)';
                        X(:, i, k+2) = X(:, i, k+1) + time_step * (A * X(:, i, k+1) + B * u);
                    else
                        X(:, i, k+2) = X(:, i, k+1);
                    end
                else
                    r_target_circle = pos_t_curr - X(1:2, i, k+1);
                    d = norm(r_target_circle);
                    alpha = 0; % 0.4 * (d - R) / R;
                    u = (1 + alpha) * norm_a * r_target_circle / d;
                    X(:, i, k+2) = X(:, i, k+1) + time_step * (A * X(:, i, k+1) + B * u);
                end
                
                if k == 0
                    J(i) = 1/2 * norm(u)^2 * time_step;
                end
                
                t = t + time_step;
                k = k + 1;
            end
        end
        % If it reaches the target
        if k == 1 && sum(completed_tasks == p_CBBA{i}) == 0
            completed_tasks = [completed_tasks p_CBBA{i}];
        end
        for k2 = k+2:n_rounds+1
            X(:,i,k2) = X(:,i,k+1);
        end
    end
end