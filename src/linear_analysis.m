function linear_analyse(yV, name, MAX_ORDER_AR, MAX_ORDER_MA, POLORDER, EXTREMA_PLOT, EXTREMA_SERIES_PLOT, REMOVES_TREND, REMOVES_TREND_PLOT, AUTOCORR_PLOT, AKAIKE, DST_NUM)

  % trend test
  if(REMOVES_TREND)
    % polynomial fit
    
    [muyV, bV] = polynomialfit(yV, POLORDER);
    % save coefficients to a file
    save(sprintf('assets/polcoeff_%s_%s.txt', name, DST_NUM), 'bV', '-ascii');
    yV_detr = yV - muyV;
    if(REMOVES_TREND_PLOT)
      f = figure();
      subplot(1,2,1);
      plot(1:length(yV), yV);
      grid on;
      title(name);
      subplot(1,2,2);
      plot(1:length(yV_detr), yV_detr);
      grid on;
      title(sprintf('%s_detr', name));
      saveas(f, sprintf('rm_trend_%s_%s.png',name, DST_NUM));
    end
    yV_detr = yV(2:end) - yV(1:end-1);
    % first differences, log returns: FAILED

    % AMI_1 = AMI(2:end) - AMI(1:end-1);
    % AMI_2 = abs(log(AMI(2:end))) - abs(log(AMI(1:end-1)));
    % plot(AMD);
    % hold on;
    % grid on;
    % plot(AMD_1);
    % f = figure();
    % subplot(1,2,1);
    % plot(1:length(AMI), AMI);
    % title('AMI');
    % subplot(1,2,2);
    % plot(1:length(AMI_1), AMI_1);
    % grid on;
    % title('AMIfd');
    % hold on;
    % plot(AMD_2);
    % legend('AMD','AMDfd')%,'AMDld')
  end
  % autocorrelation & partial autocorrelation fn & Ljung-Box Portmanteau
  if(AUTOCORR_PLOT)
    autrocor_plot(yV_detr, MAX_ORDER_AR, name);
    portmanteauLB(yV_detr, MAX_ORDER_AR, 0.05, name);
  end

  if (AKAIKE)
    if(MAX_ORDER_AR ~= 0) % AR process
      ar_estimate(yV_detr, name, 1, MAX_ORDER_AR);
      ar_estimate(yV_detr, name, 2, MAX_ORDER_AR);
    end
    if(MAX_ORDER_MA ~= 0) % MA process
      ma_estimate(yV_detr, name, 1, MAX_ORDER_MA);
      ma_estimate(yV_detr, name, 2, MAX_ORDER_MA);
    end
    if(MAX_ORDER_AR ~=0 && MAX_ORDER_MA ~= 0)
      arma_estimate(yV_detr, name, 1, MAX_ORDER_AR, MAX_ORDER_MA);
      arma_estimate(yV_detr, name, 2, MAX_ORDER_AR, MAX_ORDER_MA);
    end

  end

end

function ar_estimate(yV, name, T, MAX_ORDER_AR)
  nlast = ceil(0.9 * length(yV));
  NRMSE = zeros(MAX_ORDER_AR,1);
  A = zeros(MAX_ORDER_AR,1);
  for i = 1: 1: MAX_ORDER_AR
    [n, ~, ~, ~, A(i), ~, ~] = fitARMA(yV(1:nlast), i, 0, T);
    NRMSE(i) = n(end);
  end
  f = figure;
  plot(NRMSE);
  grid on;
  s = sprintf('NRMSE of %s for AR process',  name);
  title(s);
  saveas(f, sprintf('assets/AR_NRMSE_%s.%s', name, 'png'));

  f = figure;
  plot(A);
  grid on;
  s = sprintf('Akaike criterion of %s for AR process',  name);
  title(s);
  saveas(f, sprintf('assets/AR_AIC_%s.%s', name, 'png'));
  % for best MA plot nrmse prediction error for T=1, T=2
  [m best_p] = min(A(1:min(MAX_ORDER_AR,10)));
  best_p = best_p(1)
  f = predictARMAnrmse(yV, best_p, 0, 2, nlast, 'prediction error for best AR');
  saveas(f, sprintf('assets/AR_best_pred_%s.%s', name, 'png'));
end

function ma_estimate(yV, name, T, MAX_ORDER_MA)
  nlast = ceil(0.9 * length(yV));
  NRMSE = zeros(1, MAX_ORDER_MA);
  A = zeros(1, MAX_ORDER_MA);
  for j = 1: 1: MAX_ORDER_MA
    [n, ~, ~, ~, A(j), ~, ~] = fitARMA(yV(1:nlast), 0, j, T);
    NRMSE(j) = n(end);
  end
  f = figure;
  plot(NRMSE);
  grid on;
  s = sprintf('NRMSE of %s for MA process', name);
  title(s);
  saveas(f, sprintf('assets/MA_NRMSE_%s.%s', name, 'png'));
  
  f = figure;
  plot(A);
  grid on;
  s = sprintf('Akaike criterion of %s for MA process', name);
  title(s);
  saveas(f, sprintf('assets/MA_AIC_%s.%s', name, 'png'));
  % for best MA plot nrmse prediction error for T=1, T=2
  [m best_q] = min(A(:));
  best_q = best_q(1)
  f = predictARMAnrmse(yV, 0, best_q, 2, nlast, 'prediction error for best MA');
  saveas(f, sprintf('assets/MA_best_pred_%s.%s', name, 'png'));
end

function arma_estimate(yV, name, T, MAX_ORDER_AR, MAX_ORDER_MA)
  nlast = ceil(0.9 * length(yV));
  NRMSE = zeros(MAX_ORDER_AR, MAX_ORDER_MA);
  A = zeros(MAX_ORDER_AR, MAX_ORDER_MA);
  for i = 1: 1 : MAX_ORDER_AR
    for j = 1: 1 : MAX_ORDER_MA
      [n, ~, ~, ~, A(i,j), ~, ~] = fitARMA(yV(1:nlast), i, j, T);
      NRMSE(i,j) = n(end);
    end
  end
  % plot nrmse for arma
  f = figure;
  grid on;
  hold on;
  set(gca,'xtick',1:MAX_ORDER_AR);
  xlabel('order p');
  for j = 1: 1 : MAX_ORDER_MA
    plot([1:MAX_ORDER_AR], NRMSE(:,j), 'DisplayName', sprintf('(p,q) =(*,%d)', j));
  end
  legend('show');
  s = sprintf('NRMSE of %s for ARMA process', name);
  title(s);
  saveas(f, sprintf('assets/ARMA_NRMSE_%s.%s', name, 'png'));
  % plot aic for arma
  f = figure;
  grid on;
  hold on;
  set(gca,'xtick',1:MAX_ORDER_AR);
  xlabel('order p');      
  for j = 1: 1 : MAX_ORDER_MA
    plot([1:MAX_ORDER_AR], A(:,j), 'DisplayName', sprintf('(p,q) = (*,%d)', j));
  end
  legend('show');
  s = sprintf('Akaike criterion of %s for ARMA process', name);
  title(s);
  saveas(f, sprintf('assets/ARMA_AIC_%s.%s', name, 'png'));
  % for best ARMA plot nrmse prediction error for T=1, T=2
  B = A(1:min(10, MAX_ORDER_AR),1:min(3,MAX_ORDER_MA));
  [m n] = min(B(:));
  [best_p best_q] = ind2sub(size(B), n(1));
  f = predictARMAnrmse(yV, best_p, best_q, 2, nlast, 'prediction error for best ARMA');
  saveas(f, sprintf('assets/ARMA_best_pred_%s.%s', name, 'png'));
end
