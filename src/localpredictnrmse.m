function [nrmseV,preM] = localpredictnrmse(xV,nlast,tau,m,Tmax,nnei,q,tittxt)
% [nrmseV,preM] = localpredictnrmse(xV,nlast,tau,m,Tmax,nnei,q,tittxt)
% LOCALPREDICTNRMSE makes iterative predictions with a local model of zeroth order 
% (average mapping or nearest neighbor mappings if only one neighbor is chosen) 
% or a local linear model on a last part of a given time series and computes 
% the prediction error (NRMSE measure) for T-step ahead predictions. 
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
%  xV       : vector of the scalar time series
%  nlast    : the size of the test set to compute the prediction error on
%           : if not specified, it is half the length of the time series
%  tau      : the delay time
%  m        : the embedding dimension.
%  Tmax     : the prediction horizon, the predict is made for T=1...Tmax steps
%             ahead.
%  nnei     : the number of neighboring points to support the local model.
%  q        : the truncation parameter for a normalization of the local linear
%             model if specified (to project the parameter space of the model, 
%             using Principal Component Regression, PCR, locally).
%             if q>=m -> Ordinary Least Squares, OLS (standard local linear model,
%                        no projection)
%             if 0<q<m -> PCR(q)
%             if q=0 -> local average model (if in addition nnei=1 ->
%             then the zeroth order model is applied)
%  tittxt   : string to be displayed in the title of the figure 
%             if not specified, no plot is made
% OUTPUT: 
%  nrmseV   : vector of length Tmax, the nrmse for the predictions for T-mappings, 
%             T=1...Tmax, on the test set
%  preM     : matrix with rows the number of target points and columns 
%             the prediction times plus one. The first column has the current
%             time index of the time series for which (multi)predictions
%             are made. The other columns contain the predictions, one
%             for each number of given prediction steps in ascending order.
sizeofmark = 10; 
r = 1000;  % to deviate the range of the data and get the minimum distance
f = 1.2;  % factor to increase the distance if not enough neighbors are found 
n = length(xV);
if nargin==7
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
if isempty(nlast), nlast=round(n/2); end
if isempty(Tmax), Tmax=1; end
if nlast>=n-2*m*tau,
    error('test set is too large for the given time series!')
end
if q>m, q=m; end
n1=n-nlast;
if n1<2*((m-1)*tau-Tmax)
    error('the length of training set is too small for this data size');
end
n1vec = n1-(m-1)*tau-1;
xM = NaN*ones(n1vec,m);
for i=1:m
    xM(:,m-i+1) = xV(1+(i-1)*tau:n1vec+(i-1)*tau);
end
[tmp,tmp,TreeRoot]=kdtreeidx(xM,[]); % k-d-tree data structure of the training set
% For each target point, find neighbors, apply the linear models and keep track 
% of the predicted values for each model and each prediction time.
ntar = nlast-Tmax+1;
preM = NaN*ones(ntar,Tmax);
mindist = (max(xV(1:n1-1))-min(xV(1:n1-1)))/r;
for i=1:ntar
    inow = n1+i-1;
    winnowV = xV(inow-(m-1)*tau:inow);
    for T = 1:Tmax
        % Calls the function that makes one step prediction
        preM(i,T) = lppreone(xV,TreeRoot,winnowV,m,tau,nnei,q,mindist,0);
        winnowV = [winnowV(2:end);preM(i,T)];
    end
end
kdtreeidx([],[],TreeRoot); % Free the pointer to k-d-tree
preM = [[n1:n-Tmax];preM']'; %Add the target point index before the iterative predictions
nrmseV = NaN*ones(Tmax,1);
for T=1:Tmax
    nrmseV(T) = nrmse(xV(preM(:,1)+T),preM(:,T+1));
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
	title([tittxt,' NRMSE(T), prediction LP(m=',int2str(m),...
            ' K=',int2str(nnei),' q=',int2str(q),'), n=',int2str(n),...
            ' nlast=',int2str(nlast)])
end
