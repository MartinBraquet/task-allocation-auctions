%% Decentralized Control for Dynamic Task Allocation Problems for Multi-Agent Systems with Auctions
% Analysis in static (Open Loop)
%
% Author: Martin Braquet
% Date: September 2020

addpath('CNP_GCAA/');
close all; clear all;
rng('default');
rng(8);

[ComputeOpt ComputeSGA ComputeGCAA] = deal(0,0,1);
CommLimit = 1;
use_GCAA = 1;
use_OPT = 0;

na = 3;
nt = 3;
Lt = 1;

lambda = 1;

map_width = 1;
comm_distance = 2 * map_width;

simu_time = 5;
n_rounds = 40;
time_step = simu_time / n_rounds;
time_start = 0;

pos_a = (0.1 + 0.8 * rand(na,2)) * map_width;
pos_t = (0.1 + 0.8 * rand(na,2)) * map_width;
%tf_t = rand(nt,1) * simu_time;
%tf_t = [5*ones(1,3) 10*ones(1,1)];
tf_t =  simu_time / 1.05 * (1 + 0.05 * rand(nt,1));
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

% Fully connected graph
G = ~eye(Agents.N);

Agents.Pos = pos_a;

Tasks.Pos = pos_t;
Tasks.N = nt;
Tasks.tf = tf_t;
Tasks.lambda = lambda;

if use_GCAA
    % GCAA solution
    tic; [S_GCAA, p_GCAA, S_GCAA_ALL] = GCAASolution(Agents, G, Tasks)
    toc;
else
    % Test of fixed solution
    p_GCAA = {[1 4], [2 4], [3 4]}; S_GCAA = 1;
end

if use_OPT
    tic; [S_OPT, p_OPT, S_OPT_ALL] = OptimumSolution(Agents, G, Tasks);
    toc;
    [S_GCAA S_OPT]
end


figure; hold on;
colors = lines(na);
    
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

for i = 1:na
    for j = 1:nt
        [~, ~, costs(i,j)] = ComputeCommandParams(pos_a(i,:), v_a(i,:), pos_t(j,:), tf_t(j));
        rewards(i,j) = r_bar(j) * prob_a_t(i,j);
        winners = zeros(na,nt);
        winners(i,j) = 1;
        utility(i,j) = CalcTaskUtility(pos_a, v_a, pos_t(j,:), tf_t(j), r_bar(j), j, prob_a_t, winners, lambda);
    end
end

if CommLimit
    for i = 1:na
        for j = (i+1):na
            G(i,j) = norm(pos_a(i,:) - pos_a(j,:)) < comm_distance;
            G(j,i) = G(i,j);
        end
    end
end

U_tot = S_GCAA

% Find the optimal control solution for the given allocation p_GCAA
[X, ~] = OptimalControlSolution(pos_a, v_a, pos_t, p_GCAA, tf_t, time_step, n_rounds, na);
PlotAlloc(X, n_rounds, na, colors, 'GCAA solution');

legend(legendUnq(gca));
drawnow;

%%

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

