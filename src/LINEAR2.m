if(BASIC)
    plot(T, X2);
end
% see if the signal has information
% if voids and non-voids exist inside it
% then there is information.
% plot(T, log(abs(X1) + eps));
% Y1 = log(abs(X1(2:end))) - log(abs(X1(1:LENGTH-1)));
% plot(T(1:end-1), Y1)

filterorder = 5;
% we tested 30, 20, 10, 5
% 5 is much more promising...
nsam = 20;
timesep = 13;
% get EXTREMA SERIES 
[AMA, AMI, AMD, TMA, TMI, TBP] = produce_time_series(X2, Ts, filterorder, nsam, timesep, EXTREMA_PLOT, EXTREMA_SERIES_PLOT, FIR);

% all linear analysis
linear_analysis(AMA, 'AMA2', MAX_ORDER_AR, MAX_ORDER_MA, POLORDER, EXTREMA_PLOT, EXTREMA_SERIES_PLOT, REMOVES_TREND, REMOVES_TREND_PLOT, AUTOCORR_PLOT, AKAIKE);
