function [acM] = autocorrelation(xV, tmax, tittxt, type)
% [acM] = autocorrelation(xV, tmax, tittxt, type)
% AUTOCORRELATION computes and plots the autocorrelation of a
% a time series
% INPUTS:
%  xV      : vector of a scalar time series
%  tmax    : largest delay time to compute autocorrelation for
%  tittxt  : string to be displayed in the title, if empty or omitted no
%            graph is displayed
%  type    : if 'd' (for discrete) then data points are displayed 
%            with dots, if 'c' lines are used, otherwise lines and 
%            dots are used. 
% OUTPUT:
%  acM     : matrix of dimension (1+tmax) x 2, where at the first
%            column are the lag times and at the second column the 
%            corresponding autocorrelation.
sizeofmark = 6;

if nargin == 2
    type = 'b';
    tittxt = [];
elseif nargin == 3
    type = 'b';
end

acM = zeros(tmax+1,2);
acM(:,1) = [0:tmax]';
n = length(xV);
xm = mean(xV);
yV = xV - xm;
tmpV = xcorr(yV,tmax);
xcovV = tmpV(tmax+1:2*tmax+1);
acM(:,2) = xcovV / xcovV(1);

if ~isempty(tittxt)
    figure(gcf)
    clf
    if type == 'd'
        plot(acM(:,1),acM(:,2),'.')
    elseif type == 'c'
        plot(acM(:,1),acM(:,2))
    else
        plot(acM(:,1),acM(:,2))
        hold on
        plot(acM(:,1),acM(:,2),'.','markersize',sizeofmark)
    end
    xlabel('lag \tau')
    ylabel('r(\tau)')
    title([tittxt,' Autocorrelation'])
end
    
