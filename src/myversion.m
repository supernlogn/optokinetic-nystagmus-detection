function flag = myversion
% flag = myversion
% Gives out a code number depending on the version of matlab running.
% OUTPUT
% flag = 0, if version is up to 7.1
% flag = 1, if version is from 7.2 up to 7.10
% flag = 2, if version is from 7.11 onwards 
% For a full list of Matlab versions see http://en.wikipedia.org/wiki/MATLAB

strS = version;
iV = find(strS=='.');
if length(iV)<2
    error('I cannot read version, I need at least two dots in the version string.');
end
hundreds = str2num(strS(1:iV(1)-1));
decades = str2num(strS(iV(1)+1:iV(2)-1));
matnumber = hundreds*100 + decades;
switch matnumber
    case {100,200,300,305,400,402,500,501,502,503,600,601,605,700,701}
        flag = 0;
    case {701,702,703,704}
        flag = 1;       
end
if matnumber > 704 && matnumber <804
    flag = 2;
end
if matnumber >= 805
    flag = 0;
end

% switch matnumber
%     case {100,200,300,305,400,402,500,501,502,503,600,601,605,700,701}
%         flag = 0;
%     case {701,702,703,704,705,706,707,708,709,710}
%         flag = 1;
% end
% if matnumber > 710
%     flag = 2;
% end
