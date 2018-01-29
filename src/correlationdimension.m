function [rcM,cM,rdM,dM,nuM] = correlationdimension(xV,tau,mmax,tittxt,fac,logrmin,logrmax);
% [rcM,cM,rdM,dM,nuM] = correlationdimension(xV,tau,mmax,tittxt,fac,logrmin,logrmax);
% This function computes the correlation dimension for a given time series 
% 'xV', for a delay 'tau' and a range of embedding dimensions 1,...,mmax. 
% First, the correlation sum C(r) and the local slopes log(C(r))/log(r) are 
% computed for a range of distances r and for m=1,...,mmax. Then for each 'm'
% the correlation dimension 'nu' is estimated from the local slopes in an 
% interval [r1,r2], where r2/r1=fac ('fac' is the given factor for the interval, 
% i.e. 'fac' determines the length of the scaling region of r distances). 
% The interval [r1,r2] is chosen as the one in which the local slope have 
% the smallest standard deviation (SD) and the mean local slope in [r1,r2] is 
% the estimate of 'nu'. 
% Further, four plots are shown: 
%   1. log(C(r)) vs log(r)
%   2. local slope vs log(r)
%   3. nu +- SD vs m
%   4. [log(r1) log(r2)] vs m
% INPUTS:
%  xV      : vector of a scalar time series
%  tau     : the delay time
%  mmax    : the maximum embedding dimension to make computations for
%  tittxt  : string to be displayed in the title
%  fac     : factor to determine the length of the distance interval, fac=r2/r1
%  logrmin : the smallest log(r1) to search for the scaling interval [r1,r2]
%  logrmax : the largest log(r2) to search for the scaling interval [r1,r2]
% OUTPUT:
%  rcM     : matrix of size '100 x mmax' of the 100 distances 'r' for a range of 
%            embedding dimensions m=1,...,mmax, for which the correlation sum is
%            evaluated (matches 'cM' below)
%  cM      : matrix of size '100 x mmax' of the correlation sum evaluated at 
%            100 distances 'r' for a range of embedding dimensions m=1,...,mmax
%  rdM     : matrix of size '99 x mmax' of the 99 distances 'r' for a range of 
%            embedding dimensions m=1,...,mmax, for which the correlation sum is
%            evaluated (matches 'dM' below)
%  dM      : matrix of size '99 x mmax' of the local slopes evaluated at 
%            99 distances 'r' for a range of embedding dimensions m=1,...,mmax
%            (one less than the distances for the correlation sum because the
%            evaluation of local slopes is done for first differences of r).
%  nuM     : matrix of size 'mmax x 4' organized as follows:
%            column 1 -> embedding dimension
%            column 2 and 3 -> [log(r1),log(r2)] the log of the scaling interval
%            column 4 -> the estimated correlation dimension 'nu' in [log(r1),log(r2)]
%            column 5 -> the standard deviation (SD) for 'nu' in [log(r1),log(r2)]
 
numin = 0.5;
if nargin<4
    tittxt = '';
    fac = 4;
    logrmin = -1000000;
    logrmax = 1000000;
elseif nargin<5
    fac = 4;
    logrmin = -1000000;
    logrmax = 1000000;
elseif nargin < 6
    logrmin = -1000000;
    logrmax = 1000000;
elseif nargin < 7
    logrmax = 1000000;
end
save tmp.dat xV -ascii
eval(['!c:\tisean\d2 tmp.dat -t50 -d',int2str(tau),' -M1,',int2str(mmax),' -N0 -o tmp'])
rcM = NaN*ones(100,mmax);
rdM = NaN*ones(99,mmax);
cM = NaN*ones(100,mmax);
dM = NaN*ones(99,mmax);
nuM = NaN*ones(mmax,5);
fidc = fopen('tmp.c2', 'r');
fgets(fidc);
fidd = fopen('tmp.d2', 'r');
fgets(fidd);
for mi=1:mmax
    aa = fgets(fidc);
    tmpM = fscanf(fidc,'%f ', [2 100])';
    rows = size(tmpM,1);
    rcM(1:rows,mi) = flipud(log10(tmpM(:,1)));
    cM(1:rows,mi) = flipud(tmpM(:,2));
    fgets(fidd);
    tmpM = fscanf(fidd,'%f ', [2 99])';
    rows = size(tmpM,1);
    rdM(1:rows,mi) = flipud(log10(tmpM(:,1)));
    dM(1:rows,mi) = flipud(tmpM(:,2));
    if logrmin == -1000000
        logr1 = rdM(1,mi);
    else
        logr1 = logrmin;
    end
    if logrmax == 1000000
        logr2 = rdM(rows,mi);
    else
        logr2 = logrmax;
    end
    nuM(mi,:) = estslom([rdM(1:rows,mi),dM(1:rows,mi)], mi, fac, logr1, logr2, numin);
end
fclose(fidc);
fclose(fidd);
!del tmp.dat tmp.c2 tmp.d2 tmp.h2 tmp.stat
figno = gcf;
figure(figno)
clf
plot(rcM,log10(cM))
xlabel('log r')
ylabel('log C(r)')
title([tittxt,' correlation integral, \tau=',int2str(tau),' m=1,...,',int2str(mmax)])
figure(figno+1)
clf
plot(rdM,dM)
xlabel('log r')
ylabel('slope')
title([tittxt,' local slope, \tau=',int2str(tau),' m=1,...,',int2str(mmax)])
figure(figno+2)
clf
errorbar([1:mmax]',nuM(:,4),nuM(:,5))
xlabel('m')
ylabel('\nu(m)')
title([tittxt,' estimated correlation dimension, \tau=',int2str(tau)])
figure(figno+3)
clf
plot([1 1],[nuM(1,2) nuM(1,3)])
hold on
for mi=2:mmax
    plot([mi mi],[nuM(mi,2) nuM(mi,3)])
end
xlabel('m')
ylabel('[log r_1, log r_2]')
title([tittxt,' log distances for estimation, \tau=',int2str(tau)])
