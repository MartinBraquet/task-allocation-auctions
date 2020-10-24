%% Optimal control solution 
% for a double integrator dynamics and minimizing the square of the input command along the path
% Params: p_CBBA: task allocation
% Output: X: (n_rounds x na x 4) matrix corresponding to the (x,y) position and velocity of
%            each agents for each round (n_rounds = tf/time_step)
function [X, completed_tasks] = OptimalControlSolution(pos_a, v_a, pos_t, v_t, p_CBBA, tf_t, time_step, n_rounds, na)
    X = zeros(4, na, n_rounds+1);
    A = [zeros(2,2) eye(2,2); zeros(2,2) zeros(2,2)];
    B = [zeros(2,2); eye(2,2)];
    completed_tasks = [];
    for i = 1:na
        k = 0;
        X(:, i, 1) = [pos_a(i,:) v_a(i,:)];
        for j = 1:size(p_CBBA{i},2)
            ind_task = p_CBBA{i}(j);
            tf = tf_t(ind_task);
            if j > 1
                tf = tf - tf_t(p_CBBA{i}(j-1));
            end
            pos_t_curr = pos_t(ind_task,:)';
            v_t_curr = v_t(ind_task,:)';
            pos_a_curr = X(1:2, i, k+1);
            v_a_curr = X(3:4, i, k+1);

            [uparams, rparams, vparams, tparams, ~] = ComputeCommandParamsWithVelocity(pos_a_curr, v_a_curr, pos_t_curr, v_t_curr, tf, );
            
            t = 0;
            while t + time_step <= tf
                diff_t = tparams-t;
                diff_t(diff_t <= 0) = 1e16;
                [~, idx] = min(diff_t); idx = idx - 1;
                u = uparams(idx,:) + (uparams(idx+1,:) - uparams(idx,:)) * (t - tparams(idx)) / (tparams(idx+1) - tparams(idx));
                X(:, i, k+2) = X(:, i, k+1) + time_step * (A * X(:, i, k+1) + B * u');
                t = t + time_step;
                k = k + 1;
            end
        end
        % If it reaches the target
        if k == 1 && sum(completed_tasks == p_CBBA{i}) == 0
            completed_tasks = [completed_tasks p_CBBA{i}];
        end
        if size(p_CBBA{i},2) == 0
            for k = 2:n_rounds+1
                X(:, i, k) = X(:, i, k-1);
            end
        end
        for k2 = k+2:n_rounds+1
            X(:,i,k2) = X(:,i,k+1);
        end
    end
end