%% Decentralized Control for Dynamic Task Allocation Problems for Multi-Agent Systems with Auctions
% Author: Martin Braquet
% Date: September 2020

addpath('GreedyCoalitionAuctionAlgorithm/');
close all; clear all;
rng('default');
rng(9);

[ComputeOpt ComputeSGA ComputeGCAA] = deal(0,0,1);
CommLimit = 1;
use_GCAA = 1;
use_OPT = 0;

na = 50;
nt = 50;
Lt = nt;

map_width = 1;
comm_distance = 2 * map_width;

simu_time = 10;
n_rounds = 1000;
time_step = simu_time / n_rounds;

pos_a = rand(na,2) * map_width;
pos_t = rand(nt,2) * map_width;
%tf_t = rand(nt,1) * simu_time;
%tf_t = [5*ones(1,3) 10*ones(1,1)];
tf_t =  2 * (1 + 0.05 * rand(nt,2));
%tf_t = 10*ones(1,nt);

[tf_t, idx] = sort(tf_t);
pos_t = pos_t(idx,:);

%velocity = 1:na;
%velocity = 1 * ones(1,nt);
max_speed = 0.1;
v_a = (2 * rand(na,2) - 1) * max_speed;

% Reward after task completion
r_bar = rand(nt,1);
%r_bar = ones(nt,1);

% Probability that agent i successfully completes task j
prob_a_t = rand(na,nt);
%prob_a_t = 1*ones(na,nt);

Tasks.r_bar = r_bar;
Tasks.prob_a_t = prob_a_t;

Agents.N = na;
Agents.Lt = Lt * ones(1,na);
Agents.v_a = v_a;

costs = zeros(na, nt);
utility = zeros(na, nt);
rewards = zeros(na, nt);
for i = 1:na
    for j = 1:nt
        [~, ~, costs(i,j)] = ComputeCommandParams(pos_a(i,:), v_a(i,:), pos_t(j,:), tf_t(j));
        rewards(i,j) = r_bar(j) * prob_a_t(i,j);
        winners = zeros(na,nt);
        winners(i,j) = 1;
        utility(i,j) = CalcTaskUtility(pos_a, v_a, pos_t(j,:), tf_t(j), r_bar(j), j, prob_a_t, winners);
    end
end

% Fully connected graph
G = ~eye(Agents.N);

figure; hold on;
colors = lines(na);

%while 1

    clf; hold on;
    xlim([0 map_width]);
    ylim([0 map_width]);
    xlabel('x [m]');
    ylabel('y [m]');
    title('Task-Agent allocation');
    for i = 1:na
        plot(pos_a(i,1), pos_a(i,2), '*', 'Color', colors(i,:), 'MarkerSize', 10, 'DisplayName', 'Agents');
    end
    plot(pos_t(:,1), pos_t(:,2),'rs', 'MarkerSize', 10, 'DisplayName', 'Targets', 'MarkerFaceColor',[1 .6 .6]);
    PlotAgentRange(pos_a, comm_distance, colors, 'Comm Range')
    
    Agents.Pos = pos_a;
    
    Tasks.Pos = pos_t;
    Tasks.N = nt;
    Tasks.tf = tf_t;
    
    if CommLimit
        for i = 1:na
            for j = (i+1):na
                G(i,j) = norm(pos_a(i,:) - pos_a(j,:)) < comm_distance;
                G(j,i) = G(i,j);
            end
        end
    end

    if use_GCAA
        % GCAA solution
        tic; [S_GCAA, p_GCAA, S_GCAA_ALL] = GCAASolution(Agents, G, Tasks)
        toc;        
    else
        % Test of fixed solution
        p_GCAA = {[1 4], [2 4], [3 4]}; S_GCAA = 1;
    end
    
    if use_OPT
        tic; [S_OPT, p_OPT, S_OPT_ALL] = OptimumSolution(Agents, G, Tasks)
        toc;
    end
    
    % Find the optimal control solution for the given allocation p_GCAA
    X = OptimalControlSolution(pos_a, v_a, pos_t, p_GCAA, tf_t, time_step, n_rounds, na);
    PlotAlloc(X, n_rounds, na, colors, 'GCAA solution');
    
    legend(legendUnq(gca));
    drawnow;
    
%     [p_GCAA, pos_a, ind_completed_tasks, nt, Agents] = UpdatePath(p_GCAA, pos_a, pos_t, time_step, Agents, nt);
%     
%     stop = 1;
%     for i = 1:na
%         if ~isempty(p_GCAA{i})
%             stop = 0;
%             break;
%         end
%     end
        
        
%     if (stop)
%         break;
%     end
    
%    pos_t = RemoveCompletedTasks(pos_t, ind_completed_tasks);
%end


function PlotAlloc(X, n_rounds, na, color, name)

    for i = 1:na      
        xx = reshape(X(:,i,:),[4,n_rounds+1]);
        plot(xx(1,:),xx(2,:), ':', 'Color', color(i,:), 'LineWidth', 2, 'DisplayName', name);
    end

end

function PlotAgentRange(pos_a, comm_distance, color, name)
    n = 20;
    theta = linspace(0, 2*pi, n)';
    for i = 1:size(pos_a,1)
        pos = repmat(pos_a(i,:), n, 1) + comm_distance * [cos(theta) sin(theta)];
        plot(pos(:,1), pos(:,2), '--', 'Color', color(i,:), 'LineWidth', 1, 'DisplayName', name);
    end
end

function pos_t_new = RemoveCompletedTasks(pos_t, ind)

    pos_t_new = zeros(size(pos_t,1)-length(ind),2);
    k = 1;
    for t = 1:size(pos_t,1)
        if ~sum(ind == t)
            pos_t_new(k,:) = pos_t(t,:);
            k = k + 1;
        end
    end

end

function [p, pos_a, ind_completed_tasks, nt, Agents] = UpdatePath(p, pos_a, pos_t, time_step, Agents, nt)
    ind_completed_tasks = [];
    
    for i = 1:size(pos_a,1)
        if ~isempty(p{i})
            d_a_t = pos_t(p{i}(1),:) - pos_a(i,:);
            if (norm(d_a_t) < time_step * Agents.Speed(i))
                pos_a(i,:) = pos_t(p{i}(1),:);
                nt = nt - 1;
                Agents.Lt(i) = Agents.Lt(i) - 1;
                ind_completed_tasks = [ind_completed_tasks p{i}(1)];
                %if (nt == 0)
                %    break;
                %end
                p{i} = p{i}(2:end);
%                 if ~isempty(p{i})
%                     time_step_remaining = time_step - norm(d_a_t) / Agents.Speed(i);
%                     d_a_next_t = pos_t(p{i}(1),:) - pos_a(i,:);
%                     pos_a(i,:) = pos_a(i,:) + d_a_next_t / norm(d_a_next_t) * time_step_remaining * Agents.Speed(i);
%                 end
            else
                pos_a(i,:) = pos_a(i,:) + d_a_t / norm(d_a_t) * time_step * Agents.Speed(i);
            end
        end
    end
end

%% Optimal control solution 
% for a double integrator dynamics and minimizing the square of the input command along the path
% Params: p_GCAA: task allocation
% Output: X: (n_rounds x na x 4) matrix corresponding to the (x,y) position and velocity of
%            each agents for each round (n_rounds = tf/time_step)
function [X] = OptimalControlSolution(pos_a, v_a, pos_t, p_GCAA, tf_t, time_step, n_rounds, na)
    X = zeros(4, na, n_rounds+1);
    A = [zeros(2,2) eye(2,2); zeros(2,2) zeros(2,2)];
    B = [zeros(2,2); eye(2,2)];
    for i = 1:na
        k = 0;
        for j = 1:size(p_GCAA{i},2)
            ind_task = p_GCAA{i}(j);
            tf = tf_t(ind_task);
            if j > 1
                tf = tf - tf_t(p_GCAA{i}(j-1));
            end
            if j == 1
                X(:, i, 1) = [pos_a(i,:) v_a(i,:)];
            end
            pos_t_curr = pos_t(ind_task,:)';
            pos_a_curr = X(1:2, i, k+1);
            v_a_curr = X(3:4, i, k+1);

            [a, b,] = ComputeCommandParams(pos_a_curr, v_a_curr, pos_t_curr, tf);
            
            t = 0;
            while t + time_step <= tf
                u = a + b*t;
                X(:, i, k+2) = X(:, i, k+1) + time_step * (A * X(:, i, k+1) + B * u);
                t = t + time_step;
                k = k + 1;
            end
        end
        for k2 = k+2:n_rounds+1
            X(:,i,k2) = X(:,i,k+1);
        end
    end
end
