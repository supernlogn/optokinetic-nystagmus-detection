function [hV,pV,QV,xautV] = portmanteauLB(serV,thesize,alpha,tittxt)
% function [hV,pV,QV,xautV] = portmanteauLB(serV,thesize,alpha,tittxt)
% PORTMANTEAULB hypothesis test (H0) for independence of time series:
% tests jointly that several autocorrelations are zero.
% It computes the Ljung-Box statistic of the modified sum of 
% autocorrelations up to a maximum lag, for maximum lags 
% 1,2,...,maxtau. 
% INPUTS:
% - serV    : It is a vector that can represent either
%             (a) a scalar time series of length 'n', or
%             (b) the autocorrelation for lags 1,2,...,'maxtau'
% - thesize : a positive integer that denotes either 
%             (a) the maximum lag 'maxtau' to compute autocorrelation for
%             (and then run the test) if the first argument 'serV' is a
%             time series of length 'n' > 'thesize', or
%             (b) the length of the time series 'n' if the first argument
%             'serV' is the autocorrelation for lags up to 'maxtau' <
%             'thesize'. 
% - alpha   : significance lavel (default 0.05)
% - tittxt  : string to be displayed in the title of the plot of
%             the p-values vs lag. If empty or not specified, no 
%             plots are displayed.
% OUTPUT:
% - hV      : vector of length 'maxtau' of test decision values (0,1) 
%             for the given significance level maximum lags 1,2,...,'maxtau'.
%             h=0 -> "do not reject H0", h=1 -> "reject H0"
% - pV      : vector of length 'maxtau' of the corresponding p-values.
% - QV      : vector of length 'maxtau' of the corresponding Q statistics
%             that follow Chi-square distribution under H0.
% - xautV   : vector of length 'maxtau' of the corresponding autocorrelation.
% References:
% Ljung, G. and Box, GEP (1978) "On a measure of lack of fit in time 
% series models", Biometrika, Vol 66, 67-72.

if nargin == 3
    tittxt = [];
elseif nargin == 2
    tittxt = [];
    alpha = 0.05;
end
if isempty(alpha), alpha=0.05; end
if (prod(size(alpha))>1), error('ALPHA must be a scalar.'); end
if (alpha<=0 | alpha>=1), error('ALPHA must be between 0 and 1'); end

if length(serV) > thesize
    % The input arguments are for a time series
    n = length(serV);
    maxtau = thesize;
    mx = mean(serV);
    tmpV = xcorr(serV-mx,thesize);
    xcovV = tmpV(thesize+1:2*thesize+1);
    xautV = xcovV / xcovV(1);
    xautV = xautV(2:thesize+1);
else
    % The input arguments are for autocorrelation
    maxtau = length(serV);
    n = thesize;
    xautV = serV;
end    
xautsqV = xautV.^2;
sumxautsq = 0;
pV = NaN*ones(maxtau,1);
QV = NaN*ones(maxtau,1);
for t=1:maxtau
    sumxautsq = sumxautsq + xautsqV(t)/(n-t);
    QV(t) = n*(n+2)*sumxautsq;
    pV(t) = 1-chi2cdf(QV(t),t);
end
hV = (pV <= alpha);
if ~isempty(tittxt)
    figure(gcf)
    clf
    plot([1:maxtau]',pV,'.-k')
    hold on
    plot([0 maxtau+1],alpha*[1 1],'--c')   
    xlabel('lag \tau')
    ylabel('p-value')
    title([tittxt,' Ljung-Box Portmanteau test'])
    axis([0 maxtau+1 0 1])
end