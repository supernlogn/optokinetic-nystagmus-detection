function muV = polynomialfit(xV,polorder) 
% muV = polynomialfit(xV,polorder)
% POLYNOMIALFIT makes a fit to a given time series with a polynomial of a
% given order. 
% INPUTS 
% - xV       : vector of length 'n' of the time series
% - polorder : the order of the polynomial to be fitted
% OUTPUTS
% - muV      : vector of length 'n' of the fitted time series

n = length(xV);
xV = xV(:);
if polorder > 1
    tV = [1:n]';
    bV = polyfit(tV,xV,polorder);
    muV = polyval(bV,tV);
else
    muV = NaN*ones(n,1);
end
