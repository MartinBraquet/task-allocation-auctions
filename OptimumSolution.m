%% Computes the optimum solution of the task-assignment problem
% Author: Martin Braquet
% Date: August 23, 2020

function [S_opt, p_opt, S_opt_all] = OptimumSolution(Agents, G, Tasks)

    na = Agents.N;
    Lt = Agents.Lt(1);
    pos_a = Agents.Pos;
    
    nt = Tasks.N;
    pos_t = Tasks.Pos;
    
    b{na} = [];
    
    Nmin = min(nt, Lt*na);

    I = 1:na;
    J = 1:nt;

    S_opt = 0;

    if Nmin == nt
        list_b = AllAllocComb_Nt(1, J, [], b); % Sufficient number of agents to allocate all the targets
    else
        list_b = AllAllocComb_NuLt(1, J, [], b);
    end

    all_S{size(list_b,2)} = [];
    all_p{size(list_b,2)} = [];
    % % Enumerates all combinations of tasks to agents (without order)
    % perms_tasks = perms(1:nj); % All permutations of tasks: [1 2 3], [1 3 2],
    %                            % [2 1 3], [2 3 1], [3 1 2] and [3 2 1] (if nj = 3) 
    %     task_list = perms_tasks(t,:); % 1 of the 6 task lists
    %     % Enumerates all the possibilities to split the task list among all agents

    for l = 1:size(list_b,2)
        b_curr = list_b{l};
        
        stop = 0;
        for i = 1:na
            if length(b_curr{i}) > 1
                stop = 1; % Consider only one task per agent
            end
        end
        if stop
            continue;
        end
        
        winners = zeros(na,nt);
        for i = 1:na
            for j = 1:nt
                winners(i,j) = (sum(b_curr{i} == j) > 0);
            end
        end
        [S, all_scores] = ComputeScore(na, b_curr, winners);
        all_S{l} = S;
        all_p{l} = b_curr;
        if S > S_opt
            S_opt = S;
            p_opt = b_curr;
            S_opt_all = all_scores;
        end
    end


    %%
    function list_b = AllAllocComb_Nt(i, J, list_b, b)
        if i == na+1
            list_b{size(list_b,2)+1} = b;
        else
            for k = 0:Lt
                allcombs = combnk(J,k);
                for l = 1:size(allcombs,1)
                    b{i} = allcombs(l,:);
                    J_new = J; %J_new(ismember(J_new,allcombs(l,:))) = 0; J_new = J_new(J_new~=0);
                    list_b = AllAllocComb_Nt(i+1, J_new, list_b, b);
                end
            end
        end
    end

    function list_b = AllAllocComb_NuLt(i, J, list_b, b)
        if i > na
            list_b{size(list_b,2)+1} = b;
        else
            allcombs = combnk(J,Lt);
            for l = 1:size(allcombs,1)
                b{i} = allcombs(l,:);
                J_new = J; %J_new(ismember(J_new,allcombs(l,:))) = 0; J_new = J_new(J_new~=0);
                list_b = AllAllocComb_NuLt(i+1, J_new, list_b, b);
            end
        end
    end

    function [S_new, S_j] = ComputeScore(nt, b, winners)
        S_j = zeros(1,nt);
        for j = 1:nt
%             % No assignment if same end time for two tasks in the sequence
%             stop = 0;
%             for j = 1:length(b{i})
%                 if j ~= 1 && task_tf(b(j)) == task_tf(b(j-1))
%                     stop = 1;
%                     break;
%                 end
%             end
%             if ~stop
            S_j(j) = CalcTaskUtility(Agents.Pos, Agents.v_a, Tasks.Pos(j,:), Tasks.tf(j), Tasks.r_bar(j), j, Tasks.prob_a_t, winners);
            p{i} = b{i};
%             end
        end

        S_new = sum(S_j);
    end
end
    