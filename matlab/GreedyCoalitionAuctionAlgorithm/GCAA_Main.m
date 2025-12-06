
% Main GCAA Function
%---------------------------------------------------------------------%

function [GCAA_Data Total_Score, All_scores, agents] = GCAA_Main(agents, tasks, Graph, prob_a_t, lambda)

% Initialize GCAA parameters
GCAA_Params = GCAA_Init(length(agents),length(tasks), prob_a_t, lambda);

for n=1:GCAA_Params.N
    GCAA_Data(n).agentID          = agents(n).id;
    GCAA_Data(n).agentIndex       = n;
    %GCAA_Data(n).bundle           = -ones(1, agents(n).Lt);
    GCAA_Data(n).path             = -ones(1, agents(n).Lt);
    GCAA_Data(n).times            = -ones(1, agents(n).Lt);
    %GCAA_Data(n).scores           = 0;
    %GCAA_Data(n).bids             = zeros(1, GCAA_Params.M);
    GCAA_Data(n).winners          = zeros(1, GCAA_Params.N);%zeros(GCAA_Params.N, GCAA_Params.M);
    GCAA_Data(n).winnerBids       = zeros(1, GCAA_Params.N);
    GCAA_Data(n).fixedAgents      = zeros(1, GCAA_Params.N);
    GCAA_Data(n).Lt               = agents(n).Lt;
end

% Fix the tasks if the completion is close
for i=1:GCAA_Params.N
    task_idx = agents(i).previous_task;
    if task_idx ~= 0 && (tasks(task_idx).tf - tasks(task_idx).tloiter) / tasks(task_idx).tloiter < 1
        GCAA_Data(i).fixedAgents(i) = 1;
        GCAA_Data(i).path = agents(i).previous_task;
        GCAA_Data(i).winners(i) = task_idx;
        GCAA_Data(i).winnerBids(i) = agents(i).previous_winnerBids;
    end
end



% Initialize working variables
T         = 0;                                      % Current iteration
t         = zeros(GCAA_Params.N, GCAA_Params.N);    % Matrix of time of updates from the current winners
lastTime  = T-1;
doneFlag  = 0;

% Main GCAA loop (runs until convergence)
while(doneFlag == 0)
    
    %---------------------------------------%
    % 1. Communicate
    %---------------------------------------%
    [GCAA_Data, t] = GCAA_Communicate_Single_Assignment(GCAA_Params, GCAA_Data, Graph, t, T);
    
    %---------------------------------------%
    % 2. Run GCAA bundle building/updating
    %---------------------------------------%
    % Run GCAA on each agent 
    for n = 1:GCAA_Params.N
        
        % Perform consensus on winning agents and bid values 
        %[GCAA_Data, t] = GCAA_Communicate(GCAA_Params, GCAA_Data, Graph, t, T, n);

        if GCAA_Data(n).fixedAgents(n) == 0
            [GCAA_Data(n), newBid, agents(n)] = GCAA_Bundle(GCAA_Params, GCAA_Data(n), agents(n), tasks, n);
        end

        % Update last time things changed 
%         if(newBid)
%             lastTime = T;
%         end
    end
    
    doneFlag = 1;
    for n = 1:GCAA_Params.N
        if GCAA_Data(n).fixedAgents(n) == 0
            doneFlag = 0;
            break;
        end
    end
   
    %---------------------------------------%
    % 3. Convergence Check
    %---------------------------------------%
    % Determine if the assignment is over (implemented for now, but later
    % this loop will just run forever)
    if(T-lastTime > GCAA_Params.N)
        doneFlag   = 1;
    elseif(T-lastTime > 2*GCAA_Params.N)
        disp('Algorithm did not converge due to communication trouble');
        doneFlag = 1;
    else
        % Maintain loop
        T = T + 1;
        %display(T);
        %display(agents(n).x)
    end
end



% Compute the total score of the GCAA assignment
Total_Score = 0;
All_scores = zeros(1,GCAA_Params.N);
for n=1:GCAA_Params.N
    All_scores(n) = GCAA_Data(n).winnerBids(n);
    Total_Score = Total_Score + All_scores(n);
end
