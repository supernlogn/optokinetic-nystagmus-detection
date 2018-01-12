%what to plot
BASIC = false;
FIR = false;
EXTREMA_PLOT = false;
EXTREMA_SERIES_PLOT = true;
LENGTH = 6000;
% read series
fileID1 = fopen('data/dat6v1.dat', 'r');
fileID2 = fopen('data/dat6v2.dat', 'r');
X1 = cell2mat(textscan(fileID1, '%f'));
X2 = cell2mat(textscan(fileID2, '%f'));

T = [1:LENGTH];
fs = 100; % Hz
Ts = 1.0 / fs; % seconds
if(BASIC)
    plot(T, X1)
end
% see if the signal has information
% if voids and non-voids exist inside it
% then there is information.
% plot(T, log(abs(X1) + eps));
Y1 = log(abs(X1(2:end))) - log(abs(X1(1:LENGTH-1)))
% plot(T(1:end-1), Y1)

% find best FIR
% we tested 30, 20, 10
% 10 is much more promising...
filterorder = 10
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





AMA = X1(extreme_time_idx)
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
TBP = TBP(TBP > 0)
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

% 

