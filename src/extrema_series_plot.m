function extrema_series_plot(ver_max_idx, hor_max_idx, idx, yV, name)
    subplot(ver_max_idx, hor_max_idx, idx);
    plot(1:length(yV), yV);
    grid on;
    title(name);
end