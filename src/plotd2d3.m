function f = plotd2d3(xM, tittxt, symb)
% plotd2d3(xM, tittxt, symb)
% PLOTD2D3 makes two and three dimensional scatter diagrams.
% INPUTS
%  xM     : matrix of data points. If the number of columns 'm' 
%           is 2, then only a two dimensional scatter diagram is
%           plotted, otherwise the 3d-plot (x1,x2,xm) and the 
%           2d-plots (x1,x2) and (x1,xm) are plotted, where the 
%           vector components are given in each column in the 
%           order x1,x2,...,xm. 
%  tittxt : string to be displayed in the title
%  symb   : the symbol to be used for plotting. If not specified, 
%           simple dots are plotted.

[n,m] = size(xM);

if nargin <= 2
    symb = '.';
end
figno = gcf;
if m>2 
    f = figure(figno);
    clf;
    eval(['plot3(xM(:,1), xM(:,2), xM(:,m),''',symb,''')']);
    xlabel('x(k+1)');
    ylabel('x(k+2)');
    zlabel(['x(k+', int2str(m), ')']);
    title([tittxt]);
    % figure(figno+1)
    % clf
    % eval(['plot(xM(:,1), xM(:,2),''',symb,''')'])
    % xlabel('x(k+1)')
    % ylabel('x(k+2)')
    % title([tittxt])
    % figure(figno+2)
    % clf
    % eval(['plot(xM(:,1), xM(:,m),''',symb,''')'])
    % xlabel('x(k+1)')
    % ylabel(['x(k+', int2str(m), ')'])
    % title([tittxt])
else
    f = figure(figno);
    clf;
    eval(['plot(xM(:,1), xM(:,2),''',symb,''')']);
    xlabel('x(k+1)');
    ylabel('x(k+2)');
    title([tittxt]);
end

