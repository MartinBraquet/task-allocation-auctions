
% Update bundles after communication
% For outbid agents, releases tasks from bundles
%---------------------------------------------------------------------%

function CBBA_Data = CBBA_BundleRemoveSingleAssignment(CBBA_Params, CBBA_Data, agent_idx)

    if CBBA_Data.winners(agent_idx) == 0
        return;
    end

    outbidForTask = 0;

    All_winners = (CBBA_Data.winners == CBBA_Data.winners(agent_idx)) .* (CBBA_Data.fixedAgents == 0);
    All_winnerBids = CBBA_Data.winnerBids .* All_winners;
    [maxBid, idxMaxBid] = max(All_winnerBids);
    All_losers = All_winners; All_losers(idxMaxBid) = 0;
    CBBA_Data.winners = (~All_losers) .* CBBA_Data.winners;
    CBBA_Data.winnerBids = (~All_losers) .* CBBA_Data.winnerBids;
    CBBA_Data.fixedAgents(idxMaxBid) = 1;

end
