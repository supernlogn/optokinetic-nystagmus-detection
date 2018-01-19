function [AMA, AMI, AMD, TMA, TMI, TBP]=produce_time_series(X1, Ts, filterorder, nsam, timesep, EXTREMA_PLOT, EXTREMA_SERIES_PLOT, FIR)

  % find best FIR
  % we tested 30, 20, 10
  % 10 is much more promising...
  b = ones(1,filterorder)/filterorder;
  xV = filtfilt(b,1,X1);
  if(FIR)
    hold on;
    plot(T, xV);
  end

  % extract time-series
  [locextM, ~] = extremes(X1, filterorder, nsam, 0.0, timesep, 0);
  extreme_time_idx = locextM(:,1);
  extrema_values = locextM(:,2);
  minimum_or_maximum = locextM(:,3);
    
  if(EXTREMA_PLOT)
    jacks = zeros(1, LENGTH);
    jacks(extreme_time_idx) = 40;
    jacks(extreme_time_idx -1) = -40;
    hold on;
    plot(T, jacks);
  end

  AMA = X1(extreme_time_idx);
  AMA = AMA(minimum_or_maximum == 1);
  AMI = X1(extreme_time_idx);
  AMI = AMI(minimum_or_maximum == -1);
  AMD = abs(AMA - AMI);

  if(minimum_or_maximum(1) == 1) % first comes the maximum
    TMI = Ts * (extreme_time_idx(2:end) - extreme_time_idx(1:end-1));
    TMA = Ts * (extreme_time_idx(3:end) - extreme_time_idx(2:end-1));
  else % first comes the minimum
    TMI = Ts * (extreme_time_idx(3:end) - extreme_time_idx(2:end-1));
    TMA = Ts * (extreme_time_idx(2:end) - extreme_time_idx(1:end-1));
  end

  TBP = Ts * (extreme_time_idx .* (minimum_or_maximum + 1) ) /2.0;
  TBP = TBP(TBP > 0);
  TBP = TBP(2:end) - TBP(1:end-1);

  if (EXTREMA_SERIES_PLOT)
    f = figure();
    extrema_series_plot(1,3,1, AMA, 'AMA');
    extrema_series_plot(1,3,2, AMI, 'AMI');
    extrema_series_plot(1,3,3, AMD, 'AMD');
    extrema_series_plot(1,3,4, TMA, 'TMA');
    extrema_series_plot(1,3,5, TMI, 'TMI');
    extrema_series_plot(1,3,6, TBP, 'TBP');
  end

end