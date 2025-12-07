
% Create bundles for each agent
% Algorithm 1 Select the best task for agent i
% Function SelectBestTask
%---------------------------------------------------------------------%

function [GCAA_Data, agent] = GCAA_BundleAdd(GCAA_Params, GCAA_Data, agent, tasks, agent_idx)

if GCAA_Data.fixedAgents(agent_idx) == 1
    return;
end

M = size(tasks,2);
task_pos = zeros(M,2);
task_v   = zeros(M,2);
task_tf = zeros(M,1);
task_tloiter = zeros(M,1);
task_radius = zeros(M,1);
task_type = zeros(M,1);
task_value = zeros(M,1);

for j = 1:M
    task_pos(j,:) = [tasks(j).x tasks(j).y];
    task_v(j,:)   = tasks(j).Speed;
    task_tf(j) = tasks(j).tf;
    task_tloiter(j) = tasks(j).tloiter;
    task_radius(j) = tasks(j).radius;
    task_type(j) = tasks(j).type;
    task_value(j) = tasks(j).value;
end

U = -1e14;
b = [];

winners_matrix = zeros(GCAA_Params.N, GCAA_Params.M);
for i = 1:GCAA_Params.N
    if GCAA_Data.winners(i) > 0
        winners_matrix(i,GCAA_Data.winners(i)) = 1;
    end
end

% Only pick a task that is not assigned yet
availTasks = [];
for j = 1:GCAA_Params.M
    if ~any(GCAA_Data.winners == j)
        availTasks = [availTasks, j];
    end
end

% If all tasks are assigned, pick any task with positive utility
if isempty(availTasks)
    availTasks = 1:M;
    allTasksAssigned = true;
    U = 0;
end

newRin = false;
for j = availTasks
    if task_tf(j) > task_tloiter(j)
        b_new = j;
        
        winners_matrix(agent_idx, :) = zeros(1,GCAA_Params.M);
        winners_matrix(agent_idx, j) = 1;
        [rin_t_new, vin_t_new, U_new] = CalcUtility([agent.x, agent.y], agent.v_a, task_pos, task_v, task_type, task_radius, task_tloiter, task_tf, task_value, b_new, agent_idx, GCAA_Params.prob_a_t, GCAA_Params.N, winners_matrix, GCAA_Params.lambda, agent.kdrag);
        
        if U_new > U
            U = U_new;
            b = b_new;
            rin_t = rin_t_new;
            vin_t = vin_t_new;
            newRin = true;
        end
    end
            
end


GCAA_Data.path           = b; %GCAA_InsertInList(GCAA_Data.path, bestTask, bestIdxs(1,bestTask));
GCAA_Data.winnerBids(agent_idx) = U; %GCAA_InsertInList(GCAA_Data.scores, GCAA_Data.bids(bestTask), bestIdxs(1,bestTask));

if isempty(b)
    b = 0;
end

GCAA_Data.winners(agent_idx) = b;

if newRin
    agent.rin_task = rin_t;
    agent.vin_task = vin_t;
end

return
