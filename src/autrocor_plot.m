function autrocor_plot(yV, name)
    autocorr(yV, 20); % 95% confidence lvls
    title(sprintf('autocorrelation of %s', name));
    % yVpac = acf2pacf(yVac, 1);
    figure;
    parcorr(yV, 20);
    title(sprintf('partial autocorrelations of %s', name));
    % if(plot_portmanteu)
    %     portmanteauLB(yV, 20, 0.05, name);
    % end
end
