function [nrmseV,phiV,thetaV,SDz,aicS,fpeS,armamodel]=fitARMA(xV,p,q,Tmax)
% [nrmseV,phiV,thetaV,SDz,aicS,fpeS,armamodel]=fitARMA(xV,p,q,Tmax)
% FITARMA fits an autoregressive moving average (ARMA) model and
% computes the fitting error (normalized root mean square error) for a
% given number of steps ahead. 
% The ARMA model has the form
% x(t) = phi(0) + phi(1)*x(t-1) + ... + phi(p)*x(t-p) + 
%        +z(t) - theta(1)*z(t-1) + ... - theta(q)*z(t-p), 
% z(t) ~ WN(0,sdnoise^2)
% INPUTS:
%  xV      : vector of the scalar time series
%  p       : the order of the AR part of the model.
%  q       : the order of the MA part of the model.
%  Tmax    : the prediction horizon, the fit error is computed for
%            T=1...Tmax steps ahead.
% OUTPUT: 
%  nrmseV  : vector of length Tmax, the nrmse of the fit for T-mappings,
%            T=1...Tmax. 
%  phiV    : the coefficients of the estimated AR part (of length
%            (p+1) with phi(0) as first component.
%  thetaV  : the coefficients of the estimated MA part (of length q)
%  SDz     : the standard deviation of the noise term.
%  aicS    : the AIC value for the model.
%  fpeS    : the FPE value for the model.
%  sarmamodel : the model structure (contains all the above apart from
%               nrmseV)

if nargin==3
    Tmax = 1;
elseif nargin==2
    Tmax = 1;
    q=0;
end
if isempty(p)
    p = 0;
end
if isempty(q)
    q = 0;
end

xV = xV(:);
n = length(xV);
mx = mean(xV);
xxV = xV-mx;

armamodel = armax(xxV,[p q]);
if p==0
    phiV = [];
else
    phi0 = (1+sum(armamodel.a(2:p+1)))*mx;
    phiV = [phi0 -armamodel.a(2:p+1)];
    rootarV = roots(armamodel.a);
    if any(abs(rootarV)>=1)
        fprintf('The estimated AR(%d) part of the model is not stationary.\n',p);
    end
end
if q==0
    thetaV = [];
else
    thetaV = -armamodel.c(2:end);
    rootmaV = roots(armamodel.c);
    if any(abs(rootmaV)>=1)
        fprintf('The estimated MA(%d) part of the model is not reversible.\n',q);
    end
end
SDz = sqrt(armamodel.NoiseVariance);
aicS = aic(armamodel);
fpeS = armamodel.EstimationInfo.FPE;
nrmseV = NaN*ones(Tmax,1);
for T=1:Tmax
    tmpS = predict(armamodel,xxV,T);
    if myversion==0
        xpreV = tmpS+mx;   
    elseif myversion==1
        xpreV = tmpS.OutputData+mx;   
    else
        xpreV = tmpS{1}+mx;
    end
    nrmseV(T) = nrmse(xV(q+1:n),xpreV(q+1:n));
end

