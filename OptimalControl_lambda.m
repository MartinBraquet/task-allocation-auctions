%% Decentralized Control for Dynamic Task Allocation Problems for Multi-Agent Systems with Auctions
% Analysis of the weight variation (lambda) between the reward and the cost of the tasks
%
% Author: Martin Braquet
% Date: September 2020

addpath('CNP_CBBA/');
close all; clear all;
rng('default');
rng(8);

CommLimit = 1;
use_CBBA = 1;
use_OPT = 0;

na = 10;
nt = 10;
Lt = 1;

map_width = 1;
comm_distance = 2 * map_width;

%velocity = 1:na;
%velocity = 1 * ones(1,nt);
max_speed = 0.1;
v_a = (2 * rand(na,2) - 1) * max_speed;

lambda = 1;
simu_time = 5;

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

lambda_vector = 0:10:200;
n_lambda = length(lambda_vector);
simu_time_vector = 3; %1:1:6;
n_simu_time = length(simu_time_vector);
i_simu_time = 0;

for simu_time = simu_time_vector
    i_simu_time = i_simu_time + 1;
    i_lambda = 0;
    
    pos_a = (0.1 + 0.8 * rand(na,2)) * map_width;
    pos_t = (0.1 + 0.8 * rand(na,2)) * map_width;
    %tf_t = rand(nt,1) * simu_time;
    %tf_t = [5*ones(1,3) 10*ones(1,1)];
    tf_t =  simu_time / 1.05 * (1 + 0.05 * rand(nt,1));
    %tf_t = 10*ones(1,nt);

    [tf_t, idx] = sort(tf_t);
    pos_t = pos_t(idx,:);
    
    for lambda = lambda_vector
        i_lambda = i_lambda + 1;
        n_rounds = 40;
        time_step = simu_time / n_rounds;
        time_start = 0;

        figure; hold on;
        colors = lines(na);
        %subplot(n_lambda, n_simu_time, (i_lambda - 1) * n_lambda + i_simu_time);
        clf; hold on;
        xlim([0 map_width]);
        ylim([0 map_width]);
        xlabel('x [m]');
        ylabel('y [m]');
        title(sprintf('Task-Agent allocation (lambda = %5.2f, tf = %d)', lambda, simu_time));
        for i = 1:na
            plot(pos_a(i,1), pos_a(i,2), '*', 'Color', colors(i,:), 'MarkerSize', 10, 'DisplayName', 'Agents');
        end
        plot(pos_t(:,1), pos_t(:,2),'rs', 'MarkerSize', 10, 'DisplayName', 'Targets', 'MarkerFaceColor',[1 .6 .6]);
        PlotAgentRange(pos_a, comm_distance, colors, 'Comm Range')

        Agents.Pos = pos_a;

        Tasks.Pos = pos_t;
        Tasks.N = nt;
        Tasks.tf = tf_t;
        Tasks.lambda = lambda;

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

        % CBBA solution
        tic; [S_CBBA, p_CBBA, S_CBBA_ALL] = CBBASolution(Agents, G, Tasks)
        toc;        

        if use_OPT
            % Optimal solution
            tic; [S_OPT, p_OPT, S_OPT_ALL] = OptimumSolution(Agents, G, Tasks);
            toc;
            [S_CBBA S_OPT]
        end

        % Find the optimal control solution for the given allocation p_CBBA
        X = OptimalControlSolution(pos_a, v_a, pos_t, p_CBBA, tf_t, time_step, n_rounds, na);
        PlotAlloc(X, n_rounds, na, colors, 'CBBA solution');

        legend(legendUnq(gca));
        drawnow;
    end
end