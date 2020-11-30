
% Calculates marginal score of doing a task and returns the expected
% start time for the task.
%---------------------------------------------------------------------%
function [score minStart maxStart] = Scoring_CalcScore(CBBA_Params,agent,taskCurr,taskPrev,timePrev,taskNext,timeNext)
    
if((agent.type == CBBA_Params.AGENT_TYPES.QUAD) || ...
   (agent.type == CBBA_Params.AGENT_TYPES.CAR))

 
    if(isempty(taskPrev)) % First task in path
        % Compute start time of task
        dt = sqrt((agent.x-taskCurr.x)^2 + (agent.y-taskCurr.y)^2 + (agent.z-taskCurr.z)^2)/agent.nom_vel;
        minStart = max(taskCurr.start, agent.avail + dt);
    else % Not first task in path
        dt = sqrt((taskPrev.x-taskCurr.x)^2 + (taskPrev.y-taskCurr.y)^2 + (taskPrev.z-taskCurr.z)^2)/agent.nom_vel;
        minStart = max(taskCurr.start, timePrev + taskPrev.duration + dt); %i have to have time to do task at j-1 and go to task m
    end
    
    if(isempty(taskNext)) % Last task in path
        maxStart = taskCurr.end;
    else % Not last task, check if we can still make promised task
        dt = sqrt((taskNext.x-taskCurr.x)^2 + (taskNext.y-taskCurr.y)^2 + (taskNext.z-taskCurr.z)^2)/agent.nom_vel;
        maxStart = min(taskCurr.end, timeNext - taskCurr.duration - dt); %i have to have time to do task m and fly to task at j+1
    end

    % Compute score
    reward = taskCurr.value * taskCurr.lambda.^(minStart-taskCurr.start);

    % Subtract fuel cost.  Implement constant fuel to ensure
    %that resulting scoring scheme satisfies a property called
    %diminishing marginal gain (DMG).
    % NOTE: This is a fake score since it double counts fuel.  Should
    % not be used when comparing to optimal score.  Need to compute
    % real score of CBBA paths once CBBA algorithm has finished
    % running.
    %penalty = agent.fuel*sqrt((agent.x-taskCurr.x)^2 + (agent.y-taskCurr.y)^2 + (agent.z-taskCurr.z)^2);
    penalty = 0;
    
    score = reward - penalty;

% FOR USER TO DO:  Define score function for specialized agents, for example:
% elseif(agent.type == CBBA_Params.AGENT_TYPES.NEW_AGENT), ...  

% Need to define score, minStart and maxStart

else
    disp('Unknown agent type')
end

return
