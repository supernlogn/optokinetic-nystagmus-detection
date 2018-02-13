function [v,R, fg] = corr_dim(xV, mmax, tau, plot_enabled)
% finds the correlation dimension given an array of data, for various embedded dimensions <= mmax 
% with delay time tau
% INPUTS:
%  xV          : vector of the scalar time series
%  mmax        : the maximum embedding dimension
%  tau         : the delay time
% plot_enabled : if to allow plotting the v to log(r) diagram.
% OUTPUTS:
%  v           : a [m x length(V) -(mmax-1)*tau -1 ] matrix with correlation dimension for different m and r
%  R           : the array of distances from  0.00001 to 100
%  fg          : a figure of the correlation dimension plot
  init_r = 0.00001;
  step_r = 1.1;
  end_r = 100;
  %  form points
  L = length(xV)-(mmax-1)*tau;
  X = zeros(length(xV)-(mmax-1)*tau, mmax);
  for i=0:mmax-1
      X(:,i+1) = xV(i*tau+1:L+i*tau);
  end
  v = [];
  fg = [];
  if(plot_enabled)
    fg = figure();
    hold on;
    grid on;
  end
  for m=1:1:mmax
    % calculate distance matrix
    Dmtx = pdist(X(:,1:m)); 
    % calulcate C(r)
    R = [];
    r = init_r;
    C = [];
    while(r < end_r)
        C = [C CS(r, Dmtx, L)];
        R = [R r];
        r = r * step_r;
    end
    % calculate v = dlog(C(r)) / dlog(r)
    lgC = log(C);
    % v_now = R(1:end-1) .* (C(2:end) - C(1:end-1)) / (step_r);
    v_now = (lgC(2:end) - lgC(1:end-1)) / log(step_r);
    v = [v; v_now];
    if(plot_enabled)
      plot(log(R(1:end-1)), v_now, 'DisplayName', sprintf('m=%d', m));
    end
  end

  if(plot_enabled)
    xlabel('log(r)');
    ylabel('$$v=\frac{dlog(C(r))}{dlog(r)}$$','Interpreter','latex');
    title('correlation dimension');
    legend('show');
  end
end

function C = CS(r, Dmtx, L)
  C = sum(Dmtx < r) / (L*(L-1.0) + eps);
end