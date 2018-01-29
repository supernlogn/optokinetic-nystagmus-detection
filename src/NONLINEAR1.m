TS_NUM = '1st'; % '2nd'
xV = X1;

m_max = 5; % this is precalculated by seeing the various scatter plots

xM = embedDelays(xV, m_max, 2);
if(SCATTER_DIAGRAMS_PLOT)
    f = plotd2d3(xM(:,1:3), sprintf('Multi dimensional scatter-diagrams for % time series', TS_NUM));
    saveas(f, 'assets/scatter_xM_1-3.png');
    f = plotd2d3(xM(:,1:4), sprintf('Multi dimensional scatter-diagrams for % time series', TS_NUM));
    saveas(f, 'assets/scatter_xM_1_2_4.png');
    f = plotd2d3(xM, sprintf('Multi dimensional scatter-diagrams for % time series', TS_NUM));
    saveas(f, 'assets/scatter_xM_1_2_5.png');
end
% Noise is the same for every plot, so it is not corelated with the input time series
% it is white noise because n --> +infty => Normalized distribution of noise.
% Its deviation is the same through the sample time.


% find best tau by using mutual information criterion
best_tau = 10;
if(FIND_BEST_TAU)
    tmax = 100;
    mutM = mutualinformation(xV, tmax);
    best_tau = 10; % there is no local minimum so we choose a
                   % bending point
end
tau = best_tau;

xM = embedDelays(xV, m_max, tau);
if(SCATTER_DIAGRAMS_PLOT)
    f = plotd2d3(xM(:,1:3), sprintf('scatter-diagrams (tau=%d, m=%d) for %s time series', tau, m, TS_NUM));
    saveas(f, 'assets/scatter_with_tau_xM_1-3.png');
    f = plotd2d3([xM(:,1) xM(:,4) xM(:,5)], sprintf('scatter-diagrams (tau=%d, m=%d) for %s time series', tau, m, TS_NUM));
    saveas(f, 'assets/scatter_with_tau_xM_1_4_5.png');    
end

best_m = 3; % because when 4th and 5th dimension entered it causes catastrophy

% calculate correlation dimension
if(CALCULATE_CORRELATION_DIMENSION)
    mmax = 7;
    cor_dim = corr_dim(xV, mmax, tau);
end
best_v = 3; % It could also be 2


% train a local model
if(TRAIN_LOCAL_MODEL)
    k = best_v; % stands for k in k-nn
    [nrmseV,f] = localpredictnrmse(xV, TEST_SET_LENGTH, tau, best_m, 10, best_v, q=1,'local-model-fit_1');
    saveas(f, sprintf('local_model_fit_%s.png', TS_NUM));
end
