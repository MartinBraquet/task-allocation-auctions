close all; clear all;

% Figure 1: cost and reward with/without commlimit
% Figure 2: utility with/without commlimit

simu_number = 6;
figure(1); hold on;
figure(2); hold on;

colors = lines(2);
maxYUtility = 0;
maxYReward = 0

for CommLimit = [0 1]

    load(sprintf('mat/Dynamics/simu_%d/SimuParamsCell.mat', simu_number));
    load(sprintf('mat/Dynamics/simu_%d/X_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
    load(sprintf('mat/Dynamics/simu_%d/J_to_completion_target_CommLimit_%d.mat', simu_number, CommLimit));
    load(sprintf('mat/Dynamics/simu_%d/J_CommLimit_%d.mat', simu_number, CommLimit));
    load(sprintf('mat/Dynamics/simu_%d/p_GCAA_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
    load(sprintf('mat/Dynamics/simu_%d/S_GCAA_ALL_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
    load(sprintf('mat/Dynamics/simu_%d/rt_just_saved_CommLimit_%d.mat', simu_number, CommLimit));

    na = size(J,2);

    t = (0:SimuParamsCell.n_rounds) * SimuParamsCell.time_step;

    J(isnan(J)) = 0;
    J_to_completion_target(isnan(J_to_completion_target)) = 0;

    figure(1)
    plot(t(1:end-1),sum(J(1:end-1,:),2) + sum(J_to_completion_target(2:end,:),2), 'color', colors(CommLimit+1,:), 'LineWidth', 3);
    plot(t(1:end-1),sum(rt_full_simu(1:end,:),2), '--', 'color', colors(CommLimit+1,:), 'LineWidth', 3);
    %ylim([0 max(sum(J(1:end-1,:),2) + sum(J_to_completion_target(2:end,:),2)) * 1.1]);
    maxYReward = max(maxYReward,max(sum(rt_full_simu(1:end,:),2)));
    
    figure(2); hold on;
    plot(t(1:end-3),sum(rt_full_simu(1:end-2,:),2) - (sum(J(1:end-3,:),2) + sum(J_to_completion_target(2:end-2,:),2)), 'color', colors(CommLimit+1,:), 'LineWidth', 3);
    
    maxYUtility = max(maxYUtility, max(sum(rt_full_simu(1:end-2,:),2) - (sum(J(1:end-3,:),2) + sum(J_to_completion_target(2:end-2,:),2))));
    
end

figure(1);
legend('Cost (unconstrained)', 'Reward (unconstrained)', 'Cost (constrained)', 'Reward (constrained)', 'Location', 'SouthEast');
ylim([0 maxYReward * 1.1]);
matlab2tikz(sprintf('mat/Dynamics/simu_%d/CostReward.tex',simu_number));

figure(2);
legend('Utility (unconstrained)', 'Utility (constrained)', 'Location', 'SouthEast');
ylim([0 maxYUtility * 1.1]);
matlab2tikz(sprintf('mat/Dynamics/simu_%d/TotalUtility.tex',simu_number));