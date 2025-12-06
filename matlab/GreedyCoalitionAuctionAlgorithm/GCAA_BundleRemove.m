
% Update bundles after communication
% For outbid agents, releases tasks from bundles
%---------------------------------------------------------------------%

function GCAA_Data = GCAA_BundleRemove(GCAA_Params, GCAA_Data)

outbidForTask = 0;

for j=1:GCAA_Data.Lt
    % If bundle(j) < 0, it means that all tasks up to task j are
    % still valid and in paths, the rest (j to MAX_DEPTH) are
    % released
    if( GCAA_Data.bundle(j) < 0 )
        %disp('Order is negative, breaking');
        break;
    else
        % Test if agent has been outbid for a task.  If it has,
        % release it and all subsequent tasks in its path.
        if( GCAA_Data.winners(GCAA_Data.bundle(j)) ~= GCAA_Data.agentIndex )
            outbidForTask = 1;
        end

        if( outbidForTask )
            % The agent has lost a previous task, release this one too
            if( GCAA_Data.winners(GCAA_Data.bundle(j)) == GCAA_Data.agentIndex )
                % Remove from winner list if in there
                GCAA_Data.winners(GCAA_Data.bundle(j)) = 0;
                GCAA_Data.winnerBids(GCAA_Data.bundle(j)) = 0;
            end
            % Clear from path and times vectors and remove from bundle
            idx = find(GCAA_Data.path == GCAA_Data.bundle(j));
            
            GCAA_Data.path   = GCAA_RemoveFromList(GCAA_Data.path,   idx);
            GCAA_Data.times  = GCAA_RemoveFromList(GCAA_Data.times,  idx);
            GCAA_Data.scores = GCAA_RemoveFromList(GCAA_Data.scores, idx);

            GCAA_Data.bundle(j) = -1;
        end
    end
end

end
