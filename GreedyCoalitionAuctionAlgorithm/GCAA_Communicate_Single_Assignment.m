
% Runs consensus between neighbors
% Checks for conflicts and resolves among agents

%---------------------------------------------------------------------%

function [CBBA_Data t] = CBBA_Communicate_Single_Assignment(CBBA_Params, CBBA_Data, Graph, old_t, T)
% Copy data
for n = 1:CBBA_Params.N
    old_z(n,:) = CBBA_Data(n).winners;
    old_y(n,:) = CBBA_Data(n).winnerBids;
    old_f(n,:) = CBBA_Data(n).fixedAgents;
end

z = old_z;
y = old_y;
f = old_f;
t = old_t;

epsilon = 10e-6;


% Start communication between agents

% sender   = k
% receiver = i
% task     = j

for i=1:CBBA_Params.N
    for k=1:CBBA_Params.N
        if( Graph(k,i) == 1 )
           % for j=1:CBBA_Params.M
                
                z(i,k) = old_z(k,k);
                y(i,k) = old_y(k,k);
                f(i,k) = old_f(k,k);
                
           % end
                
            
            % Update timestamps for all agents based on latest comm
            for n=1:CBBA_Params.N
                if( n ~= i && t(i,n) < old_t(k,n) )
                    t(i,n) = old_t(k,n);
                end
            end
            t(i,k) = T;
            
        end
    end
end

% Copy data
for n = 1:CBBA_Params.N
    CBBA_Data(n).winners    = z(n,:);
    CBBA_Data(n).winnerBids = y(n,:);
    CBBA_Data(n).fixedAgents = f(n,:);
    t(n,n) = T;
end

end

