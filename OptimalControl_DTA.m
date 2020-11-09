%% Decentralized Control for Dynamic Task Allocation Problems for Multi-Agent Systems with Auctions
% Analysis in dynamics
%
% Author: Martin Braquet
% Date: September 2020

addpath('CNP_CBBA/');
close all; clear all;
rng('default');
rng(6);

simu_number = 5;
simu_name = 'Dynamics';

[ComputeOpt ComputeSGA ComputeCBBA] = deal(0,0,1);

use_CBBA = 1;
use_OPT = 0;
uniform_agents = 0;
uniform_tasks = 0;
plot_range = 0;

na = 10;
nt = 10;
Lt = 1;

nt_loiter = ceil(0.5*nt);
task_type = zeros(nt,1);
task_type(1:nt_loiter) = 1;
lambda = 1;

map_width = 1;
comm_distance = 0.3 * map_width;

simu_time = 10;
n_rounds = 50;
time_step = simu_time / n_rounds;
time_start = 0;

pos_a = (0.1 + 0.8 * rand(na,2)) * map_width;
pos_t = (0.1 + 0.8 * rand(nt,2)) * map_width;
%tf_t = rand(nt,1) * simu_time;
%tf_t = [5*ones(1,3) 10*ones(1,1)];
tf_t =  simu_time * (0.95 + 0.05 * rand(nt,1));
tloiter_t =  simu_time * (0.2 + 0.05 * rand(nt,1));
tloiter_t(task_type == 0) = 0;
%tf_t = 10*ones(1,nt);

[tf_t, idx] = sort(tf_t);
pos_t = pos_t(idx,:);
pos_t_initial = pos_t;

kdrag = 3 / simu_time;

%velocity = 1:na;
%velocity = 1 * ones(1,nt);
max_speed = 0.1;
if uniform_agents
    v_a = zeros(na,2);
else
    v_a = (2 * rand(na,2) - 1) * max_speed;
end

max_speed_task = 0.1;
if uniform_tasks
    v_t = zeros(nt,2);
else
    v_t = (2 * rand(nt,2) - 1) * max_speed_task;
end

R = 0.04 * map_width;
if uniform_tasks
    radius_t = R * ones(nt,1);
else
    radius_t = (0.2 * rand(nt,1) + 1) * R;
end

% 
% pos_a = [0.1 0.5];
% v_a = [0 0];
% pos_t = [0 0.8];


% Reward after task completion
r_nom = 0.02;
if uniform_tasks
    r_bar = r_nom * ones(nt,1);
else
    r_bar = r_nom * rand(nt,1);
end
r_bar(task_type == 1) = 2 * r_bar(task_type == 1);
    
% Probability that agent i successfully completes task j
if uniform_agents
    prob_a_t = 0.7 * ones(na,nt);
else
    prob_a_t = rand(na,nt);
end

Tasks.r_bar = r_bar;
Tasks.prob_a_t = prob_a_t;
Tasks.tast_type = task_type;

Agents.N = na;
Agents.Lt = Lt * ones(1,na);
Agents.v_a = v_a;
Agents.previous_task = zeros(na,1);
Agents.previous_winnerBids = zeros(na,1);
Agents.rin_task = zeros(na,2);
Agents.vin_task = zeros(na,2);
Agents.kdrag = kdrag;

costs = zeros(na, nt);
utility = zeros(na, nt);
rewards = zeros(na, nt);

% Fully connected graph
G = ~eye(Agents.N);

figure; hold on;
colors = lines(na);

SimuParamsCell.n_rounds = n_rounds;
SimuParamsCell.time_step = time_step;
SimuParamsCell.map_width = map_width;
SimuParamsCell.comm_distance = comm_distance;
SimuParamsCell.simu_time = simu_time;
SimuParamsCell.time_step = time_step;
SimuParamsCell.colors = colors;
SimuParamsCell.pos_a_init = pos_a;
SimuParamsCell.max_speed = max_speed;
SimuParamsCell.v_a = v_a;
SimuParamsCell.pos_t = pos_t;
SimuParamsCell.max_speed_task = max_speed_task;
SimuParamsCell.v_t = v_t;
SimuParamsCell.radius_t = radius_t;
SimuParamsCell.task_type = task_type;
SimuParamsCell.nt_loiter = nt_loiter;
SimuParamsCell.task_type = task_type;
SimuParamsCell.na = na;
SimuParamsCell.nt = nt;
SimuParamsCell.tf_t = tf_t;
SimuParamsCell.tloiter_t = tf_t;
SimuParamsCell.R = R;
SimuParamsCell.radius_t = radius_t;
SimuParamsCell.r_nom = r_nom;
SimuParamsCell.r_bar = r_bar;
SimuParamsCell.lambda = lambda;
SimuParamsCell.prob_a_t = prob_a_t;
SimuParamsCell.kdrag = kdrag;


for CommLimit = [0 1]
      
clear J J_to_completion_target X_full_simu p_CBBA_full_simu S_CBBA_ALL X;
    
n_rounds_loop = n_rounds;
simu_time_loop = simu_time;
time_start_loop = time_start;
tf_t_loop = tf_t;
pos_a_loop = pos_a;
v_a_loop = v_a;

U_next_tot = zeros(n_rounds,1);
U_tot = zeros(n_rounds,1);
U_completed_tot = 0;

completed_tasks_round = [];
completed_tasks = [];
rt_completed = 0;

X_full_simu{n_rounds} = 0;
p_CBBA_full_simu{n_rounds} = 0;
S_CBBA_ALL_full_simu = zeros(n_rounds,nt);
rt_full_simu = zeros(n_rounds,nt);
J = zeros(n_rounds,na); % Cost for each agent from start to current step
J_to_completion_target = zeros(n_rounds,na); % Estimated cost for each agent from step to end

for i_round = 1:n_rounds
    
    clf; hold on;
    xlim([0 map_width]);
    ylim([0 map_width]);
    xlabel('x [m]');
    ylabel('y [m]');
    title('Task-Agent allocation');
    for i = 1:na
        plot(pos_a_loop(i,1), pos_a_loop(i,2), '*', 'Color', colors(i,:), 'MarkerSize', 10, 'DisplayName', 'Agents');
    end
    plot(pos_t(:,1), pos_t(:,2),'rs', 'MarkerSize', 10, 'DisplayName', 'Targets', 'MarkerFaceColor',[1 .6 .6]);
    if plot_range && plot_range
        PlotAgentRange(pos_a_loop, comm_distance, colors, 'Comm Range');
    end
    
    PlotTaskLoitering(pos_t, radius_t, task_type, 'r--', 'Task loitering');
    
    Agents.Pos = pos_a_loop;
    Agents.v_a = v_a_loop;
    
    Tasks.Pos = pos_t;
    Tasks.Speed = v_t;
    Tasks.N = nt;
    Tasks.tf = tf_t_loop;
    Tasks.lambda = lambda;
    Tasks.task_type = task_type;
    Tasks.tloiter = tloiter_t;
    Tasks.radius = radius_t;
    
    for j = 1:nt
        if tf_t_loop(j) > 0
            for i = 1:na
                [~, ~, ~, ~, costs(i,j)] = ComputeCommandParamsWithVelocity(pos_a_loop(i,:)', v_a_loop(i,:)', pos_t(j,:)', v_t(j,:)', tf_t_loop(j), [], kdrag);
                %mycost(i_round) = costs(i,j)
                rewards(i,j) = r_bar(j) * prob_a_t(i,j);
                winners = zeros(na,nt);
                winners(i,j) = 1;
                utility(i,j) = CalcTaskUtility(pos_a_loop, v_a_loop, pos_t(j,:), v_t(j,:), tf_t_loop(j), r_bar(j), j, prob_a_t, winners, lambda, kdrag);
                %myutility(i_round) = utility(i,j)
            end
        end
    end
    
    if CommLimit
        for i = 1:na
            for j = (i+1):na
                G(i,j) = norm(pos_a_loop(i,:) - pos_a_loop(j,:)) < comm_distance;
                G(j,i) = G(i,j);
            end
        end
    end

    if use_CBBA
        % CBBA solution
        tic; [S_CBBA, p_CBBA, S_CBBA_ALL, rt_curr, Agents] = CBBASolution(Agents, G, Tasks)
        rt_full_simu(i_round,:) = rt_curr;
        toc;
    else
        % Test of fixed solution
        p_CBBA = {[1 4], [2 4], [3 4]}; S_CBBA = 1;
    end
    
    if use_OPT
        tic; [S_OPT, p_OPT, S_OPT_ALL] = OptimumSolution(Agents, G, Tasks);
        toc;
        [S_CBBA S_OPT]
    end
    
    U_next_tot(i_round) = S_CBBA;
    U_tot(i_round) = U_next_tot(i_round) + U_completed_tot;
    
    % Find the optimal control solution for the given allocation p_CBBA
    [X, completed_tasks_round, J_curr, J_to_completion_target(i_round+1,:)] = OptimalControlSolution(pos_a_loop, v_a_loop, pos_t, v_t, radius_t, p_CBBA, Agents, tf_t_loop, tloiter_t, time_step, n_rounds_loop, na, kdrag);
    X_full_simu{i_round} = X;
    p_CBBA_full_simu{i_round} = p_CBBA;
    S_CBBA_ALL_full_simu(i_round,:) = S_CBBA_ALL;
    J(i_round+1,:) = J(i_round,:) + J_curr;
    PlotAlloc(X, n_rounds_loop, na, colors, 'CBBA solution');
    
    for j = completed_tasks_round
            rt_completed = rt_completed + rt_curr(j);
            %pos_t(j,:) = [1 1] * 1e16;
            %U_completed_tot = U_completed_tot + S_CBBA_ALL(j);
    end
    
    completed_tasks_round = [];
    
    
    legend(legendUnq(gca));
    drawnow;
    
    % Update position and velocity of each agent
    pos_a_loop = X(1:2,:,2)';
    v_a_loop   = X(3:4,:,2)';
    
%     stop = 1;
%     for i = 1:na
%         if ~isempty(p_CBBA{i})
%             stop = 0;
%             break;
%         end
%     end
%         
%         
%     if (stop)
%         break;
%     end
    
   %pos_t = RemoveCompletedTasks(pos_t, ind_completed_tasks);
   
   simu_time_loop = simu_time_loop - time_step;
   time_start_loop = time_start_loop + time_step;
   n_rounds_loop = n_rounds_loop - 1;
   tf_t_loop = tf_t_loop - time_step;
end

U_tot = rt_completed - sum(J(end,:));

mkdir(sprintf('mat/%s/simu_%d', simu_name, simu_number));
save(sprintf('mat/%s/simu_%d/J_CommLimit_%d.mat', simu_name, simu_number, CommLimit), 'J');
save(sprintf('mat/%s/simu_%d/J_to_completion_target_CommLimit_%d.mat', simu_name, simu_number, CommLimit), 'J_to_completion_target');
save(sprintf('mat/%s/simu_%d/X_just_saved_CommLimit_%d.mat', simu_name, simu_number, CommLimit), 'X_full_simu');
save(sprintf('mat/%s/simu_%d/p_CBBA_just_saved_CommLimit_%d.mat', simu_name, simu_number, CommLimit), 'p_CBBA_full_simu');
save(sprintf('mat/%s/simu_%d/S_CBBA_ALL_just_saved_CommLimit_%d.mat', simu_name, simu_number, CommLimit), 'S_CBBA_ALL_full_simu');
save(sprintf('mat/%s/simu_%d/rt_just_saved_CommLimit_%d.mat', simu_name, simu_number, CommLimit), 'rt_full_simu');

save(sprintf('mat/%s/simu_%d/SimuParamsCell.mat', simu_name, simu_number), 'SimuParamsCell');

end




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

