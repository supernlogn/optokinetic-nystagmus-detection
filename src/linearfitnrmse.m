function [nrmseV,phiV] = linearfitnrmse(xV,m,Tmax,tittxt)
% [nrmseV,phiV] = linearfitnrmse(xV,m,Tmax,tittxt)
% LINEARFITNRMSE fits an AR model and computes the fitting error
% for T-step ahead.
% INPUTS:
%  xV      : vector of the scalar time series
%  m       : the embedding dimension.
%  Tmax    : the prediction horizon, the fit is made for T=1...Tmax steps
%            ahead.
%  tittxt  : string to be displayed in the title of the figure 
%            if not specified, no plot is made
% OUTPUT: 
%  nrmseV  : vector of length Tmax, the nrmse of the fit for T-mappings, T=1...Tmax.
%  phiV    : the coefficients of the estimated AR time series (of length (m+1)
%            with phi(0) as first component

sizeofmark = 15; 
if nargin==3
    tittxt = [];
end
n = length(xV);
mx = mean(xV(1:n-Tmax+1));
yV = xV(1:n-Tmax+1)-mx;
aV = armcov(yV,m);
aV = -aV(2:m+1);
a0 = (1-sum(aV))*mx; 
phiV = [a0 aV]';

preM = NaN*ones(n+Tmax-1,Tmax);
for i=m:n-1
    preV = NaN*ones(m+Tmax,1);
    preV(1:m)=xV(i-m+1:i)-mx;
    for T=1:Tmax
        preV(m+T)=aV*preV(m+T-1:-1:T);
        preM(i+T,T)=preV(m+T);    
    end
end
preM = preM + mx*ones(size(preM));
nrmseV = ones(Tmax,1);
for T=1:Tmax
    nrmseV(T) = nrmse(xV(m+T:n),preM(m+T:n,T));
end
if ~isempty(tittxt)
	figno = gcf;
	figure(figno)
	clf
	plot([1:Tmax]',nrmseV,'k')
	hold on
	plot([1:Tmax]',nrmseV,'k.','markersize',sizeofmark)
	plot([1 Tmax],[1 1],'y')
	xlabel('prediction time T')
	ylabel('NRMSE(T)')
	title([tittxt,' NRMSE(T) for prediction with AR(',int2str(m),'), n=',int2str(n)])
end