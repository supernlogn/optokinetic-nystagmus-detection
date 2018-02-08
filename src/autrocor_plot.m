function autrocor_plot(yV, MAX_LAG, name)
  f = figure;
  autocorr(yV, MAX_LAG); % 95% confidence lvls
  s = sprintf('autocorrelation of %s', name);
  title(s);
  saveas(f, sprintf('assets/autocorrelation_%s.%s', name, 'png'));
  % yVpac = acf2pacf(yVac, 1);
  f = figure;
  parcorr(yV, MAX_LAG);
  s = sprintf('partial autocorrelations of %s', name)
  title(s);
  saveas(f, sprintf('assets/partial_autocorrelations_%s.%s',name,'png'));
end
