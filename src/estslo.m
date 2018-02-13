function [logr1, logr2, numean, nusd] = estslo(derM, fac, numin);
% [logr1, logr2, numean, nusd] = estslo(derM, fac, numin);
% This function finds the scale region [r1,r2], for which
% r2/r1= 'fac' (input parameter), with the slope 'numean' of 
% least standard deviation (SD) 'nusd'.
% The input matrix 'derM' must contain just two columns, the 
% first should be the array of logr-values and the second the 
% corresponding derivatives of the correlation integral. 
% Moreover, a lower limit for the slope to be accepted may 
% be given by the input parameter 'numin' (in case a nice 
% plateau is formed for very small slope values, typically <1).

maxvalue = 1000;
if nargin == 2
  numin = 0.5;
end
logr1 = -1;
logr2 = -1;
numean = -1;
nusd = -1;

n = length(derM(:,1));
j=1;                   % Jump over the first small slope values
derbeg = derM(j,2);
while derbeg < numin & j<n
  j=j+1;
  derbeg = derM(j,2);
end
if j==n
  disp(['    The slope curve is below the given slope limit of ', num2str(numin)])
  disp('    Therefore, no estimation of slope has been executed.')
else
  r1 = 10^derM(j,1);      % Find the first interval to be checked
  r2 = r1 * fac;
  if 10^derM(n,1) < r2
     disp(['    Too small r-interval to compute slope > the given limit ', num2str(numin)])
  else
    i=j+1;                 
    rnow = 10^derM(j+1,1);
    while rnow <= r2
      i=i+1;
      rnow = 10^derM(i,1);
    end
    interval = i - j;      % Run over the intervals of this length   
    nusd = maxvalue;                % and find the one with min std
    numeani = maxvalue;
    r1ind=-1;
    for k=j:n-interval
      nusdi = std(derM(k:k+interval,2));
      if nusdi < nusd
        numeani = mean(derM(k:k+interval,2));
        if numeani > numin
          nusd = nusdi;
          numean = numeani;
          r1ind = k;
        end
      end
    end
    if r1ind>0
      logr1 = derM(r1ind,1);
      logr2 = derM(r1ind+interval,1);
    end
  end
end
