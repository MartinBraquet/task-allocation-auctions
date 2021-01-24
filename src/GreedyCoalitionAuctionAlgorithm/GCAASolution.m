%% Computes the solution of the GCAA for the task-assignment problem
% Main part of the code comes from MAS Project - Distributed Tasking Algorithm
% Control Science Group, Temasek Laboratory
% Author: Martin Braquet
% Date: August 31, 2020

function [S_GCAA, p, S_GCAA_ALL, rt, Agents] = GCAASolution(Agents, G, TasksCells)

    na = Agents.N;
    pos_a = Agents.Pos;
    
    nt = TasksCells.N;
    pos_t = TasksCells.Pos;

    %---------------------------------------------------------------------%
    % Initialize global variables
    %---------------------------------------------------------------------%

    %WORLD.CLR  = rand(100,3);

    %---------------------------------------------------------------------%
    % Define agents and tasks
    %---------------------------------------------------------------------%
    % Grab agent and task types from GCAA Parameter definitions
    GCAA_Params = GCAA_Init(0,0,TasksCells.prob_a_t,TasksCells.lambda);

    % Initialize possible agent fields
    agent_default.id    = 0;            % agent id
    agent_default.type  = 0;            % agent type
    agent_default.avail = 0;            % agent availability (expected time in sec)
    agent_default.clr = [];             % for plotting

    agent_default.x       = 0;          % agent position (meters)
    agent_default.y       = 0;          % agent position (meters)
    agent_default.z       = 0;          % agent position (meters)
    agent_default.nom_vel = 0;          % agent cruise velocity (m/s)
    agent_default.fuel    = 0;          % agent fuel penalty (per meter)
    agent_default.Lt      = 0;          % agent max number of tasks
    agent_default.v_a      = [0 0];          %
    agent_default.rin_task = [];
    agent_default.vin_task = [];
    agent_default.previous_task = [];
    agent_default.previous_winnerBids = [];
    agent_default.kdrag = 0;
    
    % FOR USER TO DO:  Set agent fields for specialized agents, for example:
    % agent_default.util = 0;

    % Initialize possible task fields
    task_default.id       = 0;          % task id
    task_default.type     = 0;          % task type
    task_default.value    = 0;          % task reward
    task_default.start    = 0;          % task start time (sec)
    task_default.end      = 0;          % task expiry time (sec)
    task_default.duration = 0;          % task default duration (sec)
    task_default.tf       = 0;          % task default duration (sec)
    %task_default.lambda   = 0.95;        % task exponential discount

    task_default.x        = 0;          % task position (meters)
    task_default.y        = 0;          % task position (meters)
    task_default.z        = 0;          % task position (meters)
    task_default.Speed    = 0;          %
    task_default.type     = 0;          %
    task_default.radius   = 0;          %
    task_default.tloiter  = 0;          %

    % FOR USER TO DO:  Set task fields for specialized tasks

    %---------------------------%

    % Create some default agents

    % QUAD
    agent_quad          = agent_default;
    agent_quad.type     = GCAA_Params.AGENT_TYPES.QUAD; % agent type
    agent_quad.nom_vel  = 0;         % agent cruise velocity (m/s)
    agent_quad.fuel     = 1;         % agent fuel penalty (per meter)

    % Create some default tasks

    % Track
    task_track          = task_default;
    task_track.type     = GCAA_Params.TASK_TYPES.TRACK;      % task type
    task_track.value    = 0;    % task reward
    task_track.duration = 0; %600;      % task default duration (sec)


    %---------------------------------------------------------------------%
    % Define sample scenario
    %---------------------------------------------------------------------%

    % Create random agents
    for n=1:na
        agents(n) = agent_quad;

        % Init remaining agent params
        agents(n).id      = n;
        agents(n).x       = pos_a(n,1);
        agents(n).y       = pos_a(n,2);
        agents(n).z       = 0;
        agents(n).v_a     = Agents.v_a(n,:);
        agents(n).Lt      = Agents.Lt(n);
        agents(n).rin_task = [];
        agents(n).vin_task = [];
        agents(n).previous_task = Agents.previous_task(n);
        agents(n).previous_winnerBids = Agents.previous_winnerBids(n);
        agents(n).kdrag = Agents.kdrag;
        %agents(n).clr  = WORLD.CLR(n,:);
    end
    
    % Create random tasks
    for m=1:nt
        tasks(m)          = task_track;
        tasks(m).id       = m;
        tasks(m).start    = 0; % task start time (sec)
        tasks(m).end      = 1e20; %tasks(m).start + 1*tasks(m).duration; % task expiry time (sec)
        tasks(m).x        = pos_t(m,1);
        tasks(m).y        = pos_t(m,2);
        tasks(m).z        = 0;
        tasks(m).tf       = TasksCells.tf(m);
        tasks(m).value    = TasksCells.r_bar(m);
        tasks(m).Speed    = TasksCells.Speed(m);
        tasks(m).type     = TasksCells.task_type(m);
        tasks(m).radius   = TasksCells.radius(m);
        tasks(m).tloiter  = TasksCells.tloiter(m);
    end

    %---------------------------------------------------------------------%
    % Run GCAA
    %---------------------------------------------------------------------%
    %tic
    [GCAA_Assignments, S_GCAA_agents, S_GCAA_ALL_agents, agents] = GCAA_Main(agents, tasks, G, TasksCells.prob_a_t, TasksCells.lambda);
    %toc
    %PlotAssignments(WORLD, GCAA_Assignments, agents, tasks, 1);
    %PlotAssignments2D(WORLD, GCAA_Assignments, agents, tasks, 3);
    
    p{na} = [];
    
    for i = 1:na
        p{i} = GCAA_Assignments(i).path;
        
        ind = find(p{i} == -1);
        if ~isempty(ind)
            p{i} = p{i}(1:(ind(1)-1));
        end
    end
    
    
    winners = zeros(na,1);
    for i = 1:na
        if ~isempty(p{i})
            winners(i) = p{i};
        end
    end
    winners_matrix = WinnerVectorToMatrix(na, nt, winners);

    S_GCAA_ALL = zeros(1,nt);
    rt         = zeros(1,nt);
    for j = 1:nt
        S_GCAA_ALL(j) = CalcTaskUtility(Agents.Pos, Agents.v_a, TasksCells.Pos(j,:), TasksCells.Speed(j,:), TasksCells.tf(j), TasksCells.r_bar(j), j, TasksCells.prob_a_t, winners_matrix, TasksCells.lambda, Agents.kdrag);
        rt(j) = TasksCells.r_bar(j) * (1 - prod(1 - winners_matrix(:,j).*TasksCells.prob_a_t(:,j)));
    end
    S_GCAA = sum(S_GCAA_ALL);
    
    % Fix the tasks if the completion is close
    for i=1:na
        task_idx = p{i};
        if isempty(task_idx)
            Agents.previous_task(i) = 0;
            Agents.previous_winnerBids(i) = 0;
        else
            if tasks(task_idx).tloiter > 0 && (tasks(task_idx).tf - tasks(task_idx).tloiter) / tasks(task_idx).tloiter < 1
                p{i} = Agents.previous_task(i);
                agents(i).rin_task = [];
            else
                Agents.previous_task(i) = task_idx;
                Agents.previous_winnerBids(i) = S_GCAA_ALL_agents(i);
            end
            if i==2
                a = Agents.previous_task(i);
                a
                task_idx
            end
        end
    end
    
    for i = 1:na
        if ~isempty(agents(i).rin_task')
            Agents.rin_task(i,:) = agents(i).rin_task';
            Agents.vin_task(i,:) = agents(i).vin_task';
        end
    end

end