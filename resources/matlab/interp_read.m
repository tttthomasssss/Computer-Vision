function lines = interp_read
%INTERP_READ Gets lines from user for interpretation tree demo
%    LINES = INTERP_READ uses GETLINE to get data, then converts into the
%    structure array used by the rest of the demo.
%
% See also INTERP_DEMO, GETLINE

% David Young, March 2002
% Copyright (c) University of Sussex

interp_axes;

disp('Draw a 2-D object using the mouse. Click with the left button');
disp('to create each corner except the last, then click the right');
disp('button for the last.');

[x, y] = getline;

% convert to set of lines rather than polyline
for i = 1:length(x)-1
    lines(i).linedata = [x(i); y(i); x(i+1); y(i+1)];
    lines(i).handle = [];
    lines(i).name = i;
    lines(i).type = 'm';            % assume model lines
end

end
