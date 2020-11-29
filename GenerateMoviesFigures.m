close all; clear all;

simu_number = 6;
CommLimit = 0;
PlotCommLimit = 0;
saveMovie = 0;

load(sprintf('mat/Dynamics/simu_%d/X_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/J_to_completion_target_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/J_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/p_CBBA_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/S_CBBA_ALL_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/rt_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
load(sprintf('mat/Dynamics/simu_%d/SimuParamsCell.mat', simu_number));

MAllocUtil = PlotAnimationAndUtility(X_full_simu, SimuParamsCell, J, J_to_completion_target, rt_full_simu, PlotCommLimit, saveMovie);
if saveMovie
    save(sprintf('mat/Dynamics/MAllocUtil_%d.mat', CommLimit), 'MAllocUtil');
end

%MAlloc = PlotAnimation(X_full_simu, n_rounds, time_step, pos_t_initial, map_width, colors, radius_t, task_type);
% save(sprintf('mat/MAlloc_%d.mat', k), 'MAllocUtil');

% v = VideoWriter('Film_alloc_5_5.avi');
% v.Quality = 100;
% open(v);
% writeVideo(v,M);
% close(v);



% for t_plot = [0 3 9.9]
%     figure; hold on; PlotAllocTime(X_full_simu, t_plot, time_step, pos_t_initial, map_width, colors, radius_t, task_type);
%     sprintf('Alloc_5_5_t_%d.tex',t_plot)
%     matlab2tikz(sprintf('Alloc_5_5_t_%d.tex',t_plot));
%     figure; hold on; PlotAllocTime(X_full_simu_range, t_plot, time_step, pos_t_initial, map_width, colors, radius_t, task_type);
%     matlab2tikz(sprintf('Alloc_range_5_5_t_%d.tex',t_plot));
% end