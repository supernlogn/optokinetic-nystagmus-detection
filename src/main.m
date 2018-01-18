% addpath('src');
%what to plot
BASIC = false;
FIR = false;
EXTREMA_PLOT = false;
EXTREMA_SERIES_PLOT = false;
REMOVES_TREND = false;
AUTOCORR_PLOT = false;
AKAIKE = false;
LENGTH = 6000;
 
% read series
fileID1 = fopen('data/dat6v1.dat', 'r');
fileID2 = fopen('data/dat6v2.dat', 'r');
X1 = cell2mat(textscan(fileID1, '%f'));
X2 = cell2mat(textscan(fileID2, '%f'));

T = 1:LENGTH;
fs = 100; % Hz
Ts = 1.0 / fs; % seconds
if(BASIC)
    plot(T, X1)
end
% see if the signal has information
% if voids and non-voids exist inside it
% then there is information.
% plot(T, log(abs(X1) + eps));
%Y1 = log(abs(X1(2:end))) - log(abs(X1(1:LENGTH-1)));
% plot(T(1:end-1), Y1)

% find best FIR
% we tested 30, 20, 10
% 10 is much more promising...
filterorder = 10;
b = ones(1,filterorder)/filterorder;
xV = filtfilt(b,1,X1);
if(FIR)
    hold on;
    plot(T, xV)
end

% extract time-series
nsam = 20;
timesep = 13;
[locextM, ~] = extremes(X1, filterorder, nsam, 0.0, timesep, 0);
extreme_time_idx = locextM(:,1);
extrema_values = locextM(:,2);
minimum_or_maximum = locextM(:,3);
jacks = zeros(1, LENGTH);
jacks(extreme_time_idx) = 40;
jacks(extreme_time_idx -1) = -40;
if(EXTREMA_PLOT)
    hold on;
    plot(T, jacks);
end





AMA = X1(extreme_time_idx);
AMA = AMA(minimum_or_maximum == 1);


AMI = X1(extreme_time_idx);
AMI = AMI(minimum_or_maximum == -1);

AMD = abs(AMA - AMI);
% AMD = AMA - AMI;

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
    subplot(1,3,1);
    plot(1:length(AMA), AMA);
    grid on;
    title('AMA');

    subplot(1,3,2);
    plot(1:length(AMI), AMI);
    grid on;
    title('AMI');

    subplot(1,3,3);
    plot(1:length(AMD), AMD);
    grid on;
    title('AMD');

    f = figure();
    subplot(1,3,1);
    plot(1:length(TMA), TMA);
    grid on;
    title('TMA');

    subplot(1,3,2);
    plot(1:length(TMI), TMI);
    grid on;
    title('TMI');

    subplot(1,3,3);
    plot(1:length(TBP), TBP);
    grid on;
    title('TBP');    
end

% trend test

if (REMOVES_TREND)

    % polynomial fit
    
    % polorder = 4;
    % muAMD = polynomialfit(AMD,polorder);
    % AMD_detr = AMD - muAMD;
    % f = figure();
    % subplot(1,2,1);
    % plot(1:length(AMD), AMD);
    % grid on;
    % title('AMD');
    % subplot(1,2,2);
    % plot(1:length(AMD_detr), AMD_detr);
    % grid on;
    % title('AMD_detr');

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

if (AUTOCORR_PLOT)
   
    %[AMAac] = autocorrelation(AMA, 50, 'AMA');
    %autocorr(AMA,20); % 95% confidence lvls
    %AMApac = acf2pacf(AMAac, 1);
    %figure;
    %parcorr(AMA,20);
    %portmanteauLB(AMA, 20, 0.05, 'AMA');
    
    %[AMIac] = autocorrelation(AMI, 50, 'AMI');
    %autocorr(AMI,20); % 95% confidence lvls
    %AMIpac = acf2pacf(AMIac, 1);
    %figure;
    %parcorr(AMI,20);
    %portmanteauLB(AMI, 20, 0.05, 'AMI');
    
    %[AMDac] = autocorrelation(AMD, 50, 'AMD');
    %autocorr(AMD,20); % 95% confidence lvls
    %AMDpac = acf2pacf(AMDac, 1);
    %figure;
    %parcorr(AMD,20);
    %portmanteauLB(AMD, 20, 0.05, 'AMD');
    
    %[TMAac] = autocorrelation(TMA, 50, 'TMA');
    %autocorr(TMA,20); % 95% confidence lvls
    %TMApac = acf2pacf(TMAac, 1);
    %figure;
    %parcorr(TMA,20);
    %portmanteauLB(TMA, 20, 0.05, 'TMA');
    
    %[TMIac] = autocorrelation(TMI, 50, 'TMI');
    %autocorr(TMI,20); % 95% confidence lvls
    %TMIpac = acf2pacf(TMIac, 1);
    %figure;
    %parcorr(TMI,20);
    %portmanteauLB(TMI, 20, 0.05, 'TMI');
    
    %[TBPac] = autocorrelation(TBP, 50, 'TBP');
    %autocorr(TBP,30); % 95% confidence lvls
    %TBPpac = acf2pacf(TBPac, 1);
    %figure;
    %parcorr(TBP,20);
    %portmanteauLB(TBP, 20, 0.05, 'TBP');
    
end

% AIC test

if (AKAIKE)
   
    A = zeros(35,1);
    
    for i = 1: 1: 35
        
        %mod = ar(AMA, i);
        %mod = ar(AMI, i);
        %mod = ar(AMD, i);
        %mod = ar(TMA, i);
        %mod = ar(TMI, i);
        %mod = ar(TBP, i);
        A(i,1) = aic(mod); 
        
    end
    
    figure
    plot(A);
    grid on
    
end

