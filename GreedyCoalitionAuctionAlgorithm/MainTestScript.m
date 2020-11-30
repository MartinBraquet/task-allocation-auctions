%% Computes the solution of the CBBA for the task-assignment problem
% Main part of the code comes from MAS Project - Distributed Tasking Algorithm
% Control Science Group, Temasek Laboratory
% Author: Martin Braquet
% Date: August 31, 2020

rng('default');
rng(1);

N = 3;
M = 8;
Lt = 3;

WORLD.XMAX = 100;
WORLD.YMAX = WORLD.XMAX;
WORLD.XMIN = 0;
WORLD.YMIN = WORLD.XMIN;
pos_a = rand(N,2) * WORLD.XMAX;
pos_t = rand(M,2) * WORLD.XMAX;

%---------------------------------------------------------------------%
% Initialize global variables
%---------------------------------------------------------------------%

WORLD.CLR  = rand(100,3);
 
%---------------------------------------------------------------------%
% Define agents and tasks
%---------------------------------------------------------------------%
% Grab agent and task types from CBBA Parameter definitions
CBBA_Params = CBBA_Init(0,0);
CBBA_Params.MAX_DEPTH    = Lt;        % maximum bundle depth

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

% FOR USER TO DO:  Set agent fields for specialized agents, for example:
% agent_default.util = 0;

% Initialize possible task fields
task_default.id       = 0;          % task id
task_default.type     = 0;          % task type
task_default.value    = 0;          % task reward
task_default.start    = 0;          % task start time (sec)
task_default.end      = 0;          % task expiry time (sec)
task_default.duration = 0;          % task default duration (sec)
task_default.lambda   = 0.95;        % task exponential discount

task_default.x        = 0;          % task position (meters)
task_default.y        = 0;          % task position (meters)
task_default.z        = 0;          % task position (meters)

% FOR USER TO DO:  Set task fields for specialized tasks

%---------------------------%

% Create some default agents

% QUAD
agent_quad          = agent_default;
agent_quad.type     = CBBA_Params.AGENT_TYPES.QUAD; % agent type
agent_quad.nom_vel  = 1;         % agent cruise velocity (m/s)
agent_quad.fuel     = 1;         % agent fuel penalty (per meter)

% Create some default tasks

% Track
task_track          = task_default;
task_track.type     = CBBA_Params.TASK_TYPES.TRACK;      % task type
task_track.value    = 1;    % task reward
task_track.duration = 0; %600;      % task default duration (sec)


%---------------------------------------------------------------------%
% Define sample scenario
%---------------------------------------------------------------------%

% Create random agents
for n=1:N
    agents(n) = agent_quad;

    % Init remaining agent params
    agents(n).id   = n;
    agents(n).x    = pos_a(n,1);
    agents(n).y    = pos_a(n,2);
    agents(n).z    = 0;
    agents(n).clr  = WORLD.CLR(n,:);
end
 
% Create random tasks
for m=1:M
    tasks(m)          = task_track;
    tasks(m).id       = m;
    tasks(m).start    = 0; % task start time (sec)
    tasks(m).end      = 1e20; %tasks(m).start + 1*tasks(m).duration; % task expiry time (sec)
    tasks(m).x        = pos_t(m,1);
    tasks(m).y        = pos_t(m,2);
    tasks(m).z        = 0;
end
 %---------------------------------------------------------------------%
% Initialize communication graph and diameter
%---------------------------------------------------------------------%

% Fully connected graph
Graph = ~eye(N);

%---------------------------------------------------------------------%
% Run CBBA
%---------------------------------------------------------------------%
tic
[CBBA_Assignments, Total_Score] = CBBA_Main(agents, tasks, Graph)
toc
%PlotAssignments(WORLD, CBBA_Assignments, agents, tasks, 1);
PlotAssignments2D(WORLD, CBBA_Assignments, agents, tasks, 3);


% profile off
% profile report