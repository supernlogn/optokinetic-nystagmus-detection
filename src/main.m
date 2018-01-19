% addpath('src');
system('rm assets/*');
clear all;
close all;

%%%%%%%%%%%%%%%% FLAGS %%%%%%%%%%%%%%%%
BASIC = true;
FIR = true;
EXTREMA_PLOT = true;
EXTREMA_SERIES_PLOT = true;
REMOVES_TREND = true;
REMOVES_TREND_PLOT = true;
AUTOCORR_PLOT = true;
AKAIKE = true;

%%%%%%%%%%%%%%%% Input time Series & globals %%%%%%%%%%%%%%%%
% read series
fileID1 = fopen('data/dat6v1.dat', 'r');
fileID2 = fopen('data/dat6v2.dat', 'r');
X1 = cell2mat(textscan(fileID1, '%f'));
X2 = cell2mat(textscan(fileID2, '%f'));
LENGTH = 6000;
POLORDER = 4;
MAX_ORDER_AR = 20;
MAX_ORDER_MA = 3;
T = [1:LENGTH];
fs = 100; % Hz
Ts = 1.0 / fs; % seconds

%%%%%%%%%%%%%%%% Time Series 1 %%%%%%%%%%%%%%%%
LINEAR1

%%%%%%%%%%%%%%%% Time Series 2 %%%%%%%%%%%%%%%%
% LINEAR2
