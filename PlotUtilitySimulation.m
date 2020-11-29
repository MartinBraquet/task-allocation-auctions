close all; clear all;

simu_number = 6;
CommLimit = 0;
load(sprintf('mat/Dynamics/simu_%d/SimuParamsCell.mat', simu_number));
load(sprintf('mat/Dynamics/simu_%d/X_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/J_to_completion_target_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/J_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/p_CBBA_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/S_CBBA_ALL_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/rt_just_saved_CommLimit_%d.mat', simu_number, CommLimit));

na = size(J,2);

J(isnan(J)) = 0;

J_to_completion_target(isnan(J_to_completion_target)) = 0;

%rt = p_CBBA_full_simu ...

figure; hold on;
for i = 1:na
    plot(J(:,i));
end
plot(sum(J,2), 'LineWidth', 3);
title('Cost up to t');

figure; hold on;
for i = 1:na
    plot(J_to_completion_target(:,i));
end
plot(sum(J_to_completion_target,2), 'LineWidth', 3);
title('Estimated cost from t to end');

figure; hold on;
ylim([0 max(sum(J(1:end-1,:),2) + sum(J_to_completion_target(2:end,:),2)) * 1.1]);
for i = 1:na
    plot(sum(J(1:end-1,i),2) + sum(J_to_completion_target(2:end,i),2));
end
plot(sum(J(1:end-1,:),2) + sum(J_to_completion_target(2:end,:),2), 'LineWidth', 3);
title('Estimated cost from start to end');


figure; hold on;
plot(sum(rt_full_simu(1:end-2,:),2));
title('Reward for the assignement at time t');

figure; hold on;
plot(sum(rt_full_simu(1:end-2,:),2) - (sum(J(1:end-3,:),2) + sum(J_to_completion_target(2:end-2,:),2)));
title('Utility for the assignement at time t');
