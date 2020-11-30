
% Update bundles after communication
% For outbid agents, releases tasks from bundles
%---------------------------------------------------------------------%

function CBBA_Data = CBBA_BundleRemove(CBBA_Params, CBBA_Data)

outbidForTask = 0;

for j=1:CBBA_Data.Lt
    % If bundle(j) < 0, it means that all tasks up to task j are
    % still valid and in paths, the rest (j to MAX_DEPTH) are
    % released
    if( CBBA_Data.bundle(j) < 0 )
        %disp('Order is negative, breaking');
        break;
    else
        % Test if agent has been outbid for a task.  If it has,
        % release it and all subsequent tasks in its path.
        if( CBBA_Data.winners(CBBA_Data.bundle(j)) ~= CBBA_Data.agentIndex )
            outbidForTask = 1;
        end

        if( outbidForTask )
            % The agent has lost a previous task, release this one too
            if( CBBA_Data.winners(CBBA_Data.bundle(j)) == CBBA_Data.agentIndex )
                % Remove from winner list if in there
                CBBA_Data.winners(CBBA_Data.bundle(j)) = 0;
                CBBA_Data.winnerBids(CBBA_Data.bundle(j)) = 0;
            end
            % Clear from path and times vectors and remove from bundle
            idx = find(CBBA_Data.path == CBBA_Data.bundle(j));
            
            CBBA_Data.path   = CBBA_RemoveFromList(CBBA_Data.path,   idx);
            CBBA_Data.times  = CBBA_RemoveFromList(CBBA_Data.times,  idx);
            CBBA_Data.scores = CBBA_RemoveFromList(CBBA_Data.scores, idx);

            CBBA_Data.bundle(j) = -1;
        end
    end
end

end
