function [xM] = embedDelays(xV, m, tau);
% [xM] = embeddelays(xV, m, tau)
% EMBEDDELAYS reconstructs delay trajectory from a scalar time series
% using the embedding method of delays.
% INPUTS:
%  xV    : vector of the scalar time series
%  m     : the embedding dimension
%  tau   : the delay time
% OUTPUT: 
%  xM    : Toeplitz matrix with 'm' columns and with entries the lagged
%          components of the resampled 'xV' according to the input 'tau'.

n = length(xV);

nvec = n - (m-1)*tau;   % The length of the reconstructed set
xM = zeros(nvec,m);

for i=1:m
   xM(:,m-i+1) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
end

% for i=1:nvec
%    xM(i,:) = xV(i:tau:i+(m-1)*tau)';
% end
