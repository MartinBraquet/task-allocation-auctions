
% Initialize GCAA Parameters
%---------------------------------------------------------------------%

function GCAA_Params = GCAA_Init(N,M, prob_a_t,lambda)

% Define GCAA Constants
GCAA_Params.N            = N;        % number of agents
GCAA_Params.M            = M;        % number of tasks
GCAA_Params.prob_a_t     = prob_a_t;       
GCAA_Params.lambda     = lambda;       

GCAA_Params.MAX_STEPS = 10000000;

% FOR USER TO DO:  Add specialized agent types and task types

% List agent types 
GCAA_Params.AGENT_TYPES.QUAD   = 1;
GCAA_Params.AGENT_TYPES.CAR    = 2;

% List task types
GCAA_Params.TASK_TYPES.TRACK   = 1;
GCAA_Params.TASK_TYPES.RESCUE  = 2;

% Initialize Compatibility Matrix 
GCAA_Params.CM = zeros(length(fieldnames(GCAA_Params.AGENT_TYPES)), ...
                       length(fieldnames(GCAA_Params.TASK_TYPES)));

% FOR USER TO DO: Set agent-task pairs (which types of agents can do which types of tasks)
GCAA_Params.CM(GCAA_Params.AGENT_TYPES.QUAD, GCAA_Params.TASK_TYPES.TRACK)  = 1;
GCAA_Params.CM(GCAA_Params.AGENT_TYPES.CAR,  GCAA_Params.TASK_TYPES.RESCUE) = 1;

return