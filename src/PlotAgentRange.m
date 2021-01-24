function PlotAgentRange(pos_a, comm_distance, color, name)
    n = 20;
    theta = linspace(0, 2*pi, n)';
    for i = 1:size(pos_a,1)
        pos = repmat(pos_a(i,:), n, 1) + comm_distance * [cos(theta) sin(theta)];
        plot(pos(:,1), pos(:,2), '--', 'Color', color(i,:), 'LineWidth', 1, 'DisplayName', name);
    end
end