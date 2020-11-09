function M = PlotAnimation(X_full_simu, n_rounds, time_step, pos_t, map_width, colors, radius_t, task_type)
    figure;
    clear M;
    for k = 1:n_rounds-1
        t_plot = time_step * (k-1);
        clf; hold on;
        PlotAllocTime(X_full_simu, t_plot, time_step, pos_t, map_width, colors, radius_t, task_type);
        %drawnow;
        M(k) = getframe(gcf,[74 47 450 350]);
    end
    figure;
    fps = floor(1 / time_step);
    movie(M,1,fps);
end