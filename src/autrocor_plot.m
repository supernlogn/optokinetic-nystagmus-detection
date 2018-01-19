function autrocor_plot(yV, name)
  f = figure;
  autocorr(yV, 20); % 95% confidence lvls
  s = sprintf('autocorrelation of %s', name);
  title(s);
  saveas(f, sprintf('assets/%s.%s', s, 'png'));
  % yVpac = acf2pacf(yVac, 1);
  f = figure;
  parcorr(yV, 20);
  s = sprintf('partial autocorrelations of %s', name)
  title(s);
  saveas(f, sprintf('assets/%s.%s',s,'png'));
end
