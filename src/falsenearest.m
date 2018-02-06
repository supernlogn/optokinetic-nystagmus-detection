function [fnnM,mdistV,sddistV] = falsenearest(xV,tau,mmax,escape,theiler,tittxt)
% [fnnM,mdistV,sddistsV] = falsenearest(xV,tau,mmax,escape,theiler,tittxt)
% FNN computes the percentage of false nearest neighbors for a range of
% embedding dimensions starting from 1 to 'mmax' embedding dimensions.
% INPUT 
%  xV       : vector of the scalar time series
%  tau      : the delay time. If empty, tau=1
%  mmax     : the maximum embedding dimension.
%  escape   : A factor of escaping from the neighborhood. Default=10.
%  theiler  : the Theiler window to exclude time correlated points in the
%             search for neighboring points. Default=0.
%  tittxt   : string to be displayed in the title of the figure 
%             if not specified, no plot is made
% OUTPUT: 
%  fnnM     : A matrix of two columns and 'mmax' rows, where the embedding 
%             dimension is in the first column and the percentage of fnn in
%             the second column.
%  mdistV   : Mean distance of nearest neighbors at each embedding
%             dimension.
%  sddistV  : Standard deviation of distance of nearest neighbors at each
%             embedding dimension.

displayinfo = 0;

thresh = 0.01;
r = 1000;  % to deviate the range of the data and get the minimum distnow
f = 1.2;  % factor to increase the distance if not enough neighbors are found 
n = length(xV);
if nargin==5
    tittxt = [];
elseif nargin==4
    tittxt = [];
    escape=10;
elseif nargin==3
    tittxt = [];
    escape=10;
    theiler=0;
end
if isempty(tau), tau=1; end
if isempty(escape), escape=10; end
if isempty(theiler), theiler=0; end
% Rescale to [0,1] and add infinitesimal noise to have distinct samples
xmin = min(xV);
xmax = max(xV);
xV = (xV - xmin) / (xmax-xmin);
xV = AddNoise(xV,10^(-10));
if r<=0
    diffV = [];
    for i=1:n-theiler-1
        diffV = [diffV;abs(xV(i)-xV(i+theiler+1:n))];
    end
    diffV = sort(diffV);
    mindist = prctile(diffV,0.01);
else
    mindist = 1/r;
end

fnncountV = NaN*ones(mmax,1);
mdistV = NaN*ones(mmax,1);
sddistV = NaN*ones(mmax,1);
% if theiler == 0
%     for m=1:mmax
%         nvec = n-m*tau; % to be able to add the component x(nvec+tau) for m+1 
%         xM = NaN*ones(nvec,m);
%         for i=1:m
%             xM(:,m-i+1) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
%         end
%         [idxV,distV]=kdtreeidx(xM,xM);
%         if all(distV<1/escape)
%             nnfactorV = m*(xV(1+m*tau:n)-xV(idxV+m*tau)).^2./distV.^2;
%             fnncountV(m) = length(find(nnfactorV > escape))/length(nnfactorV);
%             mddistV(m) = mean(distV);
%             sddistV(m) = std(distV);
%         else
%             fprintf('for m=%d all neighbor distances > 1/%2.2f \n',m,escape);
%         end
%     end
% else
m=1;
nextm = 1;
while m<=mmax & nextm
    nvec = n-m*tau; % to be able to add the component x(nvec+tau) for m+1 
    xM = NaN*ones(nvec,m);
    for i=1:m
        xM(:,m-i+1) = xV(1+(i-1)*tau:nvec+(i-1)*tau);
    end
    % k-d-tree data structure of the training set for the given m
    [tmp,tmp,TreeRoot]=kdtreeidx(xM,[]); 
    % For each target point, find the nearest neighbor, and check whether 
    % the distance increase over the escape distance by adding the next
    % component for m+1.
    idxV = NaN*ones(nvec,1);
    distV = NaN*ones(nvec,1);
    for i=1:nvec
        tarV = xM(i,:);
        distnow = mindist;
        neiindV = [];
        while length(neiindV)<1
            [neiM,neidisV,neiindV]=kdrangequery(TreeRoot,tarV,distnow);
            [oneidisV,oneiindV]=sort(neidisV);
            neiindV = neiindV(oneiindV);
            neidisV = neidisV(oneiindV);
            % Enters if-loop either when there are no other neighbors
            % than the target point or when the other neighbors are at
            % temporal distance > theiler 
            if length(neiindV)>1
                iV = find(abs(neiindV(1)-neiindV(2:end))>theiler);
                if isempty(iV)
                    neiindV = [];
                    distnow = f*distnow;
                else
                    idxV(i) = neiindV(iV(1)+1);
                    distV(i) = neidisV(iV(1)+1);
                end
            else
                neiindV = [];
                distnow = f*distnow;
            end
%             if length(neiindV)==1 | isempty(find(abs(neiindV(1)-neiindV(2:end))>theiler))
%                 neiindV = [];
%                 distnow = f*distnow;
%             else
%                 iV = find(abs(neiindV(1)-neiindV(2:end))>theiler);
%                 idxV(i) = neiindV(iV(1)+1);
%                 distV(i) = neidisV(oneiindV(iV(1)+1));
%             end
        end % while
    end % for i
    iV = find(distV<sqrt(m)/escape);
    if isempty(iV)
        nextm = 0;
        if displayinfo
            fprintf('for m=%d all neighbor Euclidean distances>=sqrt(%d)/%2.2f \n',m,m,escape);
        end
    else
        nproper = length(iV);
        if displayinfo
            fprintf('for m=%d #neighbor Euclidean distances<sqrt(%d)/%2.2f=%d or %2.3f%% \n',...
                m,m,escape,length(iV),100*nproper/length(idxV));
        end
        nnfactorV = 1+(xV(iV+m*tau)-xV(idxV(iV)+m*tau)).^2./distV(iV).^2;
        fnncountV(m) = length(find(nnfactorV > escape^2))/nproper;
%         nnfactorV = sqrt(m)*abs((xV(iV+m*tau)-xV(idxV(iV)+m*tau)))./distV(iV);
%         fnncountV(m) = length(find(nnfactorV > escape^2))/nproper;
        mdistV(m) = mean(distV(iV));
        sddistV(m) = std(distV(iV));
        m = m+1;
    end
    kdtreeidx([],[],TreeRoot); % Free the pointer to k-d-tree
end
fnnM = [[1:mmax];fnncountV']';
if ~isempty(tittxt)
	figno = gcf;
	figure(figno)
	clf
	plot([1:mmax]',fnncountV,'.-k')
    hold on
	plot([1 mmax],thresh*[1 1],'c--')
	xlabel('m')
	ylabel('FNN(m)')
	title([tittxt,' FNN (\tau=',int2str(tau),' w=',int2str(theiler),...
        ' f=',int2str(escape),'), n=',int2str(n)])
end
