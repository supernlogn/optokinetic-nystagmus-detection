function [nrmseV,f] = localfitnrmse(xV,tau,m,Tmax,nnei,q,tittxt)
% nrmseV = localfitnrmse(xV,tau,m,Tmax,nnei,q,tittxt)
% LOCALFITNRMSE makes fitting using a local average model and computes
% the fitting error for T-step ahead.
% LOCALPREDICTNRMSE makes iterative predictions with a local model of zeroth order 
% (average mapping or nearest neighbor mappings if only one neighbor is chosen) 
% or a local linear model. The predictions is made for all the points in the 
% data set, and is thus considered as fitting. Then the prediction error 
% (NRMSE measure) for T-step ahead predictions is computed. 
% The state space reconstruction is done with the method of delays and the 
% parameters are the embedding dimension 'm' and the delay time 'tau'. 
% The first target point is for the time index n-nlast, dvs the 
% reconstruction uses samples from the training set of length 'n-nlast'. 
% The local prediction model is one of the following:
% Ordinary Least Squares, OLS (standard local linear model): if the 
% trunctaion parameter q >= m
% Principal Component Regression, PCR, project the parameter space of the 
% model to only q of the m principal axes: if 0<q<m
% Local Average Mapping, LAM: if q=0.
% The local region is determined by the number of neighbours 'nnei'
% formed from the training set. The k-d-tree data structure is utilized to 
% speed up computation time in the search of neighboring points. This assumes 
% that the functions 'kdtreeidx' and 'kdrangequery' are in a directory of 
% the matlabpath.
% INPUTS:
%  xV      : vector of the scalar time series
%  tau     : the delay time (usually set to 1).
%  m       : the embedding dimension.
%  Tmax    : the prediction horizon, the fit is made for T=1...Tmax steps
%            ahead.
%  nnei    : number of nearest neighbors to be used in the local model. If k=1,
%            the nearest neighbor mapping is the fitted value. If k>1, the average
%            of the mappings of the k nearest neighbors is the fitted value.
%  q       : the truncation parameter for a normalization of the local linear
%            model if specified (to project the parameter space of the model, 
%            using Principal Component Regression, PCR, locally).
%            if q>=m -> Ordinary Least Squares, OLS (standard local linear model,
%                       no projection)
%            if 0<q<m -> PCR(q)
%            if q=0 -> local average model (if in addition nnei=1 ->
%            then the zeroth order model is applied)
%  tittxt  : string to be displayed in the title of the figure 
%            if not specified, no plot is made
% OUTPUT: 
%  nrmseV  : vector of length Tmax, the nrmse of the fit for T-mappings, T=1...Tmax.
sizeofmark = 10; 
f = 1.2;  % factor to increase the distance if not enough neighbors are found 
n = length(xV);
r = n;  % to deviate the range of the data and get the minimum distance
if nargin==6
    tittxt = [];
elseif nargin==6
    tittxt = [];
    q=0;
elseif nargin==5
    tittxt = [];
    q=0;
    nnei=1;
elseif nargin==4
    tittxt = [];
    tau=1;    
    q=0;
    Tmax=1;
end
if isempty(tau), tau=1; end
if isempty(q), q=0; end
if isempty(nnei), nnei=1; end
if isempty(Tmax), Tmax=1; end
if q>m, q=m; end
if n<2*((m-1)*tau-Tmax)
    error('the length of the time series is too small for this data size');
end
nvec = n-(m-1)*tau-Tmax;
xM = NaN*ones(nvec,m);
for i=1:m
    xM(:,m-i+1) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
end
[tmp,tmp,TreeRoot]=kdtreeidx(xM,[]); % k-d-tree data structure of the training set
% For each target point, find neighbors, apply the linear models and keep track 
% of the predicted values for each model and each prediction time.
preM = NaN*ones(nvec,Tmax);
mindist = (max(xV)-min(xV))/r;
for i=1:nvec
    inow = i+(m-1)*tau;
    winnowV = xV(inow-(m-1)*tau:inow);
    preM(i,1) = lppreone(xV,TreeRoot,winnowV,m,tau,nnei,q,mindist,1);
    winnowV = [winnowV(2:end);preM(i,1)];
    for T = 2:Tmax
        % Calls the function that makes one step prediction
        preM(i,T) = lppreone(xV,TreeRoot,winnowV,m,tau,nnei,q,mindist,0);
        winnowV = [winnowV(2:end);preM(i,T)];
    end
end
kdtreeidx([],[],TreeRoot); % Free the pointer to k-d-tree
preM = [[1:nvec]+(m-1)*tau;preM']'; %Add the target point index before the iterative predictions
nrmseV = NaN*ones(Tmax,1);
for T=1:Tmax
    nrmseV(T) = nrmse(xV(preM(:,1)+T),preM(:,T+1));
end
f = [];
if ~isempty(tittxt)
	figno = gcf;
	f = figure(figno)
	clf
	plot([1:Tmax]',nrmseV,'k')
	hold on
	plot([1:Tmax]',nrmseV,'k.','markersize',sizeofmark)
	plot([1 Tmax],[1 1],'y')
	xlabel('prediction time T')
	ylabel('NRMSE(T)')
	title([tittxt,' NRMSE(T), fit LP(m=',int2str(m),...
            ' K=',int2str(nnei),' q=',int2str(q),'), n=',int2str(n)])
end
