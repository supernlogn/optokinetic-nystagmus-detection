% Detrending of a given time series assuming to have both trend and
% seasonal component.
% 1. Two methods to remove trend: polynomial fit, moving average smoothing
% 1. Two methods to remove seasonality: average seasonal component, moving 
% average smoothing
clear all
n = 1000;
sdnoise = 10;
mux = 20;
perseason = 12;
maxtau = 100;
alpha = 0.05;

zalpha = norminv(1-alpha/2);
xV = sdnoise * randn(n,1) + mux; % Gaussian iid time series
y1V = addseasonality(xV,perseason); % add seasonality
yV = addstochastictrend(y1V); % add stochastic trend

%%%%%% Remove trend using a moving average filter
figure(1)
clf
plot(yV,'.-')
hold on
xlabel('t')
ylabel('y(t)')
title('time series with trend and seasonality')

maorder = input('Remove trend: Give an order for the moving average filter: > ');
mu1V = movingaveragesmooth2(yV,maorder);
figure(2)
clf
plot(yV,'.-')
hold on
plot(mu1V,'.-r')
xlabel('t')
ylabel('y(t)')
title('time series with trend and seasonality')
legend('original',sprintf('MA(%d) smooth',maorder),'Location','Best')

x1V = yV - mu1V;
figure(3)
clf
plot(x1V,'.-')
xlabel('t')
ylabel('x(t)')
title(sprintf('detrended time series by MA(%d) smooth',maorder))

% Autocorrelation of the detrended time series by moving average filter 
acx1M = autocorrelation(x1V, maxtau);
autlim = zalpha/sqrt(n);
figure(6)
clf
hold on
for ii=1:maxtau
    plot(acx1M(ii+1,1)*[1 1],[0 acx1M(ii+1,2)],'b','linewidth',1.5)
end
plot([0 maxtau+1],[0 0],'k','linewidth',1.5)
plot([0 maxtau+1],autlim*[1 1],'--c','linewidth',1.5)
plot([0 maxtau+1],-autlim*[1 1],'--c','linewidth',1.5)
xlabel('\tau')
ylabel('r(\tau)')
title(sprintf('detrended time series by MA(%d) smooth, autocorrelation',maorder))

%%%%%% Remove trend using a polynomial fit
polorder = input('Remove trend: Give an order for the polynomial fit > ');
mu2V = polynomialfit(yV,polorder); 
figure(4)
clf
plot(yV,'.-')
hold on
plot(mu2V,'.-r')
xlabel('t')
ylabel('y(t)')
title('time series with trend and seasonality')
legend('original',sprintf('pol(%d) fit',polorder),'Location','Best')

x2V = yV - mu2V;
figure(5)
clf
plot(x2V,'.-')
xlabel('t')
ylabel('x(t)')
title(sprintf('detrended time series by pol(%d) smooth',polorder))

% Autocorrelation of the detrended time series by polynomial fit 
acx2M = autocorrelation(x2V, maxtau);
autlim = zalpha/sqrt(n);
figure(6)
clf
hold on
for ii=1:maxtau
    plot(acx2M(ii+1,1)*[1 1],[0 acx2M(ii+1,2)],'b','linewidth',1.5)
end
plot([0 maxtau+1],[0 0],'k','linewidth',1.5)
plot([0 maxtau+1],autlim*[1 1],'--c','linewidth',1.5)
plot([0 maxtau+1],-autlim*[1 1],'--c','linewidth',1.5)
xlabel('\tau')
ylabel('r(\tau)')
title(sprintf('detrended time series by pol(%d) smooth, autocorrelation',polorder))

%%%%%% Remove seasonality using a moving average filter
ma2order = input('Remove seasonality: Give the period to be estimated by moving average filter > ');
s1V = movingaverageseasonal(x2V,ma2order);
figure(7)
clf
plot(x2V,'.-')
hold on
plot(s1V,'.-r')
xlabel('t')
ylabel('x(t)')
title('time series with seasonality')
legend('original',sprintf('seasonal by MA(%d)-smooth',ma2order),'Location','Best')

z1x2V = x2V - s1V;
figure(8)
clf
plot(z1x2V,'.-')
xlabel('t')
ylabel('z(t)')
title(sprintf('deseasoned time series by MA(%d)-smooth',ma2order))

% Autocorrelation of the deseasoned time series using a moving average filter
acz1x2M = autocorrelation(z1x2V(~isnan(z1x2V)), maxtau);
autlim = zalpha/sqrt(n);
figure(9)
clf
hold on
for ii=1:maxtau
    plot(acz1x2M(ii+1,1)*[1 1],[0 acz1x2M(ii+1,2)],'b','linewidth',1.5)
end
plot([0 maxtau+1],[0 0],'k','linewidth',1.5)
plot([0 maxtau+1],autlim*[1 1],'--c','linewidth',1.5)
plot([0 maxtau+1],-autlim*[1 1],'--c','linewidth',1.5)
xlabel('\tau')
ylabel('r(\tau)')
title(sprintf('deseasoned time series by a MA(%d) smooth, autocorrelation',ma2order))
tittxt = sprintf('deseasoned time series by a MA(%d) smooth, Ljung-Box test',ma2order);
figure(10)
clf
[h1V,p1V,Q1V] = portmanteauLB(acz1x2M(2:maxtau+1,2),n,alpha,tittxt);

%%%%%% Remove seasonality using average seasonal component
per = input('Remove seasonality: Give the period to be estimated by average seasonal component > ');
s2V = seasonalcomponents(x2V,per);
figure(11)
clf
plot(x2V,'.-')
hold on
plot(s2V,'.-r')
xlabel('t')
ylabel('x(t)')
title('time series with seasonality')
legend('original',sprintf('ave seasonal comp (per=%d)',per),'Location','Best')

z2x2V = x2V - s2V;
figure(12)
clf
plot(z2x2V,'.-')
xlabel('t')
ylabel('z(t)')
title(sprintf('deseasoned time series by ave seasonal comp (per=%d)',per))

% Autocorrelation of of the deseasoned time series using average seasonal component
acz2x2M = autocorrelation(z2x2V, maxtau);
autlim = zalpha/sqrt(n);
figure(13)
clf
hold on
for ii=1:maxtau
    plot(acz2x2M(ii+1,1)*[1 1],[0 acz2x2M(ii+1,2)],'b','linewidth',1.5)
end
plot([0 maxtau+1],[0 0],'k','linewidth',1.5)
plot([0 maxtau+1],autlim*[1 1],'--c','linewidth',1.5)
plot([0 maxtau+1],-autlim*[1 1],'--c','linewidth',1.5)
xlabel('\tau')
ylabel('r(\tau)')
title(sprintf('deseasoned time series by ave seasonal comp (%d), autocorrelation',per))
tittxt = sprintf('deseasoned time series by ave seasonal comp (%d), Ljung-Box test',per);
figure(14)
clf
[h2V,p2V,Q2V] = portmanteauLB(acz2x2M(2:maxtau+1,2),n,alpha,tittxt);



