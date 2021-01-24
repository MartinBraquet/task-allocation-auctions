function M = PlotAnimationAndUtility(X_full_simu, SimuParamsCell, J, J_to_completion_target, rt_full_simu, PlotCommLimit, saveMovie)
    clear M;
    
    n_rounds = SimuParamsCell.n_rounds;
    time_step = SimuParamsCell.time_step;
    pos_t = SimuParamsCell.pos_t;
    map_width = SimuParamsCell.map_width;
    colors = SimuParamsCell.colors;
    radius_t = SimuParamsCell.radius_t;
    task_type = SimuParamsCell.task_type;
    comm_distance = SimuParamsCell.comm_distance;
    
    nRatioPointsFigure = 1;
    lineWidthFigure = 4;
    markerSizeFigure = 20;
    
    na = size(J,2);
    J_tot = J + J_to_completion_target;
    
    win = figure(1); hold on;
    win(1) = subplot(2, 3, 1);
    xlim([0 n_rounds*time_step]);
    ylim([0 max(max(J_tot))*1.1]);
    title('Cost');
    xlabel('t [s]');
    win(2) = subplot(2, 3, 4);
    xlim([0 n_rounds*time_step]);
    ylim([0 max(sum(rt_full_simu,2))*1.1]);
    xlabel('t [s]');
    win(3) = subplot(2, 3, [2 3 5 6]);
    xlim([0 1]); ylim([0 1]);
    t = (0:n_rounds) * time_step;
    set(win,'Nextplot','add'); set(gcf,'color','w');
    set(win,'fontsize', 25);
    for k = 2:n_rounds-1
        cla(win(1));
        t_plot = time_step * (k-1);
        for i = 1:na
            plot(win(1), t(1:k), J_tot(1:k,i), 'LineWidth', 2);
        end
        cla(win(2));
        plot(win(2), t(1:k), sum(rt_full_simu(1:k,:),2), 'k--', 'LineWidth', 3);
        U_tot = sum(rt_full_simu(1:k-1,:),2) - sum(J_tot(2:k,:),2);
        U_tot(1,:) = 0;
        plot(win(2), t(1:k-1), U_tot, 'k', 'LineWidth', 3);
        legend(win(2), 'Reward', 'Utility', 'Location', 'SouthEast');
        cla(win(3));
        PlotAllocTime(X_full_simu, t_plot, time_step, pos_t, map_width, colors, radius_t, task_type, nRatioPointsFigure, lineWidthFigure, markerSizeFigure);
        if PlotCommLimit
            pos_a = zeros(na,2);
            for i = 1:na
                pos_a(i,:) = X_full_simu{k}(1:2,i,1)';
            end
            PlotAgentRange(pos_a, comm_distance, colors, '')
        end
        drawnow;
        if saveMovie
            M(k-1) = getframe(gcf,[74 47 450 350]);
        end
    end
    if saveMovie
        figure;
        fps = floor(1 / time_step);
        movie(M,1,fps);
    else
        M = [];
    end
end