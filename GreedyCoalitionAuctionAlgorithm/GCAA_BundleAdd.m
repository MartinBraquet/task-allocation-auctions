
% Create bundles for each agent
%---------------------------------------------------------------------%

function [CBBA_Data, agent] = CBBA_BundleAdd(CBBA_Params, CBBA_Data, agent, tasks, agent_idx)

if CBBA_Data.fixedAgents(agent_idx) == 1
    return;
end

%epsilon = 10e-6;
%newBid  = 0;

% % Check if bundle is full
% bundleFull = isempty(find(CBBA_Data.bundle == -1));

% Initialize feasibility matrix (to keep track of which j locations can be pruned)
%feasibility = ones(CBBA_Params.M, CBBA_Data.Lt+1);

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

U = 0;
b = [];

winners_matrix = zeros(CBBA_Params.N, CBBA_Params.M);
for i = 1:CBBA_Params.N
    if CBBA_Data.winners(i) > 0
        winners_matrix(i,CBBA_Data.winners(i)) = 1;
    end
end


for j = 1:M
    if task_tf(j) > task_tloiter(j)
        b_new = j;
        
        winners_matrix(agent_idx, :) = zeros(1,CBBA_Params.M);
        winners_matrix(agent_idx, j) = 1;
        [rin_t_new, vin_t_new, U_new] = CalcUtility([agent.x, agent.y], agent.v_a, task_pos, task_v, task_type, task_radius, task_tloiter, task_tf, task_value, b_new, agent_idx, CBBA_Params.prob_a_t, CBBA_Params.N, winners_matrix, CBBA_Params.lambda, agent.kdrag);
        
        if U_new > U
            U = U_new;
            b = b_new;
            rin_t = rin_t_new;
            vin_t = vin_t_new;
        end
    end
            

    % Update task values based on current assignment
    %[CBBA_Data bestIdxs taskTimes feasibility] = CBBA_ComputeBids(CBBA_Params, CBBA_Data, agent, tasks, feasibility);

    % Determine which assignments are available
%       
%     D1 = (CBBA_Data.bids - CBBA_Data.winnerBids > epsilon);
%     D2 = (abs(CBBA_Data.bids - CBBA_Data.winnerBids) <= epsilon);
%     D3 = (CBBA_Data.agentIndex < CBBA_Data.winners);       % Tie-break based on agent index
% 
%     D = D1 | (D2 & D3);

    % Select the assignment that will improve the score the most and
    % place bid
%     [value bestTask] = max(D.*CBBA_Data.bids);
% 
%     if( value > 0 )

        % Set new bid flag
        %newBid = 1;
        
%         % Check for tie
%         allvalues = find(D.*CBBA_Data.bids == value);
%         if(length(allvalues) == 1),
%             bestTask = allvalues;
%         else
%             % Tie-break by which task starts first
%             earliest = realmax;
%             for i=1:length(allvalues),
%                 if ( tasks(allvalues(i)).start < earliest),
%                     earliest = tasks(allvalues(i)).start;
%                     bestTask = allvalues(i);
%                 end
%             end
%         end

        %CBBA_Data.winnerBids(bestTask) = CBBA_Data.bids(bestTask);


        
        
        % Update feasibility

%         for i = 1:CBBA_Params.M
%             feasibility(i,:) = CBBA_InsertInList(feasibility(i,:), feasibility(i,bestIdxs(1,bestTask)), bestIdxs(1,bestTask));
%         end

    % Check if bundle is full
    %bundleFull = isempty(find(CBBA_Data.bundle == -1));
end

% for j = 1:CBBA_Params.M
%     if sum(b == j) > 0
%         CBBA_Data.winners(agent_idx,j) = 1;
%     end
% end


CBBA_Data.path           = b; %CBBA_InsertInList(CBBA_Data.path, bestTask, bestIdxs(1,bestTask));
%CBBA_Data.times         = CBBA_InsertInList(CBBA_Data.times, taskTimes(1,bestTask), bestIdxs(1,bestTask));
CBBA_Data.winnerBids(agent_idx) = U; %CBBA_InsertInList(CBBA_Data.scores, CBBA_Data.bids(bestTask), bestIdxs(1,bestTask));
%len                     = length(find(CBBA_Data.bundle > -1));
%CBBA_Data.bundle(len+1) = bestTask;

if isempty(b)
    b = 0;
end

CBBA_Data.winners(agent_idx) = b;

if U > 0
    agent.rin_task = rin_t;
    agent.vin_task = vin_t;
end

return