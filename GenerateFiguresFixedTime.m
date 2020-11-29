close all; clear all;

simu_number = 6;
PlotCommLimit = 0;
saveMovie = 0;

nRatioPointsFigure = 10;
lineWidthFigure = 2;
markerSizeFigure = 12;

load(sprintf('mat/Dynamics/simu_%d/SimuParamsCell.mat', simu_number));

for t_plot = [0 4 10]
    for CommLimit = [0 1]
        load(sprintf('mat/Dynamics/simu_%d/X_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
        load(sprintf('mat/Dynamics/simu_%d/J_to_completion_target_CommLimit_%d.mat', simu_number, CommLimit));
        load(sprintf('mat/Dynamics/simu_%d/J_CommLimit_%d.mat', simu_number, CommLimit));
        load(sprintf('mat/Dynamics/simu_%d/p_CBBA_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
        load(sprintf('mat/Dynamics/simu_%d/S_CBBA_ALL_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
        load(sprintf('mat/Dynamics/simu_%d/rt_just_saved_CommLimit_%d.mat', simu_number, CommLimit));
        
        figure; hold on; PlotAllocTime(X_full_simu, t_plot, SimuParamsCell.time_step, SimuParamsCell.pos_t, SimuParamsCell.map_width, SimuParamsCell.colors, SimuParamsCell.radius_t, SimuParamsCell.task_type, nRatioPointsFigure, lineWidthFigure, markerSizeFigure);
        sprintf('Alloc_5_5_t_%1.0f_CommLimit_%d.tex',t_plot, CommLimit)
        matlab2tikz(sprintf('mat/Dynamics/simu_%d/Alloc_5_5_t_%1.0f_CommLimit_%d.tex',simu_number,t_plot, CommLimit));
    end
end