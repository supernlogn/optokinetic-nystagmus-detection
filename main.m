addpath('src');
addpath('kdtree');
addpath('kdtree/src');
addpath('kdtree/lib');
% system('rm assets/*');
clear all;
close all;

%%%%%%%%%%%%%%%% FLAGS %%%%%%%%%%%%%%%%
BASIC_PLOT                      = true;
FIR                             = true;
EXTREMA_PLOT                    = true;
EXTREMA_SERIES_PLOT             = true;
REMOVES_TREND                   = true;
REMOVES_TREND_PLOT              = true;
AUTOCORR_PLOT                   = true;
AKAIKE                          = true;


SCATTER_DIAGRAMS_PLOT           = false;
DBSCAN_CLUSTERING               = false;
FALSE_NEAREST_CALC_PLOT         = true;
FIND_BEST_TAU                   = true;
CALCULATE_CORRELATION_DIMENSION = true;
PLOT_CORR_DIM                   = true;
TRAIN_LOCAL_MODEL               = true;
%%%%%%%%%%%%%%%% Input time Series & globals %%%%%%%%%%%%%%%%
LENGTH                          = 6000;
TEST_SET_LENGTH                 = 500;
POLORDER                        = 4;
MAX_ORDER_AR                    = 20;
MAX_ORDER_MA                    = 3;
fs                              = 100; % Hz
Ts                              = 1.0 / fs; % seconds

% read series
fileID1 = fopen('data/dat6v1.dat', 'r');
fileID2 = fopen('data/dat6v2.dat', 'r');
X1 = cell2mat(textscan(fileID1, '%f'));
X2 = cell2mat(textscan(fileID2, '%f'));
T = [1:LENGTH];


%%%%%%%%%%%%%%%% Time Series 1 %%%%%%%%%%%%%%%%
% LINEAR1
% NONLINEAR1
%%%%%%%%%%%%%%%% Time Series 2 %%%%%%%%%%%%%%%%
LINEAR2
% NONLINEAR2


%%%%%%%%%%%%%%%% auto crop all images %%%%%%%%%
% requires image magic
!mogrify -trim +repage assets/*.png