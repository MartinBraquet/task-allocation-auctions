
% Main CBBA bundle building/updating (runs on each individual agent)
%---------------------------------------------------------------------%

function [CBBA_Data, newBid, agent] = CBBA_Bundle(CBBA_Params, CBBA_Data, agent, tasks, agent_idx)

% Update bundles after messaging to drop tasks that are outbid
CBBA_Data = CBBA_BundleRemoveSingleAssignment(CBBA_Params, CBBA_Data, agent_idx);

% Bid on new tasks and add them to the bundle
[CBBA_Data agent] = CBBA_BundleAdd(CBBA_Params, CBBA_Data, agent, tasks, agent_idx);

newBid = 0;

% % If the list for this agent has been reset
% if sum(CBBA_Data.winners(agent_idx,:)) == 0
%     % Bid on new tasks and add them to the bundle
%     CBBA_Data = CBBA_BundleAdd(CBBA_Params, CBBA_Data, agent, tasks, agent_idx);
%
%     newBid = 1;
% end

end