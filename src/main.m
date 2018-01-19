% addpath('src');
clear all;
close all;

%%%%%%%%%%%%%%%% FLAGS %%%%%%%%%%%%%%%%
BASIC = false;
FIR = false;
EXTREMA_PLOT = false;
EXTREMA_SERIES_PLOT = false;
REMOVES_TREND = false;
AUTOCORR_PLOT = true;
AKAIKE = false;

%%%%%%%%%%%%%%%% Input time Series & globals %%%%%%%%%%%%%%%%
% read series
fileID1 = fopen('data/dat6v1.dat', 'r');
fileID2 = fopen('data/dat6v2.dat', 'r');
X1 = cell2mat(textscan(fileID1, '%f'));
X2 = cell2mat(textscan(fileID2, '%f'));
LENGTH = 6000;
POLORDER = 4;
MAX_ORDER = 25;
T = [1:LENGTH];
fs = 100; % Hz
Ts = 1.0 / fs; % seconds

%%%%%%%%%%%%%%%% Time Series 1 %%%%%%%%%%%%%%%%

if(BASIC)
    plot(T, X1);
end
% see if the signal has information
% if voids and non-voids exist inside it
% then there is information.
% plot(T, log(abs(X1) + eps));
% Y1 = log(abs(X1(2:end))) - log(abs(X1(1:LENGTH-1)));
% plot(T(1:end-1), Y1)

filterorder = 10;
% we tested 30, 20, 10, 5
% 10 is much more promising...
nsam = 20;
timesep = 13;
% get EXTREMA SERIES 
[AMA, AMI, AMD, TMA, TMI, TBP] = produce_time_series(X1, Ts, filterorder, nsam, timesep, EXTREMA_PLOT, EXTREMA_SERIES_PLOT, FIR);

% all linear analysis
linear_analysis(AMA, 'AMA', MAX_ORDER, POLORDER, EXTREMA_PLOT, EXTREMA_SERIES_PLOT, REMOVES_TREND, AUTOCORR_PLOT, AKAIKE);


%%%%%%%%%%%%%%%% Time Series 2 %%%%%%%%%%%%%%%%

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
linear_analysis(AMA, 'AMA', MAX_ORDER, POLORDER, EXTREMA_PLOT, EXTREMA_SERIES_PLOT, REMOVES_TREND, AUTOCORR_PLOT, AKAIKE);
