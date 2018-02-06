function [locextM,xV] = extremes(xV,filterorder,nsam,minincr,timesep,segplot)
% [locextM,xV] = extremes(xV,filterorder,nsam,minincr,timesep,segplot)
% The function "extremes" finds the local extreme values for a given time
% series 'xV' computed by means of a sliding window of 2*'nsam'+1 samples.
% The time series can be first filtered by a finite impulse response (FIR)
% filter with the number of points given by 'filterorder' (larger than 1).
% The 'minincr' specifies the minimum accepted difference in magnitude
% that the local extreme must have from the most distant point in the
% local window.
% The 'timesep' specifies the minimum accepted time difference
% that the local extreme must have from the previous local extreme.
% The function gives the possibility to scan the time series and display
% the extremes superimposed to the time series. This is done if 'segplot'
% is a positive integer that accounts for the number of segments to split
% the time series and display.
% INPUTS:
% - xV          : the given scalar time series (a column vector)
% - filterorder : number of points of the FIR filter (if 0 no filter is applied).
% - nsam        : number of samples to form the local window given as
%                 2*'nsam'+1, on which the local extremes are detected
%                 (default = 1)
% - minincr     : threshold for the magnitude difference between candidate
%                 local extreme and most distant point in the local window
%                 (default = 0, that is every local extreme found is included)
% - timesep     : threshold for the time difference between candidate
%                 local extreme and the previous local extreme
%                 (default = 0, that is every local extreme found is included)
% - segplot     : number of segments to split the time series and make plots
%                 for (default is 0, no plot is displayed).
% OUTPUTS
% - locextM     : A matrix with number of rows the number of local extremes
%                 and three columns indicating the following:
%                 1st: the time index (multiple of sampling time) of each
%                      extreme value,
%                 2nd: the corresponding extreme value,
%                 3nd: a value in {-1,1} indicating the extreme type:
%                      1->max, -1->min
% - xV          : if filterorder>1, this is the filtered time series, otherwise
%                 it is the original time series.

% First read in the default input parameters that are not specified
if nargin == 5
    segplot = 0;
elseif nargin == 4
    segplot = 0;
    timesep = 0;
elseif nargin == 3
    segplot = 0;
    timesep = 0;
    minincr = 0;
elseif nargin == 2
    segplot = 0;
    timesep = 0;
    minincr = 0;
    nsam = 1;
elseif nargin == 1
    segplot = 0;
    timesep = 0;
    minincr = 0;
    nsam = 1;
    filterorder = 0;
end
if isempty(segplot), segplot=0; end
if isempty(timesep), timesep=0; end
if isempty(minincr), minincr=0; end
if isempty(nsam), nsam=3; end
if isempty(filterorder), filterorder=0; end

xV = xV(:);
% Filtering of the time series with 'filterorder'-point averaging FIR filter
if filterorder > 1
    b = ones(1,filterorder)/filterorder;
    xV = filtfilt(b,1,xV);
end
n = length(xV);
% To avoid multiple extremes due to discretization (round off) error, add
% infinitesimal small noise to the data.
% xsd = std(xV);
% sdno = xsd * 10^(-10);
% xV = xV + randn(n,1)*sdno;

% Find first local extreme
i=nsam+1;
extfound = 0; % Local extreme found
locextM = [];
while i<=n-nsam && ~extfound
    winxV = [xV(i-nsam:i-1)' xV(i+1:i+nsam)'];
    minwin = min(winxV);
    maxwin = max(winxV);
    checkextV = find(xV(i) >= winxV);
    if length(checkextV)==length(winxV) && xV(i)-minwin>minincr
        locextM = [i xV(i) 1];
        extfound = 1;
    elseif isempty(checkextV) && maxwin-xV(i)>minincr
        locextM = [i xV(i) -1];
        extfound = 1;
    end
    i= i+1;
end
istart = i;
% To decrease time in case minincr=0 or timesep=0, check the conditions once
% in the beginning of the process for the detection of local extremes
if minincr > 0 && timesep > 0
    % include the check for magnitude difference threshold and
    % the check for time difference of successive local extremes
    for i=istart:n-nsam
        winxV = [xV(i-nsam:i-1)' xV(i+1:i+nsam)'];
        minwin = min(winxV);
        maxwin = max(winxV);
        checkextV = find(xV(i) >= winxV);
        if length(checkextV)==length(winxV) && xV(i)-minwin>minincr && i-locextM(end,1)>timesep
            locextM = [locextM; [i xV(i) 1]];
        elseif isempty(checkextV) && maxwin-xV(i)>minincr && i-locextM(end,1)>timesep
            locextM = [locextM; [i xV(i) -1]];
        end
    end
elseif minincr > 0
    % include only the check for magnitude difference threshold
    for i=istart:n-nsam
        winxV = [xV(i-nsam:i-1)' xV(i+1:i+nsam)'];
        minwin = min(winxV);
        maxwin = max(winxV);
        checkextV = find(xV(i) >= winxV);
        if length(checkextV)==length(winxV) && xV(i)-minwin>minincr
            locextM = [locextM; [i xV(i) 1]];
        elseif isempty(checkextV) && maxwin-xV(i)>minincr
            locextM = [locextM; [i xV(i) -1]];
        end
    end
elseif timesep > 0
    % include the check for time difference of successive local extremes
    for i=istart:n-nsam
        winxV = [xV(i-nsam:i-1)' xV(i+1:i+nsam)'];
        checkextV = find(xV(i) >= winxV);
        if length(checkextV)==length(winxV) && i-locextM(end,1)>timesep
            locextM = [locextM; [i xV(i) 1]];
        elseif isempty(checkextV) && i-locextM(end,1)>timesep
            locextM = [locextM; [i xV(i) -1]];
        end
    end
else
    % do the same as above without checking for magnitude difference threshold
    % and time separation
    for i=istart:n-nsam
        winxV = [xV(i-nsam:i-1)' xV(i+1:i+nsam)'];
        checkextV = find(xV(i) >= winxV);
        if length(checkextV)==length(winxV) && locextM(end,3)==-1
            locextM = [locextM; [i xV(i) 1]];
        elseif isempty(checkextV) && locextM(end,3)==1
            locextM = [locextM; [i xV(i) -1]];
        end
    end
end
% Check if the succession min,max is not followed. If both are maxima then
% remove the smaller one. If both are minima then remove the largest one.
% This might be rare but it might happen!
if isempty(locextM),
    disp('No extremes found!')
else
    iV = 1;
    while ~isempty(iV)
        iV = find(locextM(1:end-1,3)+locextM(2:end,3) ~= 0);
        if ~isempty(iV)
            dellocextM = []; % rows to be subtracted
            for i=1:length(iV)
                [tmp,imax] = max(locextM(iV(i):iV(i)+1,2));
                if locextM(iV(i),3) == 1
                    iout = iV(i)+2-imax;
                else
                    iout = iV(i)+imax-1;
                end
                dellocextM = [dellocextM;locextM(iout,:)];
            end
            locextM = setdiff(locextM,dellocextM,'rows');
        end
    end
    % Now display the time series and the local extremes marked on it.
    % Ignore the last bit if the number of segments does not divide exactly
    % the length of the time series
    if segplot > 0
        xmin = min(xV);
        xmax = max(xV);
        nwin = floor(n/segplot);
        figure;
        clf
        plot(xV,'.-')
        hold on
        plot(locextM(:,1),locextM(:,2),'ro')
        for i=1:segplot
            axis([(i-1)*nwin+1 i*nwin xmin xmax])
            disp(['press any key to continue ...'])
            pause;
        end
        if segplot*nwin+1 < n
            axis([segplot*nwin+1 n xmin xmax])
        end
    end
end
