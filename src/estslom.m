function [nuM] = estslom(derM, mV, fac, logrmin, logrmax, numin)
% [nuM] = estslom(derM, mV, fac, logrmin, logrmax, numin)
% This function estimates the correlation dimensions 'nu' from
% the slope curves computed for a range of embedding values 'm'.
% The inputs are:
% derM:     The matrix of the slope curves, one column for
%           each m-value, starting from the second column.
%           The first column contains the log of the 
%           'r'-distances for which the slopes are evaluated.
% mV:       The vector of the 'm'-values, to denote the labels
%           of the columns of 'derM' (starting from the second).
% fac:      The factor r2/r1, where r1 and r2 are the begin and 
%           end of the scaling interval, from which the estimate
%           of the correlation dimenson 'nu' is derived.
% logrmin:  The log of the minimum 'r'-value to start searching
%           for the "best" scaling interval.
% logrmax:  The log of the maximum 'r'-value to end searching
%           for the "best" scaling interval.
% numin:    The minimum 'nu' value to be accepted as valid 
%           estimate from the "best" scaling interval.
% The output matrix 'nuM' contains as much rows as the 'm'-values,
% i.e. the length of 'mV', and five columns:
% column 1: The 'm'-value.
% column 2: The 'r1'-value.
% column 3: The 'r2'-value.
% column 4: The estimated 'nu'-value.
% column 5: The SD of the estimate that attributes to the "best"
%           scaling interval of length r2/r1 = fac.

torun = 'y'; 
cols = length(derM(1,:));
nm = length(mV);
if nm ~= cols - 1
  error('The number of columns of the slope matrix is not equal to the range of the m-values.');
end
rV = 10.^derM(:,1);
rmin = 10.^logrmin;
rmax = 10.^logrmax;

if nargin > 3 
  iV = find(rV >= rmin & rV <= rmax);
  if length(iV) == 0 
    disp('  Inaproppriate limits for logr.')
    disp('  Therefore, no estimation of slope has been executed.')
    torun = 'n';
  else
    nr = length(iV);
    if rV(iV(nr)) < rV(iV(1)) * fac
      disp('  Too small limits for logr or too large factor for scaling interval.')
      disp('  Therefore, no estimation of slope has been executed.')
      torun = 'n';
    end
    derM = derM(iV,:);
  end
end
if nargin < 5
  numin = 0.5;
end

nuM = -1*ones(cols-1,5);
nuM(:,1) = mV;
if torun == 'y'
  for i=1:cols-1
    [nuM(i,2) nuM(i,3) nuM(i,4) nuM(i,5)] = estslo(derM(:,[1 i+1]),fac,numin);
    if any(nuM(i,:)) < 0 
      disp(['  ... thus no estimation of slope for col ', int2str(i+1)])
    end
  end
end 
  
