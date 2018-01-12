function y=nrmse(tarV,preV)
% y = nrmse(tarV,preV) computes the normalized root mean square error 
% using 1/(N-1) for the computation of SD.
% INPUTS
%  tarV: Vector of correct values
%  preV: Vector of predicted values
mx = mean(tarV);
vartar = sum((tarV - mx).^2);
varpre = sum((tarV - preV).^2);
y = sqrt(varpre / vartar);
