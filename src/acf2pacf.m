function pacfV = acf2pacf(rhoV,display)
% pacfV = acf2pacf(rhoV,display)
% The function computes the partial autocorrelation (pacf) function for a 
% given autocorrelation function (for lags up to 'p').
% INPUTS 
% - rhoV    : array of size 'p x 1' of the autocorrelation for the first p
%             lags. 
% - display : if 1 then show a graph of the partial autocorrelation (if
%             omitted no figure will be generated).
% OUTPUTS
% - pacfV   : the array of size 'p x 1' of the partial autocorrelation values.

if nargin==1
    display = 0;
end
p = length(rhoV);
rhoV = rhoV(:);
pacfV = NaN*ones(p,1);
pacfV(1) = rhoV(1);
for i=2:p
    denomM = toeplitz([1;rhoV(1:i-1)]);
    numerM = [denomM(:,1:i-1) rhoV(1:i)];
    pacfV(i) = det(numerM)/det(denomM);
end
if display
    figure
    clf
    hold on
    for i=1:p
        plot(i*[1 1],[0 pacfV(i)],'b','linewidth',2)
    end
    plot([0 p+1],[0 0],'k')
    xlabel('\tau')
    ylabel('\phi_{\tau\tau}')
    title('Partial autocorrelation')
end



