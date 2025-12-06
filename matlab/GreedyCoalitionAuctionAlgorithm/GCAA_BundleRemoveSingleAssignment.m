
% Update bundles after communication
% For outbid agents, releases tasks from bundles
%---------------------------------------------------------------------%

function GCAA_Data = GCAA_BundleRemoveSingleAssignment(GCAA_Params, GCAA_Data, agent_idx)

if sum(GCAA_Data.winnerBids) == 0
    return;
end

%for agent_idx = 1:GCAA_Params.N
    if GCAA_Data.winners(agent_idx) > 0
        All_winners = (GCAA_Data.winners == GCAA_Data.winners(agent_idx)) .* (GCAA_Data.fixedAgents == 0);
        if sum(All_winners) > 0
            All_winnerBids = GCAA_Data.winnerBids .* All_winners;
            All_winnerBids(All_winnerBids == 0) = -1e16;
            [maxBid, idxMaxBid] = max(All_winnerBids);
            All_losers = All_winners; All_losers(idxMaxBid) = 0;
            GCAA_Data.winners = (~All_losers) .* GCAA_Data.winners;
            GCAA_Data.winnerBids = (~All_losers) .* GCAA_Data.winnerBids;
            GCAA_Data.fixedAgents(idxMaxBid) = 1;
        end
    end
end
