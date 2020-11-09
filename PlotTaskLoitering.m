function PlotTaskLoitering(pos_t, radius_t, type_t, color, name)
    n = 20;
    theta = linspace(0, 2*pi, n)';
    for i = 1:size(pos_t,1)
        if type_t(i) == 1
            pos = repmat(pos_t(i,:), n, 1) + radius_t(i) * [cos(theta) sin(theta)];
            plot(pos(:,1), pos(:,2), color, 'LineWidth', 1, 'DisplayName', name);
        end
    end
end