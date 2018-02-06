TS_NUM = '2nd'; % '2nd'
xV = X2;

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

if(DBSCAN_CLUSTERING)
    epsilon=0.5;
    MinPts=10;
    IDX=DBSCAN(xM,epsilon,MinPts);

    %% Plot Results
    PlotClusterinResult(xM, IDX);
    title(['DBSCAN Clustering (\epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
end



% find best tau by using mutual information criterion
best_tau = 20;
if(FIND_BEST_TAU)
  tmax = 100;
  [mutM,f] = mutualinformation(xV, tmax);
  saveas(f, sprintf('assets/mutualinformation_%s.png', TS_NUM));
  best_tau = 20; % there is the first local minimum
end
tau = best_tau;


xM = embedDelays(xV, m_max, tau);
if(SCATTER_DIAGRAMS_PLOT)
  m = 0;
  f = plotd2d3(xM(:,1:3), sprintf('scatter-diagrams (tau=%d) for %s time series', tau, TS_NUM));
  saveas(f, 'assets/scatter_with_tau_xM_1-3.png');
%   f = plotd2d3([xM(:,1) xM(:,4) xM(:,5)], sprintf('scatter-diagrams (tau=%d) for %s time series', tau, TS_NUM));
%   saveas(f, 'assets/scatter_with_tau_xM_1_4_5.png');    
end

if(FALSE_NEAREST_CALC_PLOT)
  m_max = 20;
  [fnnM,mdistV,sddistV,f] = falsenearest(xV, tau, m_max, 10, 0, sprintf('false_nearest_calc_plot_%s', TS_NUM));
  saveas(f, sprintf('false_nearest_calc_plot_%s.png', TS_NUM));
end
best_m = 4; % because false nearest says so (FNN is below 0.1)


% calculate correlation dimension
if(CALCULATE_CORRELATION_DIMENSION)
  mmax = 7;
  [cor_dim,~,f] = corr_dim(xV, mmax, tau, PLOT_CORR_DIM);
  saveas(f, sprintf('cor_dim_plot_%s.png', TS_NUM));
end


% train a local model
if(TRAIN_LOCAL_MODEL)
  k = 3; % stands for k in k-nn
  q = 1;
  Tmax = 10;
  [nrmseV,~,f] = localpredictnrmse(xV, TEST_SET_LENGTH, tau, best_m, Tmax, k, 1,'local-model-fit_1');
  saveas(f, sprintf('assets/local_model_fit_%s.png', TS_NUM));
end
