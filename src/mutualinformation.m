function [mutM] = mutualinformation(xV, tmax, partitions, tittxt, type)
% [mutM] = mutualinformation(xV, tmax, partitions, tittxt, type)
% MUTUALINFORMATION computes and plots the mutual information of a
% a time series
% INPUTS:
%  xV         : vector of a scalar time series
%  tmax       : largest delay time to compute autocorrelation for
%  partitions : number of partitions of the one dimensional domain for 
%               which the probabilities are evaluated.
%               If 'partitions' is not specified the default is sqrt(n/5),
%               where n is the length of the time series.
%  tittxt     : string to be displayed in the title
%  type       : if 'd' (for discrete) then data points are displayed 
%               with dots, if 'c' lines are used, otherwise lines and 
%               dots are used. 
% OUTPUT:
%  mutM       : matrix of dimension (1+tmax) x 2, where at the first
%               column are the lag times and at the second column the 
%               corresponding autocorrelation.

sizeofmark = 6;

n = length(xV);
if nargin == 2
    partitions = ceil(sqrt(n/5));
    type = 'b';
    tittxt = '';
elseif nargin == 3
    type = 'b';
    tittxt = '';
elseif nargin == 4
    type = 'b';
end
if isempty(partitions)
    partitions = ceil(sqrt(n/5));
end

n = length(xV);
h1V = zeros(partitions,1);  % for p(x(t+tau))
h2V = zeros(partitions,1);  % for p(x(t))
h12M = zeros(partitions,partitions);  % for p(x(t+tau),x(t))

% Normalise the data
xmin = min(xV);
[xmax,imax] = max(xV);
yV(imax) = xmax + (xmax-xmin)*10^(-10); % To avoid multiple exact maxima
yV = (xV-xmin)/(xmax-xmin);

arrayV = floor(yV*partitions)+1; % Array of partitions: 1,...,partitions
arrayV(imax) = partitions; % Set the maximum in the last partition

mutM = zeros(tmax+1,2);
mutM(1:tmax+1,1) = [0:tmax]';
for tau=0:tmax
  ntotal = n-tau;
  mutS = 0;
  for i=1:partitions
    for j=1:partitions
      h12M(i,j) = length(find(arrayV(tau+1:n)==i & arrayV(1:n-tau)==j));
    end
  end
  for i=1:partitions
    h1V(i) = sum(h12M(i,:));
    h2V(i) = sum(h12M(:,i));
  end
  for i=1:partitions
    for j=1:partitions
      if h12M(i,j) > 0
        mutS=mutS+(h12M(i,j)/ntotal)*log(h12M(i,j)*ntotal/(h1V(i)*h2V(j)));
      end
    end
  end
  mutM(tau+1,2) = mutS;
end

figure(gcf)
clf
if type == 'd'
    plot(mutM(:,1),mutM(:,2),'.')
elseif type == 'c'
    plot(mutM(:,1),mutM(:,2))
else
    plot(mutM(:,1),mutM(:,2))
    hold on
    plot(mutM(:,1),mutM(:,2),'.','markersize',sizeofmark)
end
xlabel('lag \tau')
ylabel('I(\tau)')
title([tittxt,' Mutual Information'])

    
