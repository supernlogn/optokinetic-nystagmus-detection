function [preV] = predictARMAmultistep(xV,n1,p,q,Tmax,tittxt)
% [preV] = predictARMAmultistep(xV,n1,p,q,Tmax,tittxt)
% PREDICTARMAMULTISTEP makes multi-step ahead predictions using the ARMA
% model
% x(t) = phi(0) + phi(1)*x(t-1) + ... + phi(p)*x(t-p) + 
%        +z(t) - theta(1)*z(t-1) + ... + theta(q)*z(t-p), 
% z(t) ~ WN(0,sdnoise^2)
% Note that if q=0, ARMA(p,q) reduces to AR(p) (autoregressive model of
% order p), and if p=0, ARMA(p,q) reduces to MA(q) (moving average model of
% order q).
% INPUTS:
%  xV      : vector of the scalar time series
%  n1      : size of training set, number of samples of the segment of xV 
%            (x(1),x(2),...,x(n1)) to which the ARMA model is fitted.
%            If n1 is empty, then n1 = length(xV).
%  p       : the order of AR part of the model.
%  q       : the order of the MA part of the model
%  Tmax    : the prediction horizon, predictions are made for T=1...Tmax
%            steps ahead, i.e. for times n1+1,n1+2,...,n1+Tmax
%  tittxt  : string to be displayed in the title of the figure (if not
%            given no figure is displayed) 
% OUTPUT: 
%  preV    : vector of length Tmax of the predicted values 
%            x(n1+1),x(n1+2),...,x(n1+Tmax)
% The actual and predicted values are plotted (provided that the length of
% 'xV' is at least 'n1+Tmax').

if nargin==4
    tittxt = [];
end
n = length(xV);
if isempty(n1)
    n1=n;
end
if n1>n
    error('The given size of training set exceeds the length of time series.');
end
xV = xV(:);
mx = mean(xV);
xxV = xV-mx;

armamodel = armax(xxV(1:n1),[p q]);
if p==0
    phiV = [];
else
    phiV = -armamodel.a(2:p+1)'; % Note that the AR coefficients are for the centered time series.
end
if q==0
    thetaV = [];
else
    thetaV = -armamodel.c(2:q+1)'; % Note that the MA coefficients are for the centered time series.
    % To make predictions we need to find the error terms, these are the
    % residuals of the MA fit
end

pq = max(p,q);
preV = NaN*ones(pq+Tmax,1);
if q>0
    tmpS = predict(armamodel,xxV(1:n1),1);
    if myversion==0
        xpreV = tmpS+mx;   
    elseif myversion==1
        xpreV = tmpS.OutputData+mx;   
    else
        xpreV = tmpS{1}+mx;
    end
    zV = xV(1:n1) - xpreV;
    zpreV = zeros(pq+Tmax,1);
    zpreV(pq-q+1:pq)=zV(n1-q+1:n1);
    % Now we can make predictions based also on the MA fit residuals, if
    % necessary
end
if p>0
    preV(pq-p+1:pq)=xxV(n1-p+1:n1);
end
if q==0
    for T=pq+1:pq+Tmax
        preV(T)=mx + phiV'*preV(T-1:-1:T-p);
    end
elseif p==0
    for T=pq+1:pq+Tmax
        preV(T)=mx -thetaV'*zpreV(T-1:-1:T-q);
    end
else
    for T=pq+1:pq+Tmax
        preV(T)=mx + phiV'*preV(T-1:-1:T-p) -thetaV'*zpreV(T-1:-1:T-q);
    end
end
preV = preV(pq+1:pq+Tmax);
if ~isempty(tittxt)
    iV = [n1+1:n1+Tmax]';
    if length(xV)<n1+Tmax
        i2V = [n1+1:length(xV)]';
        oriV = xV(i2V);
    elseif length(xV)==n1
        i2V = [];
        oriV = [];
    else
        i2V = iV;
        oriV = xV(i2V);
    end
    figure(gcf)
    clf
    plot(iV,preV,'.-r')
    hold on
    xlabel('T')
    ylabel('x(t+T)')
    if q==0
        title(sprintf('%s, multi-step AR(%d) prediction',tittxt,p))
    elseif p==0
        title(sprintf('%s, multi-step MA(%d) prediction',tittxt,q))
    else
        title(sprintf('%s, multi-step ARMA(%d,%d) prediction',tittxt,p,q))
    end
    if isempty(oriV)
        legend('predicted',0)
    else
        plot(i2V,oriV,'.-k')
        legend('real','predicted',0)
    end
end
