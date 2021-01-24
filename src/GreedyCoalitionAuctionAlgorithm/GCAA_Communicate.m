
% Runs consensus between neighbors
% Checks for conflicts and resolves among agents

%---------------------------------------------------------------------%

function [GCAA_Data t] = GCAA_Communicate(GCAA_Params, GCAA_Data, Graph, old_t, T, agent_idx)

% Copy data
for n = 1:GCAA_Params.N
    old_z(:,:,n) = GCAA_Data(n).winners;
    old_y(n,:) = GCAA_Data(n).winnerBids;    
end

z = old_z;
y = old_y;
t = old_t;

epsilon = 10e-6;


% Start communication between agents

% sender   = k
% receiver = i
% task     = j

i = agent_idx;
%for i=1:GCAA_Params.N
    for k=1:GCAA_Params.N
        if( Graph(k,i) == 1 )
            for j=1:GCAA_Params.M
                z(k,:,i) = old_z(k,:,k);
            end
            
            % Update timestamps for all agents based on latest comm
            for n=1:GCAA_Params.N
                if( n ~= i && t(i,n) < old_t(k,n) )
                    t(i,n) = old_t(k,n);
                end
            end
            t(i,k) = T;
            
        end
    end
%end

% Copy data
for n = 1:GCAA_Params.N
    GCAA_Data(n).winners    = z(:,:,n);
    %GCAA_Data(n).winnerBids = y(n,:);
    t(n,n) = T;
end

end

