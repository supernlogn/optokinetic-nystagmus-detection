function plotnrmse(nrmseM,legtxtM)
% plotnrmse(nrmseM,legtxtM)
% PLOTNRMSE plots the NRMSE(T) for a range of prediction times T and 
% for a number of models
% INPUTS:
%  nrmseM  : the matrix of size Tmax x q of NRMSE for prediction times
%            T=1...Tmax and q different models 
%  legtxtM : a string matrix of the legends for each prediction model at 
%            the column order in 'nrmseM'.

[Tmax,q] = size(nrmseM);
if nargin < 2
    legtxtM = 'predict-1';
    for i=2:q
        legtxtM = str2mat(legtxtM,['predict-',int2str(i)]);
    end
end
symb1V = str2mat('''k''', '''r''', '''b''', '''g''', '''c''', '''m''');
symb2V = str2mat('''k.''', '''r.''', '''b.''', '''g.''', '''c.''', '''m.''');
TV = [1:Tmax]';
figure(gcf)
clf
eval(['plot(TV,nrmseM(:,1),',symb1V(1,:),',''linewidth'',1)'])
legtxt = ['''',legtxtM(1,:),''','];
hold on
for i=2:q
    eval(['plot(TV,nrmseM(:,i),',symb1V(i,:),',''linewidth'',1)'])
    legtxt = [legtxt,'''',legtxtM(i,:),''','];
end
eval(['plot(TV,nrmseM(:,1),',symb2V(1,:),')'])
for i=2:q
    eval(['plot(TV,nrmseM(:,i),',symb2V(i,:),')'])
end
eval(['legend(',legtxt,'0)'])
xlabel('prediction time T')
ylabel('NRMSE(T)')
title('NRMSE of fit')
