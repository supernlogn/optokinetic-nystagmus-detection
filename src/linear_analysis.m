function linear_analyse(yV, name, MAX_ORDER, POLORDER, EXTREMA_PLOT, EXTREMA_SERIES_PLOT, REMOVES_TREND, AUTOCORR_PLOT, AKAIKE)

  % trend test
  if(REMOVES_TREND)
    % polynomial fit
    
    muyV = polynomialfit(yV, POLORDER);
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
    end
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
    autrocor_plot(yV, name);
    portmanteauLB(yV, 20, 0.05, name);
  end


  
  NRMSE = zeros(MAX_ORDER,1);
  if (AKAIKE)
    A = zeros(MAX_ORDER,1);
    for i = 1: 1: MAX_ORDER
      % for j = 1: 1: 10
        % mod = estimate(arima(i, 0, j), AMA);
        model = ar(yV, i);
        NRMSE(i) = nrmse_params(model, yV, i, 2 * MAX_ORDER + 1, false);

        A(i,1) = aic(mod);
    % end        
  end
  
  f = figure;
  plot(NRMSE);
  grid on;
  s = sprintf('NRMSE of %s',  name)
  title(s);
  saveas(f, sprintf('assets/%s.%s',s,'png'));
  
  f = figure;
  plot(A);
  grid on;
  s = sprintf('Akaike criterion of %s',  name)
  title(s);
  saveas(f, sprintf('assets/%s.%s',s,'png'));
end

end