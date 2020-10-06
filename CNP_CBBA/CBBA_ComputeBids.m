
% Computes bids for each task. Returns bids, best index for task in
% the path, and times for the new path
%---------------------------------------------------------------------%
    
function [CBBA_Data bestIdxs taskTimes feasibility] = CBBA_ComputeBids(CBBA_Params, CBBA_Data, agent, tasks, feasibility)


% If the path is full then we cannot add any tasks to it
L = find(CBBA_Data.path == -1);
if( isempty(L) )
    return;
end

% Reset bids, best positions in path, and best times
CBBA_Data.bids = zeros(1, CBBA_Params.M);
bestIdxs       = zeros(1, CBBA_Params.M);
taskTimes      = zeros(1, CBBA_Params.M);

% For each task
for m=1:CBBA_Params.M
    
    % Check for compatibility between agent and task
    if(CBBA_Params.CM(agent.type, tasks(m).type) > 0),
               
        % Check to make sure the path doesn't already contain task m
        if( isempty(find(CBBA_Data.path(1,1:L(1,1)-1) == m)) )
            
            % Find the best score attainable by inserting the score into the
            % current path
            bestBid   = 0;
            bestIndex = 0;
            bestTime  = -1;
            
            % Try inserting task m in location j among other tasks and see if
            % it generates a better new_path.
            for j=1:L(1,1)
                if( feasibility(m,j) == 1 )
                    % Check new path feasibility
                    skip = 0;
                    
                    if(j == 1) % insert at the beginning
                        taskPrev = [];
                        timePrev = [];
                    else
                        taskPrev = tasks(CBBA_Data.path(j-1));
                        timePrev = CBBA_Data.times(j-1);
                    end
                    
                    if(j == L(1,1)) %insert at the end
                        taskNext = [];
                        timeNext = [];
                    else
                        taskNext = tasks(CBBA_Data.path(j));
                        timeNext = CBBA_Data.times(j);
                    end
                    
                    % Compute min and max start times and score
                    [score minStart maxStart] = Scoring_CalcScore(CBBA_Params,agent,tasks(m),taskPrev,timePrev,taskNext,timeNext);
                    
                    if(minStart > maxStart)
                        % Infeasible path
                        skip = 1;
                        feasibility(m,j) = 0;
                    end
                    
                    if(~skip),
                        
                        % Save the best score and task position
                        if(score > bestBid )
                            bestBid   = score;
                            bestIndex = j;
                            bestTime  = minStart;  % Select min start time as optimal
                        end
                    end
                end
            end
            
            % Save best bid information
            if( bestBid > 0 )
                CBBA_Data.bids(1,m) = bestBid; 
                bestIdxs(1,m)       = bestIndex;
                taskTimes(1,m)      = bestTime;
            end
        end     % this task is already in my bundle            
    end     % this task is incompatible with my type           
end % end loop through tasks
