
% Initialize CBBA Parameters
%---------------------------------------------------------------------%

function CBBA_Params = CBBA_Init(N,M, prob_a_t,lambda)

% Define CBBA Constants
CBBA_Params.N            = N;        % number of agents
CBBA_Params.M            = M;        % number of tasks
CBBA_Params.prob_a_t     = prob_a_t;       
CBBA_Params.lambda     = lambda;       

CBBA_Params.MAX_STEPS = 10000000;

% FOR USER TO DO:  Add specialized agent types and task types

% List agent types 
CBBA_Params.AGENT_TYPES.QUAD   = 1;
CBBA_Params.AGENT_TYPES.CAR    = 2;

% List task types
CBBA_Params.TASK_TYPES.TRACK   = 1;
CBBA_Params.TASK_TYPES.RESCUE  = 2;

% Initialize Compatibility Matrix 
CBBA_Params.CM = zeros(length(fieldnames(CBBA_Params.AGENT_TYPES)), ...
                       length(fieldnames(CBBA_Params.TASK_TYPES)));

% FOR USER TO DO: Set agent-task pairs (which types of agents can do which types of tasks)
CBBA_Params.CM(CBBA_Params.AGENT_TYPES.QUAD, CBBA_Params.TASK_TYPES.TRACK)  = 1;
CBBA_Params.CM(CBBA_Params.AGENT_TYPES.CAR,  CBBA_Params.TASK_TYPES.RESCUE) = 1;

return