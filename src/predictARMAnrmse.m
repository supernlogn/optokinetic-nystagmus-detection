function [f,nrmseV,preM,phiV,thetaV] = predictARMAnrmse(xV,p,q,Tmax,nlast,tittxt)
% [nrmseV,preM,phiV,thetaV] = predictARMAnrmse(xV,p,q,Tmax,nlast,tittxt)
% PREDICTARMANRMSE makes predictions with an ARMA(p,q) model on a last part
% of a given time series and computes the prediction error (NRMSE measure)
% for T-step ahead predictions. The model is
% x(t) = phi(0) + phi(1)*x(t-1) + ... + phi(p)*x(t-p) + 
%        +z(t) - theta(1)*z(t-1) + ... + theta(q)*z(t-p), 
% z(t) ~ WN(0,sdnoise^2)
% Note that if q=0, ARMA(p,q) reduces to AR(p) (autoregressive model of
% order p), and if p=0, ARMA(p,q) reduces to MA(q) (moving average model of
% order q).
% INPUTS:
%  xV      : vector of the scalar time series
%  p       : the order of AR part of the model.
%  q       : the order of MA part of the model.
%  Tmax    : the predictions in the test set are repeated for each of the 
%            prediction steps T=1...Tmax
%  nlast   : the size of the test set to compute the prediction error on.
%          : If not specified, it is half the length of the time series
%  tittxt  : string to be displayed in the title of the figure.
%            If not specified, no plot is made
% OUTPUT: 
%  nrmseV  : vector of length Tmax, the nrmse for the predictions for time
%            steps T=1...Tmax, on the test set.
%  preM    : matrix of nlast columns and Tmax rows, having the T-ahead 
%            predictions at column T, T=1...Tmax (the first T-1 components
%            are NaN).
%  phiV    : the coefficients of the estimated AR time series (of length
%            (p+1) with phi(0) as first component.
%  thetaV  : the coefficients of the estimated MA time series (of length q)

n = length(xV);
xV = xV(:);
if nargin==5
    tittxt = [];
elseif nargin==4
    tittxt = [];
    nlast = round(n/2);
end
if isempty(nlast)
    nlast = round(n/2);
end
if nlast>=n-2*q,
    error('test set is too large for the given time series!')
end
n1 = n-nlast;  % size of training set
x1V = xV(1:n1); 
mx1 = mean(x1V(1:n1)); 
xx1V = x1V(1:n1)-mx1; % set mean of the training set to zero.
armamodel = armax(xx1V,[p q]);
if p==0
    phiV = [];
else
    phi0 = (1+sum(armamodel.a(2:1+p)))*mx1;
    phiV = [phi0;-armamodel.a(2:p+1)']; % Note that the AR coefficients are for the centered time series.
end
if q==0
    thetaV = [];
else
    thetaV = -armamodel.c(2:q+1)'; % Note that the MA coefficients are for the centered time series.
end
preM = NaN*ones(n+Tmax-1,Tmax); % for simplicity use the indices for the whole
                                % time series, the first n1 will be ignored
preM = NaN*ones(n,Tmax);
xxV = xV-mx1;
for T=1:Tmax
    tmpS = predict(armamodel,xxV,T);
    if myversion==0
        preM(:,T) = tmpS+mx1;   
    elseif myversion==1
        preM(:,T) = tmpS.OutputData+mx1;   
    else
        preM(:,T) = tmpS{1}+mx1;
    end
end                                
nrmseV = ones(Tmax,1);
for T=1:Tmax
    nrmseV(T) = nrmse(xV(n1+T:n),preM(n1+T:n,T));
end
preM = preM(n1+1:n,:);

if ~isempty(tittxt)
	figno = gcf;
	f = figure(figno);
	clf
	plot([1:Tmax]',nrmseV,'.-k')
	hold on
	plot([1 Tmax],[1 1],'y')
	xlabel('prediction time T')
	ylabel('NRMSE(T)')
    if q==0
    	title(sprintf('%s, NRMSE(T) for AR(%d) prediction, n=%d, nlast=%d',...
            tittxt,p,n,nlast))
    elseif p==0
        title(sprintf('%s, NRMSE(T) for MA(%d) prediction, n=%d, nlast=%d',...
           tittxt,q,n,nlast))
    else
        title(sprintf('%s, NRMSE(T) for ARMA(%d,%d) prediction, n=%d, nlast=%d',...
            tittxt,p,q,n,nlast))
    end
end
