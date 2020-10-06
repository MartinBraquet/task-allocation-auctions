function PlotAlloc(X, n_rounds, na, color, name)

    for i = 1:na      
        xx = reshape(X(:,i,:),[4,n_rounds+1]);
        plot(xx(1,:),xx(2,:), ':', 'Color', color(i,:), 'LineWidth', 2, 'DisplayName', name);
    end

end