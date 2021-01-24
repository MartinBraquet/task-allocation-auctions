function [] = PlotAllocTime(X_full_simu, t_plot, time_step, pos_t, map_width, colors, radius_t, task_type, nRatioPointsFigure, lineWidthFigure, markerSizeFigure)
    xlim([0 map_width]);
    ylim([0 map_width]);
    xlabel('x [m]');
    ylabel('y [m]');
    na = size(X_full_simu{1}, 2);
    n_round = size(X_full_simu{1}, 3);
    plot(pos_t(:,1), pos_t(:,2),'ks', 'MarkerSize', markerSizeFigure/2.5, 'MarkerFaceColor',[0 0 0]);   
    PlotTaskLoitering(pos_t, radius_t, task_type, 'k--', 'Task loitering');
    
    round_plot = floor(t_plot / time_step) + 1;
    if round_plot >= n_round
        round_plot = n_round-1;
    end
    X_prev = zeros(4, na, round_plot);
    for k = 1:round_plot
        X_prev(:,:,k) = X_full_simu{k}(:,:,1);
    end
    
    X_next = zeros(4, na, n_round - round_plot);
    for i = 1:na
        X_next(:,i,:) = X_full_simu{round_plot}(:,i,2:end);
    end
    
    for i = 1:na
        xX_prev = reshape(X_prev(:,i,:),[4, size(X_prev, 3)]);
        xX_next = reshape(X_next(:,i,:),[4, size(X_next, 3)]);
        plot(xX_prev(1,1:nRatioPointsFigure:end), xX_prev(2,1:nRatioPointsFigure:end), 'Color', colors(i,:), 'LineWidth', lineWidthFigure);
        plot(xX_next(1,1:nRatioPointsFigure:end), xX_next(2,1:nRatioPointsFigure:end), '--', 'Color', colors(i,:), 'LineWidth', lineWidthFigure-1);
        plot(xX_next(1), xX_next(2), 'h', 'Color', colors(i,:), 'MarkerSize', markerSizeFigure, 'MarkerFaceColor', colors(i,:)); 
    end
end