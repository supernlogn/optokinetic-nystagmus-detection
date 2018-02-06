function y=nrmse(tarV,preV)
% y = nrmse(tarV,preV) computes the normalized root mean square error 
% using 1/(N-1) for the computation of SD.
% INPUTS
%  tarV: Vector of correct values
%  preV: Vector of predicted values
% mx = mean(tarV);
% vartar = sum((tarV - mx).^2);
% varpre = sum((tarV - preV).^2);
% y = sqrt(varpre / vartar);
yV = preV;
xV = tarV;

xmean = mean(xV);
N = length(tarV)
a = sum((xV - yV) .* (xV-yV));
b = sum((xV - xmean) .* (xV - xmean));
y = sqrt(a)/sqrt(b);
end

