TS_NUM = '1st'; % '2nd'
xV = X1;

m_max = 6; % this is precalculated by seeing the various scatter plots

xM = embedDelays(xV, m_max, 1);
if(SCATTER_DIAGRAMS_PLOT)
  f = plotd2d3(xM(:,1:3), sprintf('Multi dimensional scatter-diagrams for %s time series', TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_xM_1_2_3.png', TS_NUM));
  f = plotd2d3(xM(:,1:4), sprintf('Multi dimensional scatter-diagrams for %s time series', TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_xM_1_2_4.png', TS_NUM));
  f = plotd2d3(xM(:,1:5), sprintf('Multi dimensional scatter-diagrams for %s time series', TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_xM_1_2_5.png', TS_NUM));
  f = plotd2d3(xM, sprintf('Multi dimensional scatter-diagrams for %s time series', TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_xM_1_2_6.png', TS_NUM));  
end
if(MORE_SCATTER_DIAGRAMS_PLOT)
  xM2 = embedDelays(xV, 10, 1);
  f = plotd2d3(xM2(:,1:2), sprintf('Multi dimensional scatter-diagrams for %s time series tau = 1', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 1', TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_2.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,3)], sprintf('Multi dimensional scatter-diagrams for %s time series tau = 2', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 2', TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_3.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,4)], sprintf('Multi dimensional scatter-diagrams for %s time series tau = 3', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 3', TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_4.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,5)], sprintf('Multi dimensional scatter-diagrams for %s time series tau = 4', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 4', TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_5.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,6)], sprintf('Multi dimensional scatter-diagrams for %s time series tau = 5', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 5', TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_6.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,7)], sprintf('Multi dimensional scatter-diagrams for %s time series tau = 6', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 6', TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_7.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,8)], sprintf('Multi dimensional scatter-diagrams for %s time series tau = 7', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 7', TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_8.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,9)], sprintf('Multi dimensional scatter-diagrams for %s time series tau = 8', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 8', TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_9.png', TS_NUM));
  f = plotd2d3([xM2(:,1) xM2(:,10)], sprintf('Multi dimensional scatter-diagrams for %s time series tau = 9', TS_NUM));
  title(sprintf('Multi dimensional scatter-diagrams for %s time series τ = 9',TS_NUM), 'Interpreter','latex');
  saveas(f, sprintf('assets/scatter_%s_xM_1_10.png', TS_NUM));    
end


% find best tau by using mutual information criterion
best_tau = 10;
if(FIND_BEST_TAU)
  tmax = 100;
  [mutM,f] = mutualinformation(xV, tmax);
  saveas(f, sprintf('assets/mutualinformation_%s.png', TS_NUM));
  best_tau = 10; % there is no local minimum so we choose a
                 % bending point
end
tau = best_tau;

xM = embedDelays(xV, m_max, tau);
if(SCATTER_DIAGRAMS_PLOT)
  m = 0;
  f = plotd2d3(xM(:,1:2), sprintf('scatter-diagrams (tau=%d) for %s time series', tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1_2.png', TS_NUM));
  f = plotd2d3(xM(:,1:3), sprintf('scatter-diagrams (tau=%d) for %s time series', tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1-3.png', TS_NUM));
  f = plotd2d3([xM(:,1), xM(:,4)], sprintf('scatter-diagrams (tau=%d) for %s time series,lag=3', tau, TS_NUM));
  saveas(f, sprintf('assets/scatter_%s_with_tau_xM_1_4.png', TS_NUM));    
end

if(FALSE_NEAREST_CALC_PLOT)
  m_max = 10;
  [fnnM,mdistV,sddistV,f] = falsenearest(xV, tau, m_max, 10, 0, sprintf('FNN for %s time-series', TS_NUM));
  saveas(f, sprintf('assets/false_nearest_calc_plot_%s.png', TS_NUM));
end

% Noise is the same for every plot, so it is not corelated with the input time series
% it is white noise because n --> +infty => Normalized distribution of noise.
% Its deviation is the same through the sample time.
if(DBSCAN_CLUSTERING)
    epsilon=0.5;
    MinPts=10;
    IDX=DBSCAN(xM,epsilon,MinPts);
    %% Plot Results
    f = figure();
    subplot(2,1,1);
    PlotClusterinResult(xM(:,1:3), IDX);
    title(['DBSCAN Clustering (m=', 3,', \epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
    subplot(2,1,2);
    PlotClusterinResult(xM(:,1:4), IDX);
    title(['DBSCAN Clustering (m=', 4,', \epsilon = ' num2str(epsilon) ', MinPts = ' num2str(MinPts) ')']);
    saveas(f, sprintf('assets/DBSCAN_%s.png', TS_NUM));
end


best_m = 3; % because when 4-th or 5-th dimension enter it causes catastrophy

% calculate correlation dimension
if(CALCULATE_CORRELATION_DIMENSION)
  mmax = 10;
  f = correlationdimension(xV, tau, mmax,' ');
  % [cor_dim,~,f] = corr_dim(xV, mmax, tau, PLOT_CORR_DIM);
  saveas(f, sprintf('assets/cor_dim_plot_%s.png', TS_NUM));
end


% train a local model
if(TRAIN_LOCAL_MODEL)
  k = 3; % stands for k in k-nn
  q = 1;
  Tmax = 10;
  [nrmseV,~,f] = localpredictnrmse(xV, TEST_SET_LENGTH, tau, best_m, Tmax, k, 1,'local-model-fit_1');
  saveas(f, sprintf('assets/local_model_fit_%s.png', TS_NUM));
end
