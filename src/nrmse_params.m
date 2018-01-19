function res=nrmse_params(sys,tarV,i,startI,plotting)
% 
% 
% 
% F = zeros(length(ZtarV)-36-i+1);
% ZtarV = [zeros(35,1); tarV];
t = 1;
for k=startI:1:length(tarV)
    s = forecast(sys, tarV(k-i+1:k), 1);
    F(t) = s;
    t = t + 1;
end
% size(startI:1:length(tarV))
% size(tarV(startI:end))
% size(F)
res = nrmse(tarV(startI:end), F');
if(plotting)
    figure;
    plot(F);
    hold on;
    plot(tarV(startI:end));
end
end