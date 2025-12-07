
% Main GCAA bundle building/updating (runs on each individual agent)
% Algos 3 and 1 in paper
%---------------------------------------------------------------------%

function [GCAA_Data, newBid, agent] = GCAA_Bundle(GCAA_Params, GCAA_Data, agent, tasks, agent_idx)

% Update bundles after messaging to drop tasks that are outbid
GCAA_Data = GCAA_BundleRemoveSingleAssignment(GCAA_Params, GCAA_Data, agent_idx);

% Bid on new tasks and add them to the bundle
[GCAA_Data agent] = GCAA_BundleAdd(GCAA_Params, GCAA_Data, agent, tasks, agent_idx);

newBid = 0;

end
